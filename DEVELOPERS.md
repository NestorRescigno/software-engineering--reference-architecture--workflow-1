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

## Getting started

How to setup environment

## Usages
the implementation of the workflow in the different repositories of the source code for use. can be referenced as follows:
> **Recommendation:** Don't directly implement this flow in source repositories. use an intermediate repository where you can configure the different tools (exemple sonar, veracode, etc). and that it can be executed, for example, by means of [weebhook](https://docs.github.com/en/github-ae@latest/developers/webhooks-and-events/webhooks/about-webhooks). This configuration allows to separate the repository from the workflow.
````
- uses: ./.github/action/software/develop.yml
  with:
    # Repository name with owner.
    # Default: ${{ github.repository }}
    repository: ''

    # The branch, tag or SHA to checkout. When checking out the repository that
    # triggered a workflow, this defaults to the reference or SHA for that event.
    # Otherwise, uses the default branch.
    ref: ''

    # Personal access token (PAT) used to fetch the repository. The PAT is configured
    # with the local git config, which enables your scripts to run authenticated git
    # commands. The post-job step removes the PAT.
    #
    # We recommend using a service account with the least permissions necessary. Also
    # when generating a new PAT, select the least scopes necessary.
    #
    # [Learn more about creating and using encrypted secrets](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/creating-and-using-encrypted-secrets)
    #
    # Default: ${{ github.token }}
    token: ''

    # SSH key used to fetch the repository. The SSH key is configured with the local
    # git config, which enables your scripts to run authenticated git commands. The
    # post-job step removes the SSH key.
    #
    # We recommend using a service account with the least permissions necessary.
    #
    # [Learn more about creating and using encrypted secrets](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/creating-and-using-encrypted-secrets)
    ssh-key: ''

    # Known hosts in addition to the user and global host key database. The public SSH
    # keys for a host may be obtained using the utility `ssh-keyscan`. For example,
    # `ssh-keyscan github.com`. The public key for github.com is always implicitly
    # added.
    ssh-known-hosts: ''

    # Whether to perform strict host key checking. When true, adds the options
    # `StrictHostKeyChecking=yes` and `CheckHostIP=no` to the SSH command line. Use
    # the input `ssh-known-hosts` to configure additional hosts.
    # Default: true
    ssh-strict: ''

    # Whether to configure the token or SSH key with the local git config
    # Default: true
    persist-credentials: ''

    # Relative path under $GITHUB_WORKSPACE to place the repository
    path: ''

    # Whether to execute `git clean -ffdx && git reset --hard HEAD` before fetching
    # Default: true
    clean: ''

    # Number of commits to fetch. 0 indicates all history for all branches and tags.
    # Default: 1
    fetch-depth: ''

    # Whether to download Git-LFS files
    # Default: false
    lfs: ''

    # Whether to checkout submodules: `true` to checkout submodules or `recursive` to
    # recursively checkout submodules.
    #
    # When the `ssh-key` input is not provided, SSH URLs beginning with
    # `git@github.com:` are converted to HTTPS.
    #
    # Default: false
    submodules: ''
````

## Conventions

## Workflow

