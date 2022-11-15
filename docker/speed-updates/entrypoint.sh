#!/bin/bash

echo "Evironment:"
printenv

if [[ -z "${ROOT_DIR}" ]]; then
  echo "ROOT_DIR environemnt variable must be provided"
  exit 1
fi

if [[ -z "${PARTITIONED_DATA_DIR}" ]]; then
  echo "PARTITIONED_DATA_DIR environemnt variable must be provided"
  exit 1
fi

if [[ -z "${CUSTOMIZED_DATA_DIR}" ]]; then
  echo "CUSTOMIZED_DATA_DIR environemnt variable must be provided"
  exit 1
fi

if [[ -z "${URL}" ]]; then
  echo "ROOT_DIR environemnt variable must be provided"
  exit 1
fi

cd $ROOT_DIR/$CUSTOMIZED_DATA_DIR

echo "Deleting old customised map data"
rm -rf *

echo "Copying fresh partitioned map data"
cp -r ../$PARTITIONED_DATA_DIR/* .

ONE_HOUR_FROM_NOW=$(date -d "+1 hour")
DAY_OF_WEEK=$(date -d "$ONE_HOUR_FROM_NOW" +"%H" | sed 's/^0*//')
HOUR=$(expr $(date -d "$ONE_HOUR_FROM_NOW" +"%u") - 1)
FULL_URL="$URL/$DAY_OF_WEEK/$HOUR.csv"

echo "Downloading speed updated CSV from $FULL_URL"
curl -O $FULL_URL -o speeds.csv

echo "Customizing map data"
osrm-customize %s --segment-speed-file speeds.csv