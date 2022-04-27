# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************
# set variable
project = $1
repository = $2
format = $3

# create domain with name product/project
# aws codeartifact create-domain --domain ${{project}}

# Returns the endpoint of a repository for a specific package format. A repository has one endpoint for each package format: npm, pypi, maven
# aws codeartifact get-repository-endpoint --domain ${{project}} --repository ${{repository}} --format ${{format}} 
# output:
# {
#    "repositoryEndpoint": "https://test-domain-111122223333.d.codeartifact.us-west-2.amazonaws.com/npm/test-repo/"
# }

# The following get-package-version-asset example retrieves the package.tgz asset for version 4.0.0 of an npm package named test-package.
aws codeartifact get-package-version-asset --domain test-domain --repository test-repo --format npm --package test-package --package-version 4.0.0 --asset 'package.tgz' outfileName
#Output:
#The output for this command will also store the raw asset in the file provided in place of outfileName.
#{
#    "assetName": "package.tgz",
#    "packageVersion": "4.0.0",
#    "packageVersionRevision": "Ciqe5/9yicvkJT13b5/LdLpCyE6fqA7poa9qp+FilPs="
#}
