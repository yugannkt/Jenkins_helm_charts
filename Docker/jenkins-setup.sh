#!/bin/sh
# Wait until Jenkins is fully up and running
until curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/login | grep 200; do
  echo "Waiting for Jenkins to start..."
  sleep 10
done
echo "Jenkins is up! Proceeding with setup..."
url=http://localhost:8080
# Default admin password file
password_file=/var/jenkins_home/secrets/initialAdminPassword
if [ ! -f "$password_file" ]; then
  echo "Initial admin password file not found!"
  exit 1
fi
password=$(cat "$password_file")
# 1. Create Admin
echo "Running admin creation..."
# Encode new admin credentials
username="user"
new_password="password"
fullname="Full Name"
email="hello@world.com"
y
# Get the Crumb and Cookie
cookie_jar="$(mktemp)"
full_crumb=$(curl -u "admin:$password" --cookie-jar "$cookie_jar" "$url/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,%22:%22,//crumb)")
only_crumb=$(echo "$full_crumb" | cut -d: -f2)
# Make the request to create an admin user
curl -X POST -u "admin:$password" "$url/setupWizard/createAdminUser" \
        -H "Connection: keep-alive" \
        -H "Accept: application/json, text/javascript" \
        -H "X-Requested-With: XMLHttpRequest" \
        -H "$full_crumb" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        --cookie "$cookie_jar" \
        --data-raw "username=$username&password1=$new_password&password2=$new_password&fullname=$fullname&email=$email&Jenkins-Crumb=$only_crumb&json=%7B%22username%22%3A%20%22$username%22%2C%20%22password1%22%3A%20%22$new_password%22%2C%20%22password2%22%3A%20%22$new_password%22%2C%20%22fullname%22%3A%20%22$fullname%22%2C%20%22email%22%3A%20%22$email%22%2C%20%22Jenkins-Crumb%22%3A%20%22$only_crumb%22%7D"
# 2. Install Plugins
echo "Installing plugins..."
# Get Crumb for authenticated user
full_crumb=$(curl -u "$username:$new_password" --cookie-jar "$cookie_jar" "$url/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,%22:%22,//crumb)")
only_crumb=$(echo "$full_crumb" | cut -d: -f2)
# Install required plugins
curl -X POST -u "$username:$new_password" "$url/pluginManager/installPlugins" \
  -H "Connection: keep-alive" \
  -H "Accept: application/json, text/javascript, */*; q=0.01" \
  -H "X-Requested-With: XMLHttpRequest" \
  -H "$full_crumb" \
  -H "Content-Type: application/json" \
  --cookie "$cookie_jar" \
  --data-raw '{"dynamicLoad":true,"plugins":["cloudbees-folder","antisamy-markup-formatter","build-timeout","credentials-binding","timestamper","ws-cleanup","ant","gradle","workflow-aggregator","github-branch-source","pipeline-github-lib","pipeline-stage-view","git","ssh-slaves","matrix-auth","pam-auth","ldap","email-ext","mailer"],"Jenkins-Crumb":"'$only_crumb'"}'
# 3. Confirm Jenkins URL
echo "Confirming Jenkins URL or performing additional setup..."
url_urlEncoded=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$url', safe=''))")
curl -X POST -u "$username:$new_password" "$url/setupWizard/configureInstance" \
  -H "Connection: keep-alive" \
  -H "Accept: application/json, text/javascript, */*; q=0.01" \
  -H "X-Requested-With: XMLHttpRequest" \
  -H "$full_crumb" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --cookie "$cookie_jar" \
  --data-raw "rootUrl=$url_urlEncoded%2F&Jenkins-Crumb=$only_crumb&json=%7B%22rootUrl%22%3A%20%22$url_urlEncoded%2F%22%2C%20%22Jenkins-Crumb%22%3A%20%22$only_crumb%22%7D"
echo "Jenkins setup complete!"