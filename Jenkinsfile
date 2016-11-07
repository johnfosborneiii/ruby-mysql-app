node {
    stage 'Build image and deploy in Dev'
    echo 'Building docker image and deploying to Dev'
    buildApp('app-dev')

    stage 'Approve for QA'
    input 'Approve to QA?'

    stage 'Deploy to QA'
    echo 'Deploying to QA'
    deployApp('app-dev', 'app-qa')

    stage 'Approve for Production'
    input 'Approve to Production?'

    stage 'Deploy to production'
    echo 'Deploying to production'
    deployApp('app-dev', 'app-prod')
}

// Creates a Build and triggers it
def buildApp(String project){
    sh "oc login https://openshift.josborne.com:8443 --insecure-skip-tls-verify -u josborne -p redhat 
    sh "oc project ${project}"
    sh "oc start-build ruby-mysql"
}

// Tag the ImageStream from an original project to force a deployment
def deployApp(String origProject, String project){
    sh "oc project ${project}"
    sh "oc policy add-role-to-user system:image-puller system:serviceaccount:${project}:default -n ${origProject}"
    sh "oc tag ${origProject}/ruby-mysql:latest ${project}/ruby-mysql:latest"
    appDeploy()
}

// Deploy the project based on an existing ImageStream
def appDeploy(){
    sh "oc new-app ruby-mysql || echo 'Application already Exists'"
    sh "oc expose service ruby-mysql || echo 'Service already exposed'"
    sh "oc env dc/mysql --list | grep MYSQL | oc env dc/ruby-mysql -e -"
}
