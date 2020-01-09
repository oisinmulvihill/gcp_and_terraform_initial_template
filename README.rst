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


Terraform
---------

To perform actions change into ``terraform/`` directory. From this directory you can then use ``make`` and run the following commands.

Quick-start
~~~~~~~~~~~

The main commands to run are ``make plan`` and if there are no errors run ``make apply``.

It is good practice to tell others you are about to apply before doing it. Make sure you have the latest repository changes.

Set up
~~~~~~

The first time you set up your environment you must set up the credentials key. See `Authentication`_ for more details on this. The next step is to run initialise on your machine:

.. code-block:: bash

  make init

This will download the terraform plugins we use.

Authentication
~~~~~~~~~~~~~~

Terraform is configured to run using a service account. This sevice account is given a limited set of rights. The system administrator sets up terraform using its own project and terraform admin service account. You will need to get the service account key you should use from the system administrator. You then write the contents of this JSON key to the file called ``${HOME}/.config/gcloud/<your org_name>_tfadmin_credentials.json``


Google SDK A.K.A gcloud
-----------------------

To use the Google SDK ``gcloud`` command line tool you need to login as your GSuite user name. You will need to login using Google's OAuth process.

.. code-block:: bash

  # Once-off set up:
  gcloud config configurations create <your org name>

  # Once-off set up after creating the configuration:
	gcloud config configurations activate <your org name>
  gcloud config set account <user @ some domain>

  # Each time you reboot or use another organisation
  gcloud config configurations activate <your org name>
	gcloud auth application-default login

The ``gcloud auth application-default login`` does not effect terraform in any way. This only controls what you can do with ``gcloud``. To learn more about application default have a look at https://cloud.google.com/sdk/gcloud/reference/auth/application-default/login.


Terraform Once-off Set up
~~~~~~~~~~~~~~~~~~~~~~~~~

This once-off set up is performed by the person setting up the account or the organisational administrator. This is done once in the life of the Organisation.

Please rename the file template_env_mk to env.mk and set the values for the environment variables:

``REGION``: This can be any valid region from https://cloud.google.com/compute/docs/regions-zones/

``GCLOUD_ORG_ID``: From https://console.cloud.google.com/cloud-resource-manager get the ID value shown.

``GCLOUD_BILLING_ID``: From https://console.cloud.google.com/billing you will see the "Billing account ID" column for the billing account you wish to use.

``ORG_TF_ADMIN``: The name space which will be used only by Terraform. For example ORG_TF_ADMIN=<my org name>-terraform-admin

``ORG_TF_CREDS``: This is the credential key for the terraform admin service account. For example ORG_TF_CREDS=${HOME}/.config/gcloud/<my org name>_tfadmin_credentials.json

You will now have to manually edit ``backend.tf`` and change the "bucket" value replacing "<your org name>".

Now you are ready to perform the terraform admin project and service account set up.

.. code-block:: bash

	make admin-project service-account

Next enable the google APIs I've learned by experience are needed. This can be added to and re-run and was based on previous google cloud projects.

.. code-block:: bash

	make enable-apis

Now I need to enable the bindings for the terraform service admin so it can do its job.

.. code-block:: bash

	make bindings

Now the shared state needs to be set up. This allows others to run terraform using the same state. **``NOTE``**: Only one person should run at a time as it is not safe to run in parallel

.. code-block:: bash

	make init-terraform-state-store

When the service account is created a key will be download to the ``ORG_TF_CREDS`` location. I my case, I put this key into 1Password which I can share later on.

We are almost done now.
Test run with empty Terraform configuration. Now

Now the service account is set up and ready it time to initialise Terraform.

.. code-block:: bash

  make init

This should download all the plugins we need. Finally we should be able to plan and apply the empty configuration successfully.

.. code-block:: bash

  # Test out our set up for errors:
  make plan

  # Apply the error free configuration to our set up:
  make apply

For example:

.. code-block:: bash

  $ make plan
  terraform plan -out infrastructure.plan
  Refreshing Terraform state in-memory prior to plan...
  The refreshed state will be used to calculate this plan, but will not be
  persisted to local or remote state storage.


  ------------------------------------------------------------------------

  No changes. Infrastructure is up-to-date.

  This means that Terraform did not detect any differences between your
  configuration and real physical resources that exist. As a result, no
  actions need to be performed.

  $ make apply
  terraform apply infrastructure.plan

  Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Success you are now ready for the world of Terraforming Google Cloud.
