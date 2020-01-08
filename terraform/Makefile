#
include ../env.mk
include ./env.mk

.DEFAULT_GOAL := all
.PHONY: all init refresh plan apply destroy state

all:
	echo "hello"


# Initial set up of the terraform-admin project and service account to manage
# any other projects/resources/etc.
#
admin-project:
	gcloud projects create ${TF_ADMIN} --organization ${TF_VAR_org_id}

	gcloud beta billing projects link ${TF_ADMIN} \
	  --billing-account ${TF_VAR_billing_account}

service-account:
	gcloud iam service-accounts create terraform \
	--display-name "Terraform admin account"

	gcloud iam service-accounts keys create ${TF_CREDS} \
	--iam-account terraform@${TF_ADMIN}.iam.gserviceaccount.com

enable-apis:
	# Any actions that Terraform performs require that the API be enabled to do
	# so. In this guide, Terraform requires the following:
	gcloud services enable cloudresourcemanager.googleapis.com
	gcloud services enable cloudbilling.googleapis.com
	gcloud services enable iam.googleapis.com
	gcloud services enable cloudapis.googleapis.com
	gcloud services enable clouddebugger.googleapis.com
	gcloud services enable cloudtrace.googleapis.com
	gcloud services enable compute.googleapis.com
	gcloud services enable container.googleapis.com
	gcloud services enable containerregistry.googleapis.com
	gcloud services enable datastore.googleapis.com
	gcloud services enable deploymentmanager.googleapis.com
	gcloud services enable dns.googleapis.com
	gcloud services enable logging.googleapis.com
	gcloud services enable monitoring.googleapis.com
	gcloud services enable oslogin.googleapis.com
	gcloud services enable replicapool.googleapis.com
	gcloud services enable replicapoolupdater.googleapis.com
	gcloud services enable resourceviews.googleapis.com
	gcloud services enable servicemanagement.googleapis.com
	gcloud services enable storage-api.googleapis.com
	gcloud services enable storage-component.googleapis.com

org-and-folder-permissions:
	gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} \
	--member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
	--role roles/resourcemanager.projectCreator

	# Add organization/folder-level permissions
	gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} \
	--member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
	--role roles/resourcemanager.projectCreator

	gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} \
	--member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
	--role roles/billing.user

	gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} \
	--member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
	--role roles/iam.serviceAccountActor

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
