param(
  [ValidateSet('tradeSeq','Monocle3','combination')][string]$Module='tradeSeq',
  [string]$RscriptPath='', [string]$LibraryPath='', [switch]$Replot
)
$ErrorActionPreference='Stop'
if(-not $RscriptPath) {
  $candidate=Join-Path $PSScriptRoot '../../work/runtime/R-4.6.1/bin/x64/Rscript.exe'
  if(Test-Path $candidate){$RscriptPath=(Resolve-Path $candidate).Path}
  else {$RscriptPath=(Get-Command Rscript.exe -ErrorAction Stop).Source}
}
if($LibraryPath){$env:TOOLKIT_LIBRARY=$LibraryPath}
$env:LANG='English_United States.utf8';$env:LC_ALL=$env:LANG
$env:OMP_NUM_THREADS='1';$env:OPENBLAS_NUM_THREADS='1';$env:MKL_NUM_THREADS='1'
$pathMap=@{tradeSeq='methods/tradeSeq';Monocle3='methods/Monocle3';combination='combinations/Slingshot_tradeSeq_Monocle3'}
$logDir=Join-Path $PSScriptRoot ($pathMap[$Module]+'/logs')
New-Item -ItemType Directory -Force $logDir | Out-Null
$stamp=Get-Date -Format 'yyyyMMdd_HHmmss_fff'
$log=Join-Path $logDir ('user_entry_'+$stamp+'.log')
Push-Location $PSScriptRoot
try {
  $rArgs=@('round3/run.R',$Module);if($Replot){$rArgs+='replot'}
  & $RscriptPath @rArgs *> $log
  $code=$LASTEXITCODE
  if($code -ne 0){throw "R failed (exit $code). See $log"}
  Write-Output "Completed. Log: $log"
} finally {Pop-Location}
