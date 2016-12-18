New-Module {
  function Get-RemapKeyList()
  {
    $remapKeyList = @( @{
      KeyString = "PrintScreen";
      Procedure = { [System.Windows.Forms.SendKeys]::SendWait("{Home}") }
    }, @{
      KeyString = "Shift+PrintScreen";
      Procedure = { [System.Windows.Forms.SendKeys]::SendWait("+{Home}") }
    }, @{
      KeyString = "Pause";
      Procedure = { [System.Windows.Forms.SendKeys]::SendWait("{End}") }
    }, @{
      KeyString = "Shift+Pause";
      Procedure = { [System.Windows.Forms.SendKeys]::SendWait("+{End}") }
    } )
    return $remapKeyList
  }
  Export-ModuleMember -Function Get-RemapKeyList
}
