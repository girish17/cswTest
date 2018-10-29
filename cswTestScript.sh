echo "Running script that runs all the tests that are part of csw and uploads them to my confluence page..."
today=`date '+%d%b%I%p'`
filename=TestResults$today.txt
#execute redis sentinel
#redis-4.0.9/src/redis-sentinel redis-4.0.9/sentinel.conf &
#execute redis server
#redis-4.0.9/src/redis-server &
#execute zookeeper properties
#Downloads/kafka_2.12-1.1.0/bin/zookeeper-server-start.sh Downloads/kafka_2.12-1.1.0/config/zookeeper.properties &
#execute server properties
#Downloads/kafka_2.12-1.1.0/bin/kafka-server-start.sh Downloads/kafka_2.12-1.1.0/config/server.properties &
#navigate to csw-prod directory
echo "Going into csw home directory..."
cd IdeaProjects/csw/
touch $filename
#update the Git repo
git pull
#set environment variable
#export SBT_OPTS=--add-modules=java.xml.bind,java.activation
#start sbt and run all tests
echo "Starting sbt to run all tests..."
sbt -Dsbt.log.noformat=true test > $filename
#upload it to Confluence
echo "Uploading $filename to confluence..."
curl --request PUT \
                           --user gireesh.itcc@iiap.res.in:Ae1NK44QHtbl9lluG7mW93E2 \
                           --header 'Accept: application/json' \
                           --header 'Content-Type: multipart/form-data' \
                           --header 'X-Atlassian-Token: nocheck' \
                           --form 'file=@'$filename \
                           --url 'https://tmt-project.atlassian.net/wiki/rest/api/content/208764929/child/attachment'
#move the files to confluence test directory
echo "\nMoving $filename to TestResConfl directory..."
mv $filename ../TestResConfl

#TODO: make it periodic. The script should run at 10.00 AM everyday. Well my system should be on to do this or it has to be made to switch one automatically and then run it. Ideally, on logging into this system it could be made to run, thereby avoiding me to do a simple task of opening the command line and running myself. Well, is it worth the effort? 