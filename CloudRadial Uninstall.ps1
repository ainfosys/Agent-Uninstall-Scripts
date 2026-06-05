# set tls policy to tls12 and tls13
try{
    [Net.ServicePointManager]::SecurityProtocol = 15360
}
catch{
  # Fall back to tls 1.2 if error thrown
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
}
(new-object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ainfosys/ScriptHelpers/main/Functions/Translate-ExitCode.ps1') | iex
$crUninstall = "C:\Program Files (x86)\CloudRadial Agent\unins000.exe"
if(test-path $crUninstall){
    Write-host "CloudRadial agent found, removing it now"
    $process = Start-Process $crUninstall -ArgumentList "/norestart /verysilent" -Wait -PassThru

    Translate-ExitCode -Process $Process -AutoOutput
}else{
  throw "Cloudradial uninstaller not found"
}
