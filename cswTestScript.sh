echo "Running script that runs all the tests that are part of csw and uploads them to my confluence page..."
today=`date '+%d%b%I%p'`
filename=TestResults$today.txt
failedTests=TestFailed$today.txt
uploadRes=UploadRes$today.txt

#navigate to csw-prod directory
echo "Going into csw home directory..."
cd ../IdeaProjects/csw/     #this can be replaced with your directory path of csw checked folder
touch $filename
touch $failedTests
touch $uploadRes

#update the Git repo
git pull

#set environment variable
export SBT_OPTS=--add-modules=java.xml.bind,java.activation

#start sbt and run all tests
echo "Starting sbt to run all tests..."
sbt -Dsbt.log.noformat=true test > $filename

#upload it to Confluence
echo "Uploading $filename to confluence..."

#userToken=gireesh.itcc@iiap.res.in:Ae1NK44QHtbl9lluG7mW93E2
#confluenceURL=https://tmt-project.atlassian.net/wiki/rest/api/content/208764929/child/attachment
#replace with your mail ID and obtain the API token from https://id.atlassian.com/manage/api-tokens
curl --request PUT \
                           --user 'gireesh.itcc@iiap.res.in:Ae1NK44QHtbl9lluG7mW93E2' \
			   --header 'Accept: application/json' \
                           --header 'Content-Type: multipart/form-data' \
                           --header 'X-Atlassian-Token: nocheck' \
                           --form 'file=@'$filename \
                           --url 'https://tmt-project.atlassian.net/wiki/rest/api/content/208764929/child/attachment' > $uploadRes

#to parse the test file and locate [error] lines and report
echo "Parsing the test file to locate [error] lines..."
slackMsg="$(grep "\[error\] csw" $filename)"
echo slackMsg > $failedTests
testRes="$(grep "Total time:" $filename)"

#Add the final result and test run time as a comment to the attachement
attachmentId=$(jq --raw-output '.results[0].id' $uploadRes)
echo "\nUploaded test file attachment id: $attachmentId"
curl -D- \
  -u gireesh.itcc@iiap.res.in:Ae1NK44QHtbl9lluG7mW93E2 \
  -X POST \
  -H "X-Atlassian-Token: nocheck" \
  -F "file=@"$filename \
  -F "minorEdit=true" \
  -F "comment=$testRes" \
  https://tmt-project.atlassian.net/wiki/rest/api/content/208764929/child/attachment/$attachmentId/data >> $uploadRes

#Use the Slack API token to update the Testing V&V channel about the failed tests
slackAtt="%5B%7B%22CSW Test Results%22%3A%20%22Tests that have failed:%22%2C%20%22text%22%3A%20%22$slackMsg%22%7D%5Di"
slackChnl="csw-testing_validate"
slackToken="xoxp-90714720485-282106523457-479181516835-de503b5447fc298ca59a707d31859f3b"
detLogLink="Detailed log: https://tmt-project.atlassian.net/wiki/x/AYBxD"
curl -X POST "https://slack.com/api/chat.postMessage" -d "token=$slackToken&channel=$slackChnl&text=$detLogLink&attachments=$slackAtt&pretty=1"

echo "\nCompleted!"
#TODO: make it periodic. The script should run at 10.00 AM everyday. Well my system should be on to do this or it has to be made to switch one automatically and then run it.
#Ideally, on logging into this system it could be made to run, thereby avoiding me to do a simple task of opening the command line and running myself. Well, is it worth the effort? 

#Finally, move the files to confluence test directory
echo "\nMoving $filename $failedTests $uploadRes to TestResConfl directory..."
mv $filename $failedTests $uploadRes ../../TestResConfl    #replace with your directory where the files need to be stored
