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
        # [switch]$validateContributors,
        # [switch]$validateAll
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
                    Write-Verbose "Found team: $($module.ModuleOwnersGHTeam) ($($module.PrimaryModuleOwnerDisplayName)), Checking for parent team..."
                    if (-not $null -eq $ghTeam.parent -And $validateOwnersParent) {
                        Write-Verbose "Found parent team: $($ghTeam.parent.name) for $($module.ModuleOwnersGHTeam)"
                    }
                    else {
                        Write-Error "Uh-oh no parent team configured for $($module.ModuleOwnersGHTeam) ($($module.PrimaryModuleOwnerDisplayName))"
                    }
                    break
                }
                # Check for match with "@Azure/" prefix
                # Construct the prefixed team name
                $prefixedTeamName = "@azure/" + $module.ModuleOwnersGHTeam

                # Check for match with "@Azure/" prefix
                if ($prefixedTeamName -eq $ghTeam.name) {
                    $matchFound = $true
                    Write-Error "Uh-oh team found with '@azure/' prefix for: $($ghTeam.name), Current Owner is $($module.PrimaryModuleOwnerGHHandle) ($($module.PrimaryModuleOwnerDisplayName))"
                    break
                }
            }

            # If no match was found, output the item from $csv
            if (-not $matchFound) {
                Write-Error "No team found for: $($module.ModuleOwnersGHTeam), Current Owner is $($module.PrimaryModuleOwnerGHHandle) ($($module.PrimaryModuleOwnerDisplayName))"
            }
        }
        if ($validateContributors -Or $validateAll) {
            # Check each object in $ghTeam for a match
            foreach ($ghTeam in $gitHubTeamsData) {
                if ($module.ModuleContributorsGHTeam -eq $ghTeam.name) {
                    # If a match is found, set flag to true and break out of the loop
                    $matchFound = $true
                    Write-Verbose "Match found for: $($module.ModuleContributorsGHTeam) ($($module.PrimaryModuleOwnerDisplayName))"
                    if (-not $null -eq $ghTeam.parent -And $validateContributorsParent) {
                        Write-Verbose "Match found for: $($module.ModuleContributorsGHTeam) ($($module.PrimaryModuleOwnerDisplayName)) ; Parent team is $($ghTeam.parent.name)"
                    }
                    else {
                        Write-Error "Uh-oh no parent team configured for $($module.ModuleContributorsGHTeam) ($($module.PrimaryModuleOwnerDisplayName))"
                    }
                    break
                }
                # Check for match with "@Azure/" prefix
                # Construct the prefixed team name
                $prefixedTeamName = "@azure/" + $module.ModuleContributorsGHTeam

                # Check for match with "@Azure/" prefix
                if ($prefixedTeamName -eq $ghTeam.name) {
                    $matchFound = $true
                    Write-Error "Uh-oh team found with '@azure/' prefix for: $($ghTeam.name), Current Owner is $($module.PrimaryModuleOwnerGHHandle) ($($module.PrimaryModuleOwnerDisplayName))"
                    break
                }
            }

            # If no match was found, output the item from $csv
            if (-not $matchFound) {
                Write-Error "No team found for: $($module.ModuleContributorsGHTeam), Current Owner is $($module.PrimaryModuleOwnerGHHandle) ($($module.PrimaryModuleOwnerDisplayName))"
            }
        }
    }
}