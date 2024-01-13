<#
.SYNOPSIS
Updating the module names list in the issue template

.DESCRIPTION
CSV data for moules and pattern is loaded and overwrites the list in the issue template. The changes are then commited to the repository.

.PARAMETER Repo
Repository name according to GitHub (owner/name)

.PARAMETER RepoRoot
Optional. Path to the root of the repository.

.EXAMPLE
Sync-AvmModulesList -Repo 'Azure/bicep-registry-modules'

.NOTES
Will be triggered by the workflow avm.platform.sync-avm-modules-list.yml
#>
function Sync-AvmModulesList {
  param (
    [Parameter(Mandatory = $true)]
    [string] $Repo,

    [Parameter(Mandatory = $false)]
    # [string] $RepoRoot = (Get-Item -Path $PSScriptRoot).parent.parent.parent.parent.FullName
    [string] $RepoRoot = (Get-Item -Path $PSScriptRoot).parent.FullName
  )

  $workflowFilePath = Join-Path $RepoRoot '.github' 'ISSUE_TEMPLATE' 'avm_module_issue.yml'

  # get CSV data
  $modules = Get-AvmCsvData -ModuleIndex "Bicep-Resource" | Select-Object -Property "ModuleName"
  $patterns = Get-AvmCsvData -ModuleIndex "Bicep-Pattern" | Select-Object -Property "ModuleName"

  # build new strings
  $prefix = '        - "'
  $postfix = '"'
  $moduleLines = $modules | ForEach-Object { $prefix + $_.ModuleName + $postfix }
  $patternLines = $patterns | ForEach-Object { $prefix + $_.ModuleName + $postfix }

  # parse workflow file
  $workflowFileLines = Get-Content $workflowFilePath
  $startIndex = 0
  $endIndex = 0

  for ($lineNumber = 0; $lineNumber -lt $workflowFileLines.Count; $lineNumber++) {
    if ($startIndex -gt 0 -and (-not $workflowFileLines[$lineNumber].StartsWith('        - "avm/'))) {
      $endIndex = $lineNumber
      break
    }

    if ($workflowFileLines[$lineNumber] -eq '        - "Other, as defined below..."') {
      $startIndex = $lineNumber
    }
  }

  # build new workflow file
  $newWorkflowFileLines = $workflowFileLines[0..$startIndex] + $moduleLines + $patternLines + $workflowFileLines[$endIndex..$workflowFileLines.Count]
  $newWorkflowFileLines | Out-File -FilePath $workflowFilePath

  # save changes to repo
  git add .
  git commit -m "Updating module list"
  git push
}