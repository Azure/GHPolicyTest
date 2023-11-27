# function Find-GithubIssue {
#     [CmdletBinding()]
#     param (
#         [Parameter(Mandatory)]
#         [string]$title
#     )
    
#     $issueList = gh issue list --json number,title,assignees,labels,id | ConvertFrom-Json
#     $issueDetails = ""
    
#     foreach ($issueItem in $issueList) {
#         # $matchFound = $false
#         Write-Verbose "trying to find $($title)"
#         Write-Verbose "issueItem.title: $($issueItem.title)"
#         if ($issueItem.title -eq $title) {
#             # $matchFound = $true
#             $issueDetails = "$($issueItem.number) | $($issueItem.Title) | $($issueItem.assignees.login)"
#             Write-Output "Good News! Issue Found:: $($issueItem.number) | $($issueItem.title) | $($issueItem.assignees.login)"
#             break
#             # return $issueDetails
#         }
#         else {
#             # Write-Output "No match found for: $($title)"
#             return $issueDetails            
#         }
#     }
# }



function Find-GithubIssue {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$title
    )
    
    $issueList = gh issue list --json number,title,assignees,labels,id | ConvertFrom-Json
    $issueDetails = ""

    foreach ($issueItem in $issueList) {
        Write-Verbose "trying to find $($title)"
        Write-Verbose "issueItem.title: $($issueItem.title)"
        if ($issueItem.title -eq $title) {
            $issueDetails = "$($issueItem.number) | $($issueItem.Title) | $($issueItem.assignees.login)"
            Write-Output "Good News! Issue Found:: $($issueDetails)"
            return $issueDetails
        }
    }

    # If no match is found in the loop, return an empty string
    Write-Output "No match found for: $($title)"
    return $issueDetails
}

# Call the function with a title
# $result = Find-GithubIssue -title "Your Issue Title Here"
# Write-Output $result
