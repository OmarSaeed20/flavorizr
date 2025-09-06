#!/bin/bash

# Build script for different flavors

case $1 in
  "dev")
    echo "Building Dev flavor..."
    flutter build apk --flavor=dev --dart-define=FLAVOR=dev
    flutter build ios --flavor=dev --dart-define=FLAVOR=dev
    ;;
  "staging")
    echo "Building Staging flavor..."
    flutter build apk --flavor=staging --dart-define=FLAVOR=staging
    flutter build ios --flavor=staging --dart-define=FLAVOR=staging
    ;;
  "prod")
    echo "Building Production flavor..."
    flutter build apk --flavor=prod --dart-define=FLAVOR=prod
    flutter build ios --flavor=prod --dart-define=FLAVOR=prod
    ;;
  *)
    echo "Usage: ./build.sh [dev|staging|prod]"
    exit 1
    ;;
esac