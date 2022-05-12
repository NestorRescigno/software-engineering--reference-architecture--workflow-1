# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by Software Engineering             *************
# *********************************************************************
# 000 - local variables

###############################
### Stack local variables
###############################

locals {

  global_common_tags = {
    Project                  = "${var.project}"
    Environment              = "${var.environment}"
    Name                     = "${var.service_name}"
    Cluster                  = "${local.cluster_name}"
    Side                     = "${var.service_name}"
    #Type                     = "Service" //This tag is checked in deploys by jenkins, so it no longer makes sense.
    "Application:ArtifactId" =  join("-",[var.service_name,"core"])
    "tf:Used"                = "True"
  }
}

## Change these values if neccesary
locals {
  cluster_name          = var.service_name
}

