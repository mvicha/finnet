This is required for creating a deployment environment from where all the different projects are going to be executed.

Following is a list of requirements for running this container:
1) Docker engine
2) A valid AWS configuration file

For running this container you should follow the next steps:
1) docker image build -t infradeployment:latest .
2) docker container run --name infradeployment --rm -it -v ${HOME}/.aws:/home/infra/.aws -v ${PWD}:/home/infra/infradeployment infradeployment:latest
