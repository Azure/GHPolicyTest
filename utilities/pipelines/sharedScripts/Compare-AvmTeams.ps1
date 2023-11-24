Function Compare-AvmTeams {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Bicep-Resource', 'Bicep-Pattern', 'Terraform-Resource', 'Terraform-Pattern')]
        [string]$ModuleIndex,
        [Parameter(Mandatory)]
        [ValidateSet('AllTeams', 'AllResource', 'AllPattern', 'AllBicep', 'AllBicepResource', 'BicepResourceOwners', 'BicepResourceContributors', 'AllBicepPattern', 'BicepPatternOwners', 'BicepPatternContributors', 'AllTerraform', 'AllTerraformResource', 'TerraformResourceOwners', 'TerraformResourceContributors', 'AllTeraformPattern', 'TerraformPatternOwners', 'TerraformPatternContributors' )]
        [string]$TeamFilter,
        [switch]$validateOwnersParent,
        [switch]$validateContributorsParent
    )

    # Load used functions
    . (Join-Path $PSScriptRoot 'Get-AvmCsvData.ps1')
    . (Join-Path $PSScriptRoot 'Get-AvmGitHubTeamsData.ps1')

    if ($TeamFilter -like '*All*') {
        $validateAll = $true
    }

    if ($TeamFilter -like '*Owners*') {
        $validateOwners = $true
    }
    if ($TeamFilter -like '*Contributors*') {
        $validateContributors = $true
    }

    # Retrieve the CSV file
    $sourceData = Get-AvmCsv -ModuleIndex $ModuleIndex
    $gitHubTeamsData = Get-GitHubTeams -TeamFilter $TeamFilter
    $unmatchedTeams = @()
    # Iterate through each object in $csv
    foreach ($module in $sourceData) {
        # Assume no match is found initially
        $matchFound = $false
        if ($validateOwners -Or $validateAll) {
            # Check each object in $ghTeam for a match
            foreach ($ghTeam in $gitHubTeamsData) {
                if ($module.ModuleOwnersGHTeam -eq $ghTeam.name) {
                    # If a match is found, set flag to true and break out of the loop
                    $matchFound = $true

                    # Validate if Parent Team is configured for Owners Team
                    if ($validateOwnersParent) {
                        # Check if Parent Team is configured for Owners Team
                        if (-not $null -eq $ghTeam.parent -And $validateOwnersParent) {
                            Write-Verbose "Found team: $($module.ModuleOwnersGHTeam) with parent: $($ghTeam.parent.name) owned by $($module.PrimaryModuleOwnerDisplayName)"
                            break
                        }
                        else {
                            Write-Verbose "Uh-oh no parent team configured for $($module.ModuleOwnersGHTeam) ($($module.PrimaryModuleOwnerDisplayName))"
                            # Create a custom object for the unmatched team
                            $unmatchedTeam = [PSCustomObject]@{
                                TeamName       = $module.ModuleOwnersGHTeam
                                Validation     = "No parent team assigned."
                                Owner          = "$($module.PrimaryModuleOwnerGHHandle) ($($module.PrimaryModuleOwnerDisplayName))"
                                GitHubTeamName = $ghTeam.name
                            }
                            # Add the custom object to the array
                            $unmatchedTeams += $unmatchedTeam
                            break
                        }
                    }
                    else {
                        # Write verbose output without parent check
                        Write-Verbose "Found team: $($module.ModuleOwnersGHTeam) ($($module.PrimaryModuleOwnerDisplayName))"
                        break
                    }
                }


                # Check for match with "@Azure/" prefix
                # Construct the prefixed team name
                $prefixedTeamName = "@azure/" + $module.ModuleOwnersGHTeam

                # Check for match with "@Azure/" prefix
                if ($prefixedTeamName -eq $ghTeam.name) {
                    $matchFound = $true
                    Write-Verbose "Uh-oh team found with '@azure/' prefix for: $($ghTeam.name), Current Owner is $($module.PrimaryModuleOwnerGHHandle) ($($module.PrimaryModuleOwnerDisplayName))"
                    $unmatchedTeam = [PSCustomObject]@{
                        TeamName       = $module.ModuleOwnersGHTeam
                        Validation     = "@azure/ prefix found."
                        Owner          = "$($module.PrimaryModuleOwnerGHHandle) ($($module.PrimaryModuleOwnerDisplayName))"
                        GitHubTeamName = $ghTeam.name
                        
                    }
                    # Add the custom object to the array
                    $unmatchedTeams += $unmatchedTeam
                    break
                }
            }

            # If no match was found, output the item from $csv
            if (-not $matchFound) {
                Write-Verbose "No team found for: $($module.ModuleOwnersGHTeam), Current Owner is $($module.PrimaryModuleOwnerGHHandle) ($($module.PrimaryModuleOwnerDisplayName))"
                $unmatchedTeam = [PSCustomObject]@{
                    TeamName       = $module.ModuleOwnersGHTeam
                    Validation     = "No team found."
                    Owner          = "$($module.PrimaryModuleOwnerGHHandle) ($($module.PrimaryModuleOwnerDisplayName))"
                    GitHubTeamName = "N/A"
                }
                # Add the custom object to the array
                $unmatchedTeams += $unmatchedTeam
            }
        }

        if ($validateContributors -Or $validateAll) {
            # Check each object in $ghTeam for a match
            foreach ($ghTeam in $gitHubTeamsData) {
                if ($module.ModuleContributorsGHTeam -eq $ghTeam.name) {
                    # If a match is found, set flag to true and break out of the loop
                    $matchFound = $true
                    
                    # Validate if Parent Team is configured for Contributors Team
                    if ($validateContributorsParent) {
                        # Check if Parent Team is configured for Contributors Team
                        if (-not $null -eq $ghTeam.parent -And $validateContributorsParent) {
                            Write-Verbose "Found team: $($module.ModuleContributorsGHTeam)  with parent: $($ghTeam.parent.name) owned by $($module.PrimaryModuleOwnerDisplayName)"
                            break
                        }
                        else {
                            Write-Verbose "Uh-oh no parent team configured for $($module.ModuleContributorsGHTeam) ($($module.PrimaryModuleOwnerDisplayName))"
                            # Create a custom object for the unmatched team
                            $unmatchedTeam = [PSCustomObject]@{
                                TeamName       = $module.ModuleContributorsGHTeam
                                Validation     = "No parent team assigned."
                                Owner          = "$($module.PrimaryModuleOwnerGHHandle) ($($module.PrimaryModuleOwnerDisplayName))"
                                GitHubTeamName = $ghTeam.name
                            }
                            # Add the custom object to the array
                            $unmatchedTeams += $unmatchedTeam
                        }
                    }
                    else {
                        Write-Verbose "Found team: $($module.ModuleContributorsGHTeam) ($($module.PrimaryModuleOwnerDisplayName))"
                    }
                    break
                }
                
                # Check for match with "@Azure/" prefix
                # Construct the prefixed team name
                $prefixedTeamName = "@azure/" + $module.ModuleContributorsGHTeam

                # Check for match with "@Azure/" prefix
                if ($prefixedTeamName -eq $ghTeam.name) {
                    $matchFound = $true
                    Write-Verbose "Uh-oh team found with '@azure/' prefix for: $($ghTeam.name), Current Owner is $($module.PrimaryModuleOwnerGHHandle) ($($module.PrimaryModuleOwnerDisplayName))"
                    $unmatchedTeam = [PSCustomObject]@{
                        TeamName       = $module.ModuleContributorsGHTeam
                        Validation     = "@azure/ prefix found."
                        Owner          = "$($module.PrimaryModuleOwnerGHHandle) ($($module.PrimaryModuleOwnerDisplayName))"
                        GitHubTeamName = $ghTeam.name
                    }
                    # Add the custom object to the array
                    $unmatchedTeams += $unmatchedTeam
                    break
                    break
                }
            }

            # If no match was found, output the item from $csv
            if (-not $matchFound) {
                Write-Verbose "No team found for: $($module.ModuleContributorsGHTeam), Current Owner is $($module.PrimaryModuleOwnerGHHandle) ($($module.PrimaryModuleOwnerDisplayName))"
                if (-not $matchFound) {
                    Write-Verbose "No team found for: $($module.ModuleContributorsGHTeam), Current Owner is $($module.PrimaryModuleOwnerGHHandle) ($($module.PrimaryModuleOwnerDisplayName))"
                    $unmatchedTeam = [PSCustomObject]@{
                        TeamName       = $module.ModuleContributorsGHTeam
                        Validation     = "No team found."
                        Owner          = "$($module.PrimaryModuleOwnerGHHandle) ($($module.PrimaryModuleOwnerDisplayName))"
                        GitHubTeamName = "N/A"
                    }
                    # Add the custom object to the array
                    $unmatchedTeams += $unmatchedTeam
                }
            }
        }
    }
    # Check if $unmatchedTeams is empty
    if ($unmatchedTeams.Count -eq 0) {
        Write-Host "No unmatched teams found."
        $LASTEXITCODE = 0
    } 
    else {
        $jsonOutput = $unmatchedTeams | ConvertTo-Json -Depth 3
        Write-Warning "Unmatched teams found:"
        Write-Warning $jsonOutput | Out-String

        #Output in JSON for follow on tasks
        Write-Error "Unmatched teams found, Review warnings for details."
        $LASTEXITCODE = 1
        return $jsonOutput
    } 
}