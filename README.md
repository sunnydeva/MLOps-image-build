################################

deploying the model end to end in kubernates

Prereqs

1. kubeflow
2. kubernates
3. docker
4. ml lifecycle

this readme file will have step by step to develop model and then deploy the model

step1 : create a docker container that contains all the dependencies

create a poetry

what is poetry
Python Poetry, a modern tool for dependency management + packaging.

pip install poetry
poetry version
poetry init










################################

Helm commands to pull the taz 

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm pull ingress-nginx/ingress-nginx --version 4.10.0

################################




