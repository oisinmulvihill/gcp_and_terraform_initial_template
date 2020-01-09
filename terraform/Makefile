#
include ../env.mk
include ./env.mk

.DEFAULT_GOAL:=all
.PHONY:all init refresh plan apply destroy state

all:
	echo "hello"

admin-project:
	gcloud projects create ${TF_ADMIN} --organization ${TF_VAR_org_id}

	gcloud beta billing projects link ${TF_ADMIN} \
	  --billing-account ${TF_VAR_billing_account}

service-account:
	gcloud --project=${TF_ADMIN} iam service-accounts create terraform \
	--display-name "Terraform admin account"
	# This will write the new service account key to the TF_CREDS location:
	gcloud --project=${TF_ADMIN} iam service-accounts keys create ${TF_CREDS} \
	--iam-account terraform@${TF_ADMIN}.iam.gserviceaccount.com

enable-apis:
	# Any actions that Terraform performs require that the API be enabled to do
	# so. In this guide, Terraform requires the following:
	gcloud --project=${TF_ADMIN} services enable cloudresourcemanager.googleapis.com
	gcloud --project=${TF_ADMIN} services enable cloudbilling.googleapis.com
	gcloud --project=${TF_ADMIN} services enable iam.googleapis.com
	gcloud --project=${TF_ADMIN} services enable cloudapis.googleapis.com
	gcloud --project=${TF_ADMIN} services enable clouddebugger.googleapis.com
	gcloud --project=${TF_ADMIN} services enable cloudtrace.googleapis.com
	gcloud --project=${TF_ADMIN} services enable compute.googleapis.com
	gcloud --project=${TF_ADMIN} services enable container.googleapis.com
	gcloud --project=${TF_ADMIN} services enable containerregistry.googleapis.com
	gcloud --project=${TF_ADMIN} services enable datastore.googleapis.com
	gcloud --project=${TF_ADMIN} services enable deploymentmanager.googleapis.com
	gcloud --project=${TF_ADMIN} services enable dns.googleapis.com
	gcloud --project=${TF_ADMIN} services enable logging.googleapis.com
	gcloud --project=${TF_ADMIN} services enable monitoring.googleapis.com
	gcloud --project=${TF_ADMIN} services enable oslogin.googleapis.com
	gcloud --project=${TF_ADMIN} services enable replicapool.googleapis.com
	gcloud --project=${TF_ADMIN} services enable replicapoolupdater.googleapis.com
	gcloud --project=${TF_ADMIN} services enable resourceviews.googleapis.com
	gcloud --project=${TF_ADMIN} services enable servicemanagement.googleapis.com
	gcloud --project=${TF_ADMIN} services enable storage-api.googleapis.com
	gcloud --project=${TF_ADMIN} services enable storage-component.googleapis.com

bindings:
	gcloud organizations add-iam-policy-binding ${GCLOUD_ORG_ID} \
	--member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
	--role roles/resourcemanager.projectCreator

	# Add organization/folder-level permissions
	gcloud organizations add-iam-policy-binding ${GCLOUD_ORG_ID} \
	--member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
	--role roles/resourcemanager.projectCreator

	gcloud organizations add-iam-policy-binding ${GCLOUD_ORG_ID} \
	--member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
	--role roles/billing.creator

	gcloud organizations add-iam-policy-binding ${GCLOUD_ORG_ID} \
	--member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
	--role roles/iam.serviceAccountActor

	gcloud organizations add-iam-policy-binding ${GCLOUD_ORG_ID} \
	--member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
	--role roles/compute.xpnAdmin

	gcloud organizations add-iam-policy-binding ${GCLOUD_ORG_ID} \
	--member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
	--role roles/container.hostServiceAgentUser

	# Terraform admin project specific permission
	gcloud projects add-iam-policy-binding ${TF_ADMIN} \
	--member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
	--role roles/editor

	gcloud projects add-iam-policy-binding ${TF_ADMIN} \
	--member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
	--role roles/storage.admin

	gcloud projects add-iam-policy-binding ${TF_ADMIN} \
	--member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
	--role roles/storage.objectAdmin

	# Enable for Shared VPC management
	gcloud projects add-iam-policy-binding ${TF_ADMIN} \
	--member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
	--role roles/compute.networkAdmin

	# Enabled for Shared VPC management
	gcloud projects add-iam-policy-binding ${TF_ADMIN} \
	--member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
	--role roles/compute.networkUser

	-gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} \
	  --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
	  --role roles/iam.serviceAccountActor

	gcloud projects add-iam-policy-binding ${TF_ADMIN} \
	--member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
	--role roles/container.admin


# Shared state once-off set up.
init-terraform-state-store:
	gsutil mb -l ${REGION} -p ${TF_ADMIN} gs://${TF_ADMIN}
	gsutil versioning set on gs://${TF_ADMIN}


# Day-to-day commands
#
init:
	terraform init

plan:
	@-rm -f infrastructure.plan
	terraform plan -out infrastructure.plan

apply:
	terraform apply infrastructure.plan

refresh:
	terraform refresh

destroy:
	terraform destroy

state:
	terraform state list
