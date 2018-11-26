# cswTest
A script that automatically does following things
<ol>
  <li>Checks out the latest version of [CSW Project](https://github.com/tmtsoftware/csw) from Git Repository</li>
  <li>Launches the sbt console and runs the test</li>
  <li>Redirects the standard output of the test to a file whose filename is TestResults{dateTime}.txt</li>
  <li>Uploads the above file onto my [Confluence page](https://tmt-project.atlassian.net/wiki/spaces/~gireesh.itcc/pages/208764929/Test+Results+of+CSW) using cURL and REST API provided by Confluence</li>
  <li>Slack notification for failed tests. Using the Slack API to send messages instead of depending on Confluence → Scala  integration.</li>
</ol>
