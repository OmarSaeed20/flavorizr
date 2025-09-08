#!/bin/bash
# Script to generate Firebase configuration files for different environments/flavors
# Feel free to reuse and adapt this script for your own projects

if [[ $# -eq 0 ]]; then
  echo "Error: No environment specified. Use 'dev', 'staging', or 'prod'."
  exit 1
fi

case $1 in
  dev)
    flutterfire config --project=flavorizr-b3322-dev --out=lib/config/firebase/firebase_options/firebase_options_dev.dart --ios-bundle-id=com.example.flavorizr.dev --ios-out=ios/flavors/dev/GoogleService-Info.plist --android-package-name=com.example.flavorizr.dev --android-out=android/app/src/dev/google-services.json
    ;;
  staging)
    flutterfire config --project=flavorizr-b3322-staging --out=lib/config/firebase/firebase_options/firebase_options_staging.dart --ios-bundle-id=com.example.flavorizr.staging --ios-out=ios/flavors/staging/GoogleService-Info.plist --android-package-name=com.example.flavorizr.staging --android-out=android/app/src/staging/google-services.json
    ;;
  prod)
    flutterfire config --project=flavorizr-b3322 --out=lib/config/firebase/firebase_options/firebase_options_prod.dart --ios-bundle-id=com.example.flavorizr --ios-out=ios/flavors/prod/GoogleService-Info.plist --android-package-name=com.example.flavorizr --android-out=android/app/src/prod/google-services.json
    ;;
  *)
    echo "Error: Invalid environment specified. Use 'dev', 'staging', or 'prod'."
    exit 1
    ;;
esac

