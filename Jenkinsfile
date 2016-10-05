node {
    stage 'Build image and deploy in Dev'
    echo 'Building docker image and deploying to Dev'
    buildAloha('ruby-mysql-app-dev')

    stage 'Deploy to QA'
    echo 'Deploying to QA'
    deployAloha('ruby-mysql-app-dev', 'ruby-mysql-app-qa')
 
    stage 'Wait for approval'
    input 'Approve to production?'

    stage 'Deploy to production'
    echo 'Deploying to production'
    deployAloha('ruby-mysql-app-dev', 'ruby-mysql-app')
}

// Creates a Build and triggers it
def buildAloha(String project){
    sh "oc login https://192.168.122.124:8443 --insecure-skip-tls-verify -u openshift-dev -p devel"
    sh "oc project ${project}"
    sh "oc start-build ruby-mysql-app"
    appDeploy()
}

// Tag the ImageStream from an original project to force a deployment
def deployAloha(String origProject, String project){
    sh "oc login -u openshift-dev -p devel"
    sh "oc project ${project}"
    sh "oc policy add-role-to-user system:image-puller system:serviceaccount:${project}:default -n ${origProject}"
    sh "oc tag ${origProject}/ruby-mysql-app:latest ${project}/ruby-mysql-app:latest"
    appDeploy()
}

// Deploy the project based on an existing ImageStream
def appDeploy(){
    sh "oc new-app ruby-mysql-app || echo 'Application already Exists'"
    sh "oc expose service ruby-mysql-app || echo 'Service already exposed'"
}

