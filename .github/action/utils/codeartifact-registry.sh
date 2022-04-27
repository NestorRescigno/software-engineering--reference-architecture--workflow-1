# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************

# setting variable
LANGUAGE            = ${{ env.LANGUAGE }} 
REF                 = ${{ github.ref }} 
GROUPID             = ${{ env.GROUP }}
ARTIFACTID          = ${{ env.ARTIFACT  }} 
VERSION             = ${{ env.VERSION }}
PACKAGE-TYPE        = ${{ env.PACKAGE }}

# setting contants
PATH-SNAPSHOTS      = "/repository/snapshots/"
PATH-RELEASE        = "/repository/releases/"
PATH-NPM-PRIVATE    = "/npm-private/release/"

# create domain with name product/project
# aws codeartifact create-domain --domain ${{project}}

# Returns the endpoint of a repository for a specific package format. A repository has one endpoint for each package format: npm, pypi, maven
# aws codeartifact get-repository-endpoint --domain ${{project}} --repository ${{repository}} --format ${{format}} 
# output:
# {
#    "repositoryEndpoint": "https://test-domain-111122223333.d.codeartifact.us-west-2.amazonaws.com/npm/test-repo/"
# }

# The following get-package-version-asset example retrieves the package.tgz asset for version 4.0.0 of an npm package named test-package.
# aws codeartifact get-package-version-asset --domain test-domain --repository test-repo --format npm --package test-package --package-version 4.0.0 --asset 'package.tgz' outfileName
# Output:
# The output for this command will also store the raw asset in the file provided in place of outfileName.
# {
#    "assetName": "package.tgz",
#    "packageVersion": "4.0.0",
#    "packageVersionRevision": "Ciqe5/9yicvkJT13b5/LdLpCyE6fqA7poa9qp+FilPs="
# }

# aws codeartifact get-package-version-asset --domain my_domain --domain-owner 111122223333 --repository my_repo \
#   --format maven --namespace com.google.guava --package guava --package-version 27.1-jre \
#   --asset guava-27.1-jre.jar \
#   guava-27.1-jre.jar


## use curl 
# GET /v1/package/version/asset?asset=asset&domain=domain&domain-owner=domainOwner&format=format&namespace=namespace&package=package&repository=repository&revision=packageVersionRevision&version=packageVersion HTTP/1.1
# or 
# GET PUBLISH 
# curl --request PUT https://my_domain-111122223333.d.codeartifact.us-west-2.amazonaws.com/maven/my_repo/com/mycompany/app/my-app/1.0/my-app-1.0.jar --user "aws:$CODEARTIFACT_AUTH_TOKEN" --header "Content-Type: application/octet-stream" --data-binary @target/my-app-1.0.jar
