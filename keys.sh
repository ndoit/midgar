#!/usr/bin/env bash

checkUser(){
  read -r -p "Is this your first time setting up your BI Portal environment? [y/n] " response
  echo $response

  if [ $response = y ]; then
    echo Welcome. Let me help you get started.
    echo First we need to set up your KEYS...
    keySetUp
  elif [ $response = n ]; then
    echo Welcome back...
  else
    checkUser
  fi
}

keySetUp(){

  cd /vagrant/fenrir

  echo Please prepare your S3 Key and Secret...
  read -r -p "Please enter your S3 Key: " s3Key
  read -r -p "Please enter your S3 Secret: " s3Secret
  read -r -p "Please enter your S3 Bucket Name: " s3Bucket
  read -r -p "Please enter your S3 Region: " s3Region



  echo Writing secret key...
  rakeSecretFenrir=$(rake secret)

  echo S3_KEY=$s3Key >> .env.local
  echo S3_SECRET=$s3Secret >> .env.local
  echo S3_BUCKET_NAME=$s3Bucket >> .env.local
  echo S3_REGION=$s3Region >> .env.local
  echo S3_ASSET_URL=https://s3.amazonaws.com >> .env.local
  echo RAILS_SECRET_KEY_BASE=$rakeSecretFenrir >> .env.local

  cd /vagrant

}

checkUser
