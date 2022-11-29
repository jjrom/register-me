# register-me
A script to automatically register a [jjrom/s6-overlay](https://github.com/jjrom/s6-overlay) based container during the deploiment phase to a [jjrom/healthcheckr](https://github.com/jjrom/healthcheckr) endpoint

This service is used by the containers deployed for the ["Pôle de données et services Surfaces Planétaires" - PDSSP](https://pole-surfaces-planetaires.github.io/) which are registered within the IAS infrastructure ([check the services status](https://ping-pdssp.ias.universite-paris-saclay.fr))

## Example for resto

Set the Dockerfile:

    FROM jjrom/resto:latest
    
    # Add register me script
    ADD https://raw.githubusercontent.com/jjrom/register-me/main/register-me.sh /etc/cont-init.d/99-register-me.sh
    RUN chmod +x /etc/cont-init.d/99-register-me.sh

    # Add the service description
    COPY ./service_description.json /tmp/service_description.json

Pass environment variables (ex. docker-compose.yml):

    version: '3'
    services:
    resto:
        environment: 
        - HEALTHCHECKR_AUTH_TOKEN=XXXXXXXXX
        - HEALTHCHECKR_SERVICES_ENDPOINT=https://endpoint-to-healthcheckr/services
        
