.. image:: assets/howtotemplate.png
    :align: center
    :alt: Please "Use this template".

Please click "Use this template" button to create your own repository based off this one. This repository aims to get an organisation off the ground using Terraform with Google Cloud.

Required:

- Google command line tools from SDK https://cloud.google.com/sdk/
- A Google Cloud account with an Organisation configured https://console.cloud.google.com/cloud-resource-manager.
- Make


====================================
Terraform and Google Template Set up
====================================


.. contents::


Terraform Usage
---------------

Change into the terraform directory to run the commands. Now you can use ``make`` to do ``plan, apply, init, ...`` and other actions.


Authentication
~~~~~~~~~~~~~~

You will need to login in order to be able to run terraform commands. The <your org name> set up will show the configuration needed for this to work.

.. code-block:: bash

	# Once-off set up:
	gcloud config configurations create <your org name>

	# Each time you reboot or use another company's set up on gcloud.
	gcloud config configurations activate <your org name>

	# (Once-off usually) set the account for your username on the organisational domain
	gcloud config set account <ACCOUNT @ organisation dot something>

	# login as this account
	gcloud auth login


Terraform Once-off Set up
~~~~~~~~~~~~~~~~~~~~~~~~~

Please rename the file template_env_mk to env.mk and set the values for the environment variables:

``REGION``: This can be any valid region from https://cloud.google.com/compute/docs/regions-zones/

``GCLOUD_ORG_ID``: From https://console.cloud.google.com/cloud-resource-manager get the ID value shown.

``GCLOUD_BILLING_ID``: From https://console.cloud.google.com/billing you will see the "Billing account ID" column for the billing account you wish to use.

``TF_ADMIN``: The name space which will be used only by Terraform. For example TF_ADMIN=<my org name>-terraform-admin

This assumes that the person performing this is the initial system administrator setting this up for the first time. They will create the users and groups using terraform later on.

Now set up the shared state. This allows others to run terraform using the same state and provides some protection against overwriting each other.

**``NOTE``**: Only once person should run at a time as it is not safe to run in parallel

.. code-block:: bash

	make init-terraform-state-store
