# watching
TV Show Tracker called watching. Built in Flutter.

# Demo Videos

Demo of the web version: https://www.youtube.com/watch?v=kzy7JBt9tS8


Demo of the app version: https://www.youtube.com/watch?v=pJKmsDCdPFQ

# Platforms

This application is available and optimized for iOS, Android and the web (link: https://watching-development.web.app/).


# Tech stack

Supabase PostGreSQL for backend.
Firebase Authentication for authentication.
TV Maze External API.

# Environments

This project has only development as a flavor and the env variables are inside the dotEnv.dev file (not checked in.)

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