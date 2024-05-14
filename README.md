# watching
TV Show Tracker called Watching. Graduation project at IT-högskolan. Built in Flutter.


Supabase PostGreSQL for backend.
Firebase Authentication is also used.
TV Maze External API is used (until I build my own database of shows).





CORS SETUP:
Had ot first install this:
./google-cloud-sdk/install.sh  
Then ran this:
echo '[{"origin": ["*"],"responseHeader": ["Content-Type"],"method": ["GET", "HEAD"],"maxAgeSeconds": 3600}]' > cors-config.json
login here like this: 
gcloud auth login     
also did this:
gcloud config set pass_credentials_to_gsutil true    
then do this:
gsutil cors set cors-config.json gs://watching-development.appspot.com