# cswTest
A script that automatically does following things:
1.Checks out the latest version of csw project from Git Repository
2.Launches the sbt console and runs the test
3.Redirects the standard output of the test to a file whose filename is TestResults<dateTime>.txt
4.Uploads the above file onto my Confluence page using cURL and REST API provided by Confluence
5.Slack notification for failed tests (completed). Using the Slack API to send messages instead of depending on Confluence → Scala integration.
