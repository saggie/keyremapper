# load modules
$thisDirectoryPath = Split-Path $MyInvocation.MyCommand.Path -Parent
$parentDirectoryPath = Split-Path $thisDirectoryPath -Parent

New-Module -ArgumentList $parentDirectoryPath {
  param([string]$parentDirectoryPath)

  function Get-RemapKeyList
  {
    $settingsFilePath = Join-Path $parentDirectoryPath "settings.ini"
    $keySettings = Get-Content $settingsFilePath | where { $_ -match ".*=.*" } | ConvertFrom-StringData

    $ret = @()
    foreach ($eachKey in $keySettings.Keys)
    {
      $ret += @{
        BeforeKey = $eachKey;
        AfterKey = $keySettings.$eachKey
      }
    }
    return $ret
  }
  Export-ModuleMember -Function Get-RemapKeyList
} | Out-Null
