#!/bin/bash


oc login https://192.168.122.124:8443 --insecure-skip-tls-verify -u openshift-dev -p devel
oc new-project ruby-mysql-app-dev --display-name="Application Development Environment"
oc new-app --name=ruby-mysql-app https://github.com/tariq-islam/ruby-mysql-app#ocp33-pipeline
oc new-app mysql-ephemeral
oc new-app jenkins-ephemeral -p JENKINS_PASSWORD=password
oc env dc/mysql --list | grep MYSQL | oc env dc/ruby-mysql-app -e -
oc create -f https://raw.githubusercontent.com/tariq-islam/ruby-mysql-app/ocp33-pipeline/ruby-mysql-app-pipeline-bc.yml
oc new-project ruby-mysql-app-qa --display-name="Application QA Environment"
oc new-app mysql-ephemeral
oc new-project ruby-mysql-app --display-name="Application Production Environment"
oc new-app mysql-ephemeral
