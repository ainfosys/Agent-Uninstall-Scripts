param(
  $removeFoldersAndRegistry = $false
)

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
$RoboShadow = $MSIs | where {$_.name -ieq "RoboShadow Agent"}
if([bool]$RoboShadow){
    $Process = start-process msiexec -ArgumentList "/x $($RoboShadow.ProductCode) /qn /norestart" -Wait -PassThru
    Translate-ExitCode -Process $Process -AutoOutput
    
    if($removeFoldersAndRegistry -eq $true){ 
      Write-Output "Removing folders and registry keys"
      if(test-path "$Env:ProgramData\RoboShadow"){
          remove-item -path "$Env:ProgramData\RoboShadow" -Recurse -Force
      }
      if(test-path "HKLM:\SOFTWARE\RoboShadowLtd"){
          remove-item -path "HKLM:\SOFTWARE\RoboShadowLtd" -Force -Recurse
      }
    }
}else{
    Write-Warning "Roboshadow agent not found on system"
}
