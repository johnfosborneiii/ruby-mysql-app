node {
    stage 'Build image and deploy in Dev'
    echo 'Building docker image and deploying to Dev'
    //git url: 'https://github.com/tariq-islam/ruby-mysql-app -b ocp33-pipeline'
    checkout scm: [$class: 'GitSCM', branches: [[name: '*/ocp33-pipeline']], userRemoteConfigs: [[url: 'https://github.com/tariq-islam/ruby-mysql-app']]]
    buildApp('ruby-mysql-app-dev')

    stage 'Deploy to QA'
    echo 'Deploying to QA'
    deployApp('ruby-mysql-app-dev', 'ruby-mysql-app-qa')
 
    stage 'Wait for approval'
    input 'Approve to production?'

    stage 'Deploy to production'
    echo 'Deploying to production'
    deployApp('ruby-mysql-app-dev', 'ruby-mysql-app')
}

// Creates a Build and triggers it
def buildApp(String project){
    sh "oc login https://192.168.122.124:8443 --insecure-skip-tls-verify -u openshift-dev -p devel"
    sh "oc new-project ${project} && oc create -f ruby-mysql-app-bc.yml || oc project ${project}"
    sh "oc start-build ruby-mysql-app"
    appDeploy()
}

// Tag the ImageStream from an original project to force a deployment
def deployApp(String origProject, String project){
    sh "oc project ${project} || oc new-project ${project}"
    sh "oc policy add-role-to-user system:image-puller system:serviceaccount:${project}:default -n ${origProject}"
    sh "oc tag ${origProject}/ruby-mysql-app:latest ${project}/ruby-mysql-app:latest"
    appDeploy()
}

// Deploy the project based on an existing ImageStream
def appDeploy(){
    sh "oc new-app mysql-ephemeral || echo 'Database already exists'"
    sh "oc new-app ruby-mysql-app || echo 'Application already Exists'"
    sh "oc expose service ruby-mysql-app || echo 'Service already exposed'"
    sh "oc env dc/mysql --list | grep MYSQL | oc env dc/ruby-hello-world -e -"
}

