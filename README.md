The following are instructions on how to deploy this sample persistent ruby application in OpenShift 3

## Create the application
oc new-app https://github.com/tariq-islam/ruby-hello-world --strategy=docker
- OR -
Select the ruby builder image and point it to the github url here

## Create a MySQL database (default values are fine)

## Create route if need be
In the web console, click the "Create a Route" link on the service

## Pipe the mysql env vars into the dc of the application
oc env dc/mysql --list | grep MYSQL | oc env dc/ruby-hello-world -e -

## Profit.


### For instructions on other ways of how to use it, please see: https://github.com/openshift/origin/blob/master/examples/sample-app/README.md

