# What This Is For?
With integrated pipelines being a great new feature (albeit in tech preview status currently) released with OpenShift 3.3, I wanted to put together an easy way for folks to try it out beyond the simplistic example that's included OOTB. This example takes a ruby application backed by an ephemeral mysql database, and promotes dev builds across multiple environments automatically, while also asking the user for approval input before deploying into each higher level environment. The flow is as follows:

> 1. Execute the build pipeline
> 2. A new build and deploy executes in the dev environment
> 3. The pipeline asks for approval prior to promoting to QA
> 4. The pipeline deploys to the QA environment upon approval
> 5. The pipeline asks for approval prior to promoting to Production
> 6. The pipeline deploys to the Production environment upon approval

In order to use this example, you just need an OpenShift instance and the oc client tool.
<br>
> As a side note, I'm working on parameterizing this more so that the following isn't as tedious.
<br>

# How To Set This Up
+ You need internet connectivity for this... I'm working on making this completely offline, so more to come there.
+ __Fork this repo!__ You'll want to be able to make code changes and roll them out across environments.
+ __Edit and commit__ the _ruby-mysql-app-pipeline-bc.yml_ file so that the git uri on line 10 points to your fork.
+ __Edit and commit__ the _pipeline-setup.sh_ file such that on lines 7 and 10, you're pointing to your fork. Again note that I'm pointing to a specific branch whereas you may not.
+ __Edit and commit__ the _Jenkinsfile_ on line 23, provide your specific ip/host:port and login information
+ Clone your repository locally

```
git clone https://github.com/<your-git>/ruby-mysql-app
```

+ Similar a previous step, you can uncomment out line #5 in the _pipeline-setup.sh_ file and provide your specific ip/host:port and login information, or simply oc login before running the setup script.
+ Run the pipeline-setup.sh script (don't forget to change permissions on the file to make it executable)

```
./pipeline-setup.sh
```

+ Check your OpenShift environment. The script should have set up three projects for you (App Dev, App QA, and App Production).
+ Check out the Overview for the App Dev project, the script should have provisioned the following:
	+ A Jenkins (ephemeral) instance (credentials are _admin/password_)
	+ A mysql ephemeral instance (this has been provisioned in each environment)
	+ An initial deployment of your fork of the ruby mysql application

+ Click on _Builds --> Pipelines_, and you should see a pipeline already configured. Feel free to look through its configuration and note that it's pointing to the Jenkinsfile that's part of your repository.
+ Click on _Start Pipeline_ at the top right of the _Pipelines_ screen. The pipeline will begin to run and will walk you through the workflow as described above, asking for input/approval where necessary.

> One point of caution -- be sure that the Development build completes and the image is pushed into the repository _before_ you approve a deployment into QA or Prod. If you approve into QA or Prod before the newly built image is pushed into the registry from Dev, you'll end up with a bit of a race condition where QA and Prod simply redeploy the now older image.

<br>

Lastly, note that the Jenkinsfile does make sure to inject the appropriate mysql environment variables into the application instance per environment
