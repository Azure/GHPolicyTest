function Find-GithubIssue {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$title
    )
    
    $issues = gh issue list --json number,title,assignees,labels,id | ConvertFrom-Json
    $issueDetails = ""
    
    foreach ($issue in $issues) {
        $matchFound = $false
        if ($issue.Title -eq $title) {
            $matchFound = $true
            $issueDetails = "$($issue.number) | $($issue.Title) | $($issue.assignees.login)"
            Write-Output "Good News! Issue Found:: $($issue.number) | $($issue.Title) | $($issue.assignees.login)"
            break
            # return $issueDetails
        }
        else {
            # Write-Output "No match found for: $($title)"
            return $issueDetails            
        }
    }
}