. .\config.ps1
$baseUrl = $config.BaseUrl
$user = $config.User
$pass = $config.Password
$spass = ConvertTo-SecureString $pass -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($user, $spass)
$mydir = Split-Path (Get-Variable MyInvocation -Scope 0).Value.MyCommand.Path -parent
$logfile = Join-Path $mydir "autobuild.log"

function TrimLog {
  $lastLines = Get-Content -Tail 1024 $logfile
  Set-Content $logfile $lastLines
}

function Start-Log {
  TrimLog
  Write-Host "Logging to $logfile"
  Add-Content $logfile "`n"
  Write-Log "Starting autobuild"
  Write-Log "-------------------"
}

function Write-Log {
  param ([string] $logString)
  $stamped = "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") $logString"
  Write-Host $stamped
  Add-Content $logfile -value $stamped
}

function triggerBuild {
  Write-Log "Triggering build..."
  $url = "$baseUrl/build/builds?api-version=2.0"
  $body = @{ definition = @{ id = $config.BuildDefinitionId }; reason = $config.BuildReason } | ConvertTo-Json

  Invoke-RestMethod $url -Credential $cred -Body $body -Method "POST" -ContentType "application/json"
}

function getHeadCommitHash {
  $url = $config.GitRepo
  Write-Log "Querying HEAD hash on $url"
  $pinfo = New-Object System.Diagnostics.ProcessStartInfo
  $pinfo.FileName = "git.exe"
  $pinfo.RedirectStandardError = $true
  $pinfo.RedirectStandardOutput = $true
  $pinfo.UseShellExecute = $false
  $pinfo.Arguments = "ls-remote $url"
  $proc = New-Object System.Diagnostics.Process
  $proc.StartInfo = $pinfo
  $proc.Start() | Out-Null
  $proc.WaitForExit();
  
  $output = $proc.StandardOutput.ReadToEnd();
  $lines = $output.Split("\r\n")
  ForEach ($line in $lines) {
    $parts = $line -split '\s+'
    if ($parts.Length -gt 1) {
      if ($parts[1] -eq "HEAD") {
        return $parts[0]
      }
    }
  }
  return "unknown"
}

function buildExistsFor {
  param
  (
    [string] $hash
  )
  Write-Log "Looking for existing build for ${hash}"
  $url = "$baseUrl/build/builds?api-version=2.0"
  Write-Log $url
  $result = Invoke-RestMethod $url -Credential $cred
  ForEach ($build in $result.value) {
    if ($build.sourceVersion -eq $hash) {
      return $build.buildNumber
    }
  }
  return $false
}

function main {
  $head = $(getHeadCommitHash)
  $alreadyBuilt = buildExistsFor $head
  if ($alreadyBuilt) {
    Write-Log "build exists for ${head}: ${alreadyBuilt}"
    return
  }
  triggerBuild
}

Start-Log
main