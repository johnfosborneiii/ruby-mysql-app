#!/bin/bash

echo "Please enter your OpenShift hostname:port (https://<hostname>:<port>). The default used is the CDK @ https://10.1.2.2:8443: "

read hostname

jenkins_image="jenkins-ephemeral"

if [ -z "$hostname" ]; then
    hostname="https://10.1.2.2:8443"
    jenkins_image="jenkins"
fi
 
echo "Enter your username (default is openshift-dev): "

read username

if [ -z "$username" ]; then
	username="openshift-dev"
fi

echo "Enter the url for your repository. If it's a specific branch you'd like to use, please append the branch to the url with '#<branch_name>' [default: https://github.com/johnfosborneiii/ruby-mysql-app#ocp33-pipeline]: "

read repository_path

if [ -z "$repository_path" ]; then
    repository_path="https://github.com/johnfosborneiii/ruby-mysql-app#ocp33-pipeline"
    echo "Using default repository at : " $repository_path
fi


oc login "$hostname" --insecure-skip-tls-verify -u "$username"
oc new-project app-dev --display-name="Application Development Environment"
oc new-app --name=ruby-mysql "$repository_path"
oc expose service ruby-mysql
oc new-app mysql-ephemeral
oc new-app "$jenkins_image" -p JENKINS_PASSWORD=password
oc env dc/mysql --list | grep MYSQL | oc env dc/ruby-mysql -e -
oc create -f ruby-mysql-app-pipeline-bc.yml 
oc new-project app-qa --display-name="Application QA Environment"
oc new-app mysql-ephemeral
oc new-project app-prod --display-name="Application Production Environment"
oc new-app mysql-ephemeral
