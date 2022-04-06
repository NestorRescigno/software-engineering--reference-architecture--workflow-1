## Configuration and procedure for developers
## by Software Engineering

INDEX
---
- [Overview](#Overview)
- [Basic requirements](#Basic-requirements)
- [Repository structure](#Repository-structure)
- [Getting started](#Getting-started)
- [Usages](#Usages)
- [Conventions](#Conventions)

## Overview

Architecture and technology overview, description of packages, dependencies, tools are used

## Basic requirements

pre installed software is needed for development

## Repository structure
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
## Getting started

The implementation of the workflow in the different repositories of the source code for use. 
> **Recommendation:** Don't directly implement this flow in source repositories. Use an intermediate repository where you can configure the different tools (exemple sonar, veracode, etc). and that it can be executed, for example, by means of [weebhook](https://docs.github.com/en/github-ae@latest/developers/webhooks-and-events/webhooks/about-webhooks). This configuration allows to separate the repository from the workflow.

## Usages
can be referenced as follows:

- **Implementation for desployment to develop environment:**
````
# Implementation for desployment to develop environment
- uses: ./.github/action/software/develop.yml
  with:
    # Repository name with owner.
    # Default: ${{ github.repository }}
    repository: ''

    # The branch, tag or SHA to checkout. When checking out the repository that
    # triggered a workflow, this defaults to the reference or SHA for that event.
    # Otherwise, uses the default branch.
    ref: ''
````
- **Implementation for desployment to publish environment and tagging technical release:**
````
# Implementation for desployment to publish environment
- uses: ./.github/action/software/release.yml
  with:
    # Repository name with owner.
    # Default: ${{ github.repository }}
    repository: ''

    # The branch, tag or SHA to checkout. When checking out the repository that
    # triggered a workflow, this defaults to the reference or SHA for that event.
    # Otherwise, uses the default branch.
    ref: ''
````

## Conventions

## Workflow

