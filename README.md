# Create the application
oc new-app https://github.com/tariq-islam/ruby-hello-world --strategy=docker

# Create route if need be

# Pipe the mysql env vars into the dc of the application
oc env dc/mysql --list | grep MYSQL | oc env dc/ruby-hello-world -e -

# profit.

This is a sample openshift v3 application repository.  

For instructions on how to use it, please see: https://github.com/openshift/origin/blob/master/examples/sample-app/README.md

