# Purpose
This repository's objective is to enable the reader to build a small CI/CD pipeline and prove the feasibility on Google Cloud platform.

# Content
The document describes the activities needed to build a small application based on the GCP solutions.

## Success criteria
* Run a CI/CD pipeline;
* Deploy a managed database;
* Deploy a small app to a serverless environment;
* App is accessible via a CURL command from any environment;

## GCP Solutions used
* Cloud Build
* Cloud Run
* Cloud SQL

# Activities

## Set-up
Clone the git repository to your console:

```
git clone git@github.com:rgalite/cloudbuild-cloudrun-example.git
```

## Terraform plan
Navigate to the tf directory, copy the `terraform.tfvars.example` to `terraform.tfvars` and fill in the variables.

Run the following command to create the needed resources:

```
terraform init
terraform plan
terraform apply
```

The terraform script creates:
* a MySQL database on Cloud SQL;
* a cloud source code repositories to push the app code to;
* a CI/CD pipeline for which every push on the main branch will deploy a new version of the app;
* a default cloud run app;


> At this point you should be able to access your newly deployed app.
> Run the following command to get the app URL:

```
terraform output url
```

![Cloudrun default](https://lh6.googleusercontent.com/2fxQREqvSeUiLVvPxcPDIKb7cfBF-yJbHLtcBhNvjpoZhH7E21c_tdg8Ddyzw7askSCZw1sALydt7llkRXkJZeGiotmksGctOwH6smJiuXROoDTPMlRNaXtBlbkb9SDIaD_3uz6jCw "Cloudrun default")

## Deploy an app with the CI/CD pipeline

Add the source code repository url to your git config and push the code:

```
git config --global credential.https://source.developers.google.com.helper gcloud.sh
git remote add google $(terraform output repository_http_url)
git push --all google
```

Head over to the cloud build console to see the deployment:

![Cloudbuild screenshot](https://lh4.googleusercontent.com/k4r5V4yuzSyppu2lz8IefucQsjpW3HwzWRGX34fgRuJzddPWhEn6e4IN6Ijh19jp9Wa3ZSudJWtP08iVCSnXDSOjfu4f-pLR0t43ZcqR "Cloudbuild screenshot")

The CI/CD process:
* builds a docker image from the Dockerfile provided in `app/Dockerfile`;
* run the tests;
* deploys the container to cloud run;

Refresh the cloud run URL to see your code deployed!
