# Checks for a given amount of tries whether the database is ready to accept incoming connections by
# polling the health state of a Docker container

# Usagge: .\wait-for-db.ps1 -ContainerName demo-sql-db -MaxNumberOfTries 200

Param (
    # Represents the name of the Docker container to check whetther is running.
    $ContainerName,

    # Represents the number of milliseconds to wait before checking again whether 
    # the given container is healthy.
    $HealthCheckIntervalInMilliseconds = 500,

    # The maximum amount of retries before giving up and considering that the given 
    # Docker container is not running.
    $MaxNumberOfTries = 50
)

$ErrorActionPreference = 'Stop'
$numberOfTries = 1
$isDatabaseReady = $false

do {
    Start-Sleep -Milliseconds $HealthCheckIntervalInMilliseconds
    $isDatabaseReady = docker inspect $ContainerName --format "{{.State.Health.Status}}" | Select-String -Pattern 'healthy' -SimpleMatch -Quiet

    if ($isDatabaseReady -eq $true) {
        Write-Output "`n`nDatabase running inside container ""$ContainerName"" is ready to accept incoming connections"
        exit 0
    }

    $progressMessage = "`n${numberOfTries}: Container ""$ContainerName"" isn't running yet"

    if ($numberOfTries -lt $maxNumberOfTries - 1) {
        $progressMessage += "; will check again in $HealthCheckIntervalInMilliseconds milliseconds"
    }
        
    Write-Output $progressMessage
    $numberOfTries++
}
until ($numberOfTries -gt $maxNumberOfTries)

# Instruct Azure DevOps to consider the current task as failed.
# See more about logging commands here: https://github.com/microsoft/azure-pipelines-tasks/blob/master/docs/authoring/commands.md.
Write-Output "##vso[task.LogIssue type=error;]Container $ContainerName is still not running after checking for $numberOfTries times; will stop here"
Write-Output "##vso[task.complete result=Failed;]"
exit 1