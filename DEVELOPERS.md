## Overview

Architecture and technology overview, description of packages, dependencies, tools are used

## Basic requirements

pre installed software is needed for development

## Getting started

How to setup environment

## Conventions

This project is following [Google Java Style Guide - for example]

[Requirements for test coverage, linters, additional project rules]

## Workflow

### Github Flow, as default for Product-based development

GitHub flow is a lightweight, branch-based workflow that supports teams and projects where deployments are made regularly. This guide explains how and why GitHub flow works.

The essence if Github Flow is explained in 6 points:

- Anything in the 'main' branch is deployable
- To work on something new, create a descriptively named branch off of 'main' (ie: new-oauth2-scopes)
- Commit to that branch locally and regularly push your work to the same named branch on the server
- When you need feedback or help, or you think the branch is ready for merging, open a pull request
- After someone else has reviewed and signed off on the feature, you can merge it into 'main'
- Once it is merged and pushed to 'main', you can and should deploy immediately

We refer to Github documentation for and [introduction](https://guides.github.com/introduction/flow/) and [deeper details]https://docs.github.com/en/get-started/quickstart/github-flow().

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

### Semantic Release and Conventional Changelog

Releasing of new Group IT Standards versions is automatically managed by [Semantic Release][].
Semantic Release makes sure correct version numbers get bumped according to the **meaning**
of your changes once your PR gets merged to `main`.

To make it work, it's necessary to follow [Conventional Changelog][]. That basically
means all commit messages in the project should follow a particular format:

```
<type>: <subject>
```

Where `<type>` is:

- `feat` - New functionality added
- `fix` - Broken functionality fixed
- `perf` - Performance improved
- `docs` - Documentation added/removed/improved/...
- `chore` - Package setup, CI setup, ...
- `refactor` - Changes in code, but no changes in behavior
- `test` - Tests added/removed/improved/...

In the rare cases when your changes break backwards compatibility, the message
must include string `BREAKING CHANGE:`. That will result in bumping the major version.

Seems hard?

- See [existing commits][] as a reference
- [Commitizen CLI][] can help you to create correct commit messages
- `npm run lint` validates format of your messages



[Semantic Release]: https://github.com/semantic-release/semantic-release
[Conventional Changelog]: https://github.com/conventional-changelog/conventional-changelog
[Commitizen CLI]: https://github.com/commitizen/cz-cli
[existing commits]: https://gitlab.com/dparra0007-IAGGBS/technical-architecture/application-standards/commits/master

[upstream repository]: https://github.com/apiaryio/dredd
[issues]: ISSUE_TEMPLATE.md
[Pull Request]: PULL_REQUEST_TEMPLATE.md
