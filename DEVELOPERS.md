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
|           └───build-maven.sh                                    # build artifact with maven script.
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
|     └───script                                                  # script core ( example pathoy, shell, etc.)
|     └───modules                                                 # standars terraform modules
|           └───data.tf                                           # terraform data source of module core
|           └───locals.tf                                         # terraform locals declarative module core
|           └───main.tf                                           # princial code of module core
|           └───outputs.tf                                        # terraform output declarative of module core
|           └───provider.tf                                       # terraform provider of module core
|           └───variables.tf                                      # terraform variables of module core
|           └───terraform.tfvars                                  # terraform pricipal parameter of module core
|           └───aws-ec2-vpc-develops                              # terraform module vpn for develop enviroment
|                 └───LICENSE                                     # License declaration by iberia
|                 └───README.md                                   # document declarative of module
|                 └───main.tf                                     # princial code of module
|                 └───outputs.tf                                  # terraform output declarative of module
|                 └───variables.tf                                # terraform variables of module
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

the workflow uses different tools to complete different scenarios such as checking in to derivative repositories or running a code scan. to configure the tools it is necessary to configure the authentication secrets to step. more information to [secret github](https://docs.github.com/en/actions/security-guides/encrypted-secrets)

*Repository nexus:*
````
- name: Registy Artifact
      shell: bash
      env:
        # DNS hasn't content http:// or https://
        REPOSITORY_DNS: ${{secret.nexus-url}}
        REPOSITORY_USER: ${{secret.nexus-user}}
        REPOSITORY_PASS: ${{secret.nexus-pass}}
````

*sonarqube:*
````
 - name: Scan
      shell: bash
      env:
          SONAR_URL: ${{secret.sonar-url}}
          SONAR_USER: ${{secret.sonar-user}}
          SONAR_PASS: ${{secret.sonar-pass}}
````


Usages
----
can be referenced as follows:

- **Implementation continous integration:**
````
# Implementation for deployment to environment ( pull request event to branch )
on:
  pull_request:
    branches: [ develop ]
jobs:
- uses: ./.github/action/software/develop.yml@v1.0
  with:
    # Repository name with owner.
    # Default: ${{ github.repository }}
    repository: ''
    # Configutation DNS and credencials for access to repository artifact
    # Default
    artifact-repositoy-url: ''
    artifact-repositoy-token: ''
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
