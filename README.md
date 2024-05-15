# watching
TV Show Tracker called Watching. Built in Flutter.

## Platform

This application is available and optimized for iOS, Android and the web (link: https://watching-development.web.app/).


## Tech stack

Supabase PostGreSQL for backend.
Firebase Authentication for authentication.
TV Maze External API.





# Cors Setup For Web to Function Properly:
## Make sure this is installed first:
./google-cloud-sdk/install.sh  
## Then run this:
echo '[{"origin": ["*"],"responseHeader": ["Content-Type"],"method": ["GET", "HEAD"],"maxAgeSeconds": 3600}]' > cors-config.json
## Login to google cloud like this: 
gcloud auth login     
## Config like this:
gcloud config set pass_credentials_to_gsutil true    
## Then finally do this:
gsutil cors set cors-config.json gs://watching-development.appspot.com