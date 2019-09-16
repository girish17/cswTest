# cswTest
## A script that automatically does following things

  - Checks out the latest version of [CSW](https://github.com/tmtsoftware/csw) from Git Repository
  - Launches the sbt console and runs the test
  - Redirects the standard output of the test to a file whose filename is TestResults{dateTime}.txt
  - Uploads the above file onto my [Confluence](https://tmt-project.atlassian.net/wiki/spaces/~gireesh.itcc/pages/208764929/Test+Results+of+CSW) using cURL and REST API provided by Confluence
  - Slack notification for failed tests. Using the Slack API to send messages instead of depending on Confluence → Scala  integration.
