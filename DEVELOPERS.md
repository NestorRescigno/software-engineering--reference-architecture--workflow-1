## Configuration and procedure for developers
## by Software Engineering

Index
---
- [Overview](#Overview)
- [Basic requirements](#Basic-requirements)
- [Repository structure](#Repository-structure)
- [Getting started](#Getting-started)
- [Usages](#Usages)
- [Repository flow](#Repository-flow)
- [Conventions](#Conventions)

Overview
----
Architecture and technology overview, description of packages, dependencies, tools are used

Basic requirements
----
pre installed software is needed for development

Repository structure
----
````
main
│.github/action                                                   # workflow github action core
|     └───action.yml                                              # workflow deploy to environment with pull request
|     └───utils                                                   # utils script core for step action
|           └───build-image.sh                                    # build image ami aws.
|           └───build.sh                                          # build artifact with maven or node.
|           └───checkout.sh                                       # checkout source code from git.
|           └───configure-cloud-credentials.sh                    # configure cloud credentials access.4
|           └───get-tools.sh                                      # installe tools cliente.
|           └───get-version-pom.sh                                # get version form pom.xml maven.
|           └───health-checking.sh                                # health checking instance in cloud.
|           └───nexus-registry.sh                                 # script upload artifact to registry nexus
|           └───script-note.md                                    # diferente note to scripts
|           └───setup-java.md                                     # install jdk java in runner.
|           └───sonar-scanner.sh                                  # script scan code with sonarqube
|           └───terraform-deploy.sh                               # terraform plan and apply deploy module.
│___terrafom                                                      # standars terraform module core
|     └───modules                                                 # standars terraform modules
|           └───aws-ec2-deploy-iberia                             # terraform module lanch template deploy iberia
|                 └───README.md                                   # document declarative of module
|                 └───main.tf                                     # princial code of module core
|                 └───outputs.tf                                  # terraform output declarative of module core
|                 └───variables.tf                                # terraform variables of module core
|           └───aws-ec2-image-iberia                              # terraform module build image iberia: base ubuntu
|                 └───README.md                                   # document declarative of module
|                 └───main.tf                                     # princial code of module core
|                 └───outputs.tf                                  # terraform output declarative of module core
|                 └───variables.tf                                # terraform variables of module core
|           └───aws-ec2-instance-iberia                           # terraform module instance up iberia: base ubuntu
|                 └───README.md                                   # document declarative of module
|                 └───main.tf                                     # princial code of module core
|                 └───outputs.tf                                  # terraform output declarative of module core
|                 └───variables.tf                                # terraform variables of module core
|           └───aws-ec2-vpc-iberia                                # terraform module vpn iberia for create environment
|                 └───README.md                                   # document declarative of module
|                 └───data.tf                                     # terraform data source of module core
|                 └───locals.tf                                   # terraform locals declarative module core
|                 └───main.tf                                     # princial code of module core
|                 └───outputs.tf                                  # terraform output declarative of module core
|                 └───provider.tf                                 # terraform provider of module core
|                 └───variables.tf                                # terraform variables of module core
|                 └───terraform.tfvars                            # terraform pricipal parameter of module coreç
|           └───aws-ec2-monitoring-iberia                         # terraform module monitoring iberia asigned to service and environment
|                 └───README.md                                   # document declarative of module
|                 └───data.tf                                     # terraform data source of module core
|                 └───locals.tf                                   # terraform locals declarative module core
|                 └───main.tf                                     # princial code of module core
|                 └───outputs.tf                                  # terraform output declarative of module core
|                 └───provider.tf                                 # terraform provider of module core
|                 └───variables.tf                                # terraform variables of module core
│___docs                                                          # document attached
│     └───decisions                                               # strategy decisions 
│___images
│     └───docs
|           └───contributing                                      # Informative picture.
|                   └───sample.jpg                                # sample picture
│           └───developers                                        # Informative picture.
│                   └───sample.jpg                                # sample picture
|           └───project-template                                  # Informative picture.
|                   └───Deployment-Infrastructure.png             # deployment infrastructure design
|                   └───DeploperFlow.png                          # deployment software design
|                   └───vpc-network.png                           # Architeture network cloud design
|                   └───README.md                                 # Document description design
│CHANGELOG.md
│CODE_OF_CONDUCT.md
│CONTRIBUTING.md
│DEVELOPERS.md
│README.md
│pom.xml
````
Getting started
----

The implementation of the workflow in the different repositories of the source code for use.

> **Recommendation:** Don't directly implement this flow in source repositories. Use an intermediate repository where you can configure the different tools (exemple sonar, veracode, etc). and that it can be executed, for example, by means of [weebhook](https://docs.github.com/en/github-ae@latest/developers/webhooks-and-events/webhooks/about-webhooks). This configuration allows to separate the repository from the workflow.

the workflow uses different tools to complete different scenarios such as checking in to derivative repositories or running a code scan. to configure the tools it is necessary to configure the authentication secrets. more information to [secret github](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
see [Usages](#usages) implementation

### Terraform modules:
github workflow using terraform to creates and applies an infrastructure using the vpc module firt time. the [aws-ec2-vpc-iberia](https://github.com/Iberia-Ent/software-engineering--reference-architecture--workflow/blob/main/terraform/modules/aws-ec2-vpc-iberia/README.md) module is configured by environment through the file **terraform.tfvars** content:
`````
## Global variables
service_name       = "<service name>"
environment_prefix = "<environment prefix name>"
project            = "<project name>"                     # this name is present in domain <project name>.<domain>
environment        = "<enviroment name>"
aws_region         = "<regione name>"                     # default: "eu-central-1"
global_dns         = "<domain>"                           # default: "cloud.iberia.local"
bucket_name        = "<bucket name>"                      # set s3 backet for log
bucket_key         = "<bucket key>"                       # set s3 backet for log
dynamodb_table     = "<dynamo db>"
kms_key_id         = "<kms id>" 
role_arn           = "<regione name>"                     # AIM role aws
`````

to create an instance from an **ubuntu** image the following module [aws-ec2-instance-iberia](https://github.com/Iberia-Ent/software-engineering--reference-architecture--workflow/blob/main/terraform/modules/aws-ec2-instance-iberia/README.md)  is used , this allows to obtain an instance ready for application without keeping an image, while the image module [aws-ec2-image-iberia](https://github.com/Iberia-Ent/software-engineering--reference-architecture--workflow/blob/main/terraform/modules/aws-ec2-image-iberia/README.md)  is complementary to the instance module and It'll create an image from instance generate.

the deployment step of the workflow receives the publish aws AMI image and instantiates it on ec2, use module [aws-ec2-deploy-iberia](https://github.com/Iberia-Ent/software-engineering--reference-architecture--workflow/blob/main/terraform/modules/aws-ec2-deploy-iberia/README.md) 

To finish the monitoring module [aws-ec2-monitoring](https://github.com/Iberia-Ent/software-engineering--reference-architecture--workflow/blob/main/terraform/modules/aws-ec2-monitoring/README.md), associate the service and infrastructure to the monitoring tools of alert, logging, etc. for example cloudwatch.


Usages
----
can be referenced as follows:

- **Implementation continous integration:**
````
# Implementation for deployment to environment ( pull request event to branch )

- uses: ./.github/action/action.yml@v1.0
  with:
    project-name:                                     # Product global name example: 'bestpratices' - require true, use in dns name
    lenguage-code:                                    # lenguage programming code for example: java or angular - require true  
    testIntegration:                                  # run integration test, soap request or rest  default: false
    testIntegration-path:                             # test xml integration path default: '${{ github.workspace }}'
    scancode:                                         # control scan code default: false
    sonarqube-host: ${{secret.sonar-url}}             # host control quality code with sonar - optional
    sonarqube-user: ${{secret.sonar-user}}            # user control quality code with sonar - optional
    sonarqube-token:${{secret.sonar-token}}           # pwd control quality code with sonar - optional
    sonarqube-client-version:                         # client sonar-scanner use. see https://binaries.sonarsource.com/?prefix=Distribution/sonar-scanner-cli/
    repository-DNS:  ${{secret.nexus-url}}            # host registry artifact
    repository-user: ${{secret.nexus-user}}           # user registry artifact
    repository-token:${{secret.nexus-pass}}           # pass registry artifact
    aws-environment-name:                             # Environment name for default: 'production'
    aws-environment-prefix:                           # Environment prefix name for default: 'pro'
    aws-access-key:                                   # access key aws publish environment ( example: Integration, preproduction, quality)
    aws-secret-acesss-key:                            # secret access key aws publish environment ( example: Integration, preproduction, quality)
    aws-environment-dev-name:                         # Development environment name for default: 'development'
    aws-environment-dev-prefix:                       # Development environment prefix name for default: 'dev'
    aws-access-key-dev:                               # access key aws development environment
    aws-secret-acesss-key-dev:                        # secret access key aws development environment 
````

- **private configuration**

considering that there is an environment dedicated to the operations and preservation of images that may be hosted in another account in the cloud.
the account setup credentials have been included directly in the "image" step of the workflow as secrets configured in the repo itself. in the following you can see the variables to complete with the secret. more information to [github secret](https://docs.github.com/en/actions/security-guides/encrypted-secrets)

````
image:
    name: image
    runs-on: [self-hosted]
    outputs:
      image-number-id:
        description: "image number id"
        value: ${{ steps.image-generator.outputs.image-id }}
    env:
      ...   
      AWS_ACCESS_KEY_OP: ${{secret.aws-access-key-op}}                   
      AWS_SECRET_ACCESS_KEY_OP: ${{ secret.aws-secret-access-key-op}}
      ...
````
Repository flow 
----
We have two working methods within the context of the repositories available in the reference architecture

### Github Flow, as default for Product-based development

GitHub flow is a lightweight, branch-based workflow that supports teams and projects where deployments are made regularly. This guide explains how and why GitHub flow works.

The essence if Github Flow is explained in 6 points:

- Anything in the 'main' branch is deployable
- To work on something new, create a descriptively named branch off of 'main' (ie: new-oauth2-scopes)
- Commit to that branch locally and regularly push your work to the same named branch on the server
- When you need feedback or help, or you think the branch is ready for merging, open a pull request
- After someone else has reviewed and signed off on the feature, you can merge it into 'main'
- Once it is merged and pushed to 'main', you can and should deploy immediately

We refer to Github documentation for and [introduction](https://guides.github.com/introduction/flow/) and [deeper details](https://docs.github.com/en/get-started/quickstart/github-flow()).

### Git Flow, for applications that require Integration Environments 

We refer Integration Environments as a [Enterprise-wide integration test environments](https://www.thoughtworks.com/radar/techniques/enterprise-wide-integration-test-environments). In such case, it's necessary to keep running non-production environments that replacates the production behaviour with it's integrations.

Gitflow Workflow is a Git workflow that helps with continuous software development and implementing DevOps practice. Gitflow is ideally suited for projects that have a scheduled release cycle:

- The workflow is great for a release-based software workflow.
- Gitflow offers a dedicated channel for hotfixes to production.

The overall flow of Gitflow is:

- A develop branch is created from main
- A release branch is created from develop
- Feature branches are created from develop
- When a feature is complete it is merged into the develop branch
- When the release branch is done it is merged into develop and main
- If an issue in main is detected a hotfix branch is created from main
- Once the hotfix is complete it is merged to both develop and main

More detailed description on how to implement a gitflow is explained [here](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow).

Conventions
----
