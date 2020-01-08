#
include ../env.mk
include ./env.mk

.DEFAULT_GOAL:=all
.PHONY:all init refresh plan apply destroy state

all:
	echo "hello"

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
