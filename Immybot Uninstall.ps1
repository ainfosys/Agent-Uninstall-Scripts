# set tls policy to tls12 and tls13
try{
    [Net.ServicePointManager]::SecurityProtocol = 15360
}
catch{
  # Fall back to tls 1.2 if error thrown
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
}
(new-object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ainfosys/ScriptHelpers/main/Functions/Translate-ExitCode.ps1') | iex
(new-object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ainfosys/ScriptHelpers/main/Functions/Get-MSIProducts.ps1') | iex

$MSIs = Get-MSIProducts
$ImmyMSIID = $MSICodes | Where {$_.Name -ilike "ImmyBot Agent*"} | Select -expand ProductCode
$process = Start-Process Msiexec.exe -ArgumentList "/x $ImmyMSIID /qn /norestart" -wait -passthru
Translate-ExitCode -Process $Process -AutoOutput
