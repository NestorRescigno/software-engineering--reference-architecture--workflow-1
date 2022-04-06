## Configuration and procedure for developers
## by Software Engineering

Index
---
- [Overview](#Overview)
- [Basic requirements](#Basic-requirements)
- [Repository structure](#Repository-structure)
- [Getting started](#Getting-started)
- [Usages](#Usages)
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
│.github/action               # workflow github action core
|     └───infrastructure      # action core to create automatic infraestructure
|     └───software            # action core to deploy automatic software
│___module                    # standars module core
|     └───script              # script core ( example pathoy, shell, etc.)
|     └───terrafom            # standars terrafom module core
│___docs                      # document attached
│     └───decisions           # strategy decisions 
│___images
│     └───docs
|           └───contributing                                         #informative picture.
|                   └───sample.jpg                                   #sample picture
│           └───developers                                           #informative picture.
│                   └───sample.jpg                                   #sample picture
|           └───project-template                                     #informative picture.
|                   └───Deployment-Infrastructure.png                #deployment infrastructure design
|                   └───DeploperFlow.png                             #deployment software design
|                   └───vpc-network.png                              #Architeture network cloud design
|                   └───README.md                                    #Document description design
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



Usages
----
can be referenced as follows:

- **Implementation for desployment to develop environment:**
````
# Implementation for deployment to develop environment ( pull request event to develop branch )
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
    artifact-repositoy: ''
    artifact-repositoy-token: ''
````
- **Implementation for desployment to publish environment and tagging technical release:**
````
# Implementation for deployment to publish environment ( pull request event to main branch)
on:
  pull_request:
    branches: [ main ]
jobs:
- uses: ./.github/action/software/release.yml@v1.0
  with:
    # Repository name with owner.
    # Default: ${{ github.repository }}
    repository: ''
    # Configutation DNS and credencials for access to repository artifact
    # Default
    artifact-repositoy: ''
    artifact-repositoy-token: ''
    # Configutation DNS and credencials for access to scan software tools
    # Default
    scan-url: '' 
    scan-token: ''
    # Configutation DNS and credencials for access to vulnerability tools
    # Default
    vulnerability-url: '' 
    vulnerability-token: ''
````

Conventions
----

Workflow
----
