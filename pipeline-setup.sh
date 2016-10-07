#!/bin/bash

echo "Please enter your OpenShift hostname:port (https://<hostname>:<port>):"

read hostname

echo "Enter your username: "

read username

oc login "$hostname" --insecure-skip-tls-verify -u "$username"
oc new-project app-dev --display-name="Application Development Environment"
oc new-app --name=ruby-mysql https://github.com/tariq-islam/ruby-mysql-app#ocp33-pipeline
oc expose service ruby-mysql
oc new-app mysql-ephemeral
oc new-app jenkins-ephemeral -p JENKINS_PASSWORD=password
oc env dc/mysql --list | grep MYSQL | oc env dc/ruby-mysql -e -
oc create -f https://raw.githubusercontent.com/tariq-islam/ruby-mysql-app/ocp33-pipeline/ruby-mysql-app-pipeline-bc.yml
oc new-project app-qa --display-name="Application QA Environment"
oc new-app mysql-ephemeral
oc new-project app-prod --display-name="Application Production Environment"
oc new-app mysql-ephemeral

