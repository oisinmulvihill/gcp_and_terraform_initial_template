# Terraform specific environment variables.
#
export TF_VAR_region=${REGION}
export TF_VAR_org_id=${GCLOUD_ORG_ID}
export TF_VAR_billing_account=${GCLOUD_BILLING_ID}
export TF_ADMIN=${TF_ADMIN}
export TF_CREDS=${TF_CREDS}
export GOOGLE_APPLICATION_CREDENTIALS=${TF_CREDS}
export GOOGLE_PROJECT=${TF_ADMIN}
export SERVICE_ACCOUNT_KEY=${TF_CREDS}