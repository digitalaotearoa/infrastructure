#!/bin/bash
set -e

DOCKER_COMPOSE=/usr/local/bin/docker-compose
AWS_CLI=/usr/bin/aws
COMPOSE_DIR=<FIXME>
DBNAME=hedgedoc
DBUSER=hedgedoc
OUTNAME="$(date +%Y-%m-%d_%H-%M)-hedgedoc-backup.sql.gz"
BUCKET=<FIXME>

# Backup, gzip, upload to s3 and remove local copy if s3 upload exited cleanly. 
${DOCKER_COMPOSE} -f \
   ${COMPOSE_DIR}/docker-compose.yml exec -T database pg_dump ${DBNAME} -U ${DBUSER} \
   |  gzip > ${OUTNAME} && \
   ${AWS_CLI} s3 cp ${OUTNAME} s3://${BUCKET}  && \
   OUTSIZE=$(ls -lah $OUTNAME |cut -d" " -f5) && rm ${OUTNAME} 
