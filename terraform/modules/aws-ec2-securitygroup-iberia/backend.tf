####
# use state result to account clout
# remember this file contain sensitive information. use in output module param sensitive=true form protect information 
# verify cloud account store: has it encryptation information?
####

terraform {
    backend "s3" {
        bucket = "${var.project}-bucket"
        key    = "/terrafrom/state/${var.project}/${var.service_name}"
        region = var.aws_region
    }
}
