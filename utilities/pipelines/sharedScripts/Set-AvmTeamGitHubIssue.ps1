function Set-AvmTeamGitHubIssue {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$TeamName,
        [Parameter(Mandatory)]
        [string]$Owner,
        [Parameter(Mandatory)]
        [string]$ValidationError,
        [Parameter(Mandatory)]
        [switch]$CreateIssues
    )

    # Load used functions
    . (Join-Path $PSScriptRoot "Find-GitHubIssue.ps1")
    . (Join-Path $PSScriptRoot "New-AvmGitHubTeamsIssue.ps1")

    $title = "[GitHub Team Issue] $TeamName"
    $bodyAutoDisclaimer = "*This issue was automatically created by the AVM Team Linter. If this issue has been created by mistake please reach out to the AVM Team using this issue.*"
    $teamError = "# Description `nThe AVM Team Linter has found an issue with the following GitHub Team."
    $teamTable = "| Team Name | Owner | Issue |`n| --- | --- | --- |`n| $TeamName | $Owner | $validationError |"
    $body = "$teamError`n`n$teamTable`n`n$bodyAutoDisclaimer"

    $issues = Find-GithubIssue -title $title

    if ([string]::IsNullOrEmpty($issues) -And $CreateIssues) {
        Write-Output "No issue found for: $($title), Creating new issue."
        try {
            New-AvmGitHubTeamsIssue -title $title -assignee $Owner -body $body -labels $labels
        }
        catch {
            Write-Error "Unable to create issue. Check network connection."
        }
    }
    elseif ([string]::IsNullOrEmpty($issues) -And -not $CreateIssues) {
        Write-Verbose "New issue would be created for: $($title) with $($body)"
    }
    else {
        Write-Output "Issue found for: $($title)"
    }
}