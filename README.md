# watching
TV Show Tracker called watching. Built in Flutter.

## Platform

This application is available and optimized for iOS, Android and the web (link: https://watching-development.web.app/).


## Tech stack

Supabase PostGreSQL for backend.
Firebase Authentication for authentication.
TV Maze External API.

# Instructions to Publish to Firebase Hosting

## First build the web bundle for the appropriate flavor:
```sh
flutter build web --release -t lib/main_development.dart 
```
## Then make sure you are using the correct firebase project:
```sh
firebase use "project name"
```
## Then deploy to firebase hosting
```sh
firebase deploy
```
# Cors Setup For Web to Function Properly:
## Make sure this is installed first:
```shell
./google-cloud-sdk/install.sh  
```
## Then run this:
```shell
echo '[{"origin": ["*"],"responseHeader": ["Content-Type"],"method": ["GET", "HEAD"],"maxAgeSeconds": 3600}]' > cors-config.json
```
## Login to google cloud like this: 
```shell
gcloud auth login     
```
## Config like this:
```shell
gcloud config set pass_credentials_to_gsutil true    
```
## Then finally do this:
```shell
gsutil cors set cors-config.json gs://watching-development.appspot.com
```