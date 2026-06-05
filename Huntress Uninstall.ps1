(new-object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ainfosys/ScriptHelpers/main/Functions/Translate-ExitCode.ps1') | iex
(new-object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ainfosys/ScriptHelpers/refs/heads/main/Functions/Get-MSIProducts.ps1') | iex
Write-output "Attempting huntress uninstall via uninstaller"
Get-Service HuntressAgent | Stop-service -Force
Get-Service HuntressRio | Stop-service -Force
if(test-path "C:\Program Files\Huntress\Uninstall.exe"){
  $Process = Start-Process "C:\Program Files\Huntress\Uninstall.exe" -ArgumentList "/S" -wait -PassThru
  Translate-ExitCode -Process $Process -autooutput
}else{
  write-warning "Huntress agent not found"
}

$MSIS = get-msiproducts
$Rio = $msis | where {$_.name -ieq "Huntress Rio"}
if([bool]$Rio){
  Write-output "Uninstalling Huntress Rio Agent"
  $Process = start-process msiexec -argumentlist "/x $($Rio.ProductCode) /qn /norestart" -wait -passthru
  Translate-ExitCode -Process $Process -autooutput
}
