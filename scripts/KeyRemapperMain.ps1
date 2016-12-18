# load modules
$thisDirectoryPath = Split-Path $MyInvocation.MyCommand.Path -Parent
$parentDirectoryPath = Split-Path $thisDirectoryPath -Parent
Invoke-Expression (Join-Path $thisDirectoryPath 'HotKeyRegisterer.ps1') | Out-Null
Invoke-Expression (Join-Path $parentDirectoryPath 'settings.ps1') | Out-Null

function Start-Main()
{
  $Script:AppName = "KeyRemapper"
  $Script:ThisIcon = $null

  function Close-ThisIcon()
  {
    Unregister-HotKeys
    $Script:ThisIcon.Visible = $false

    [System.Environment]::Exit(0)
  }
  
  function Create-ThisIcon()
  {
    Add-Type -AssemblyName System.Windows.Forms
    $notifyIcon = New-Object System.Windows.Forms.NotifyIcon

    # create context menu and its item
    $exitMenuItem = New-Object System.Windows.Forms.ToolStripMenuItem("Exit $Script:AppName")
    $exitMenuItem.Add_Click({Close-ThisIcon})
    $contextMenu = New-Object System.Windows.Forms.ContextMenuStrip
    $contextMenu.Items.Add($exitMenuItem) | Out-Null

    # setup the notify icon
    $notifyIcon.ContextMenuStrip = $contextMenu
    $psExeFilePath = Join-Path $Script:PSHOME "powershell.exe"
    $notifyIcon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($psExeFilePath)
    $notifyIcon.Text = $Script:AppName
    $notifyIcon.Visible = $true

    return $notifyIcon
  }
  
  $Script:ThisIcon = Create-ThisIcon
  
  $remapKeyList = Get-RemapKeyList
  Register-HotKeys -HotKeyList $remapKeyList
}
Start-Main

