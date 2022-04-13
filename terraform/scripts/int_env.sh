#!/bin/sh
echo "export MICROSERVICE_ENV=integration" >> /etc/environment
echo "MICROSERVICE_ENV=integration" >> /etc/default/arcoservice
