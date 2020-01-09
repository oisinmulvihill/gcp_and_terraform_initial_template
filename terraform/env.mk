# Terraform specific environment variables.
#
export TF_VAR_region=${REGION}
export TF_VAR_org_id=${GCLOUD_ORG_ID}
export TF_VAR_billing_account=${GCLOUD_BILLING_ID}
# The project for terraform's exclusive use.
export TF_ADMIN=${ORG_TF_ADMIN}
export TF_CREDS=${ORG_TF_CREDS}
# Terraform will run with a service account created for it with the permissions it needs to do its job.
export GOOGLE_APPLICATION_CREDENTIALS=${TF_CREDS}
export GOOGLE_PROJECT=${TF_ADMIN}
export SERVICE_ACCOUNT_KEY=${TF_CREDS}
