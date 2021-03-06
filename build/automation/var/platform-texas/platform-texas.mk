AWS_ECR := $(or $(AWS_ACCOUNT_ID_MGMT), 123456789).dkr.ecr.eu-west-2.amazonaws.com
AWS_REGION := eu-west-2
AWS_DEFAULT_REGION := $(AWS_REGION)
AWS_ROLE_JENKINS := jenkins_assume_role
AWS_ROLE_SESSION := jenkins
AWS_ROLE := $(if $(HUDSON_URL),$(AWS_ROLE_JENKINS),Developer)

TEXAS_TERRAFORM_STATE_LOCK = nhsd-texasplatform-terraform-service-state-lock-texas-lk8s-$(AWS_ACCOUNT_NAME)
TEXAS_TERRAFORM_STATE_STORE = nhsd-texasplatform-terraform-service-state-store-lk8s-$(AWS_ACCOUNT_NAME)

# ==============================================================================

TF_VAR_aws_profile := nhsd-ddc-exeter-texas-live-lk8s-$(AWS_ACCOUNT_NAME)
TF_VAR_platform_zone := k8s-$(AWS_ACCOUNT_NAME).texasplatform.uk
TF_VAR_route53_terraform_state_key := route53/terraform.tfstate
TF_VAR_security_groups_k8s_terraform_state_key := security-groups-k8s/terraform.tfstate
TF_VAR_security_groups_terraform_state_key := security-groups/terraform.tfstate
TF_VAR_terraform_platform_state_store := nhsd-texasplatform-terraform-state-store-live-lk8s-$(AWS_ACCOUNT_NAME)
TF_VAR_vpc_terraform_state_key := vpc/terraform.tfstate
