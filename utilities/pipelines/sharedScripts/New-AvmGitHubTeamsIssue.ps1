function New-AVMGitHubIssue {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$title,
        [Parameter(Mandatory)]
        [string]$assignee,
        [Parameter(Mandatory)]
        [string]$body,
        [Parameter(Mandatory)]
        [string]$labels
    )
    
    gh auth status
    if ($? -eq $false) {
        Write-Error "You are not authenticated to GitHub. Please run 'gh auth login' to authenticate."
        exit 1
    }
    try {
        gh issue create --title $title --body $body --assignee $assignee --label $labels    
    }
    catch {
        Write-Error "Unable to create issue. Check network connection."
        return $Error
    }
}