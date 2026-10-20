# 本地运行助手；不安装软件。可用 -Rscript 指定已有Rscript.exe绝对路径。
param([string]$Rscript='')
$ErrorActionPreference='Stop'
$projectRoot=$PSScriptRoot
if(-not $Rscript) {
  $candidate=Join-Path $projectRoot '..\..\work\runtime\R-4.6.1\bin\x64\Rscript.exe'
  if(Test-Path -LiteralPath $candidate) { $Rscript=(Resolve-Path -LiteralPath $candidate).Path }
  else { $Rscript=(Get-Command Rscript -ErrorAction Stop).Source }
}
if(-not(Test-Path -LiteralPath $Rscript)) { throw '找不到Rscript，请提供-Rscript路径。' }
$previous=@{}
foreach($key in @('LANG','LC_ALL','OMP_NUM_THREADS','OPENBLAS_NUM_THREADS','MKL_NUM_THREADS')) {
  $previous[$key]=[Environment]::GetEnvironmentVariable($key,'Process')
}
$env:LANG='English_United States.utf8';$env:LC_ALL='English_United States.utf8'
$env:OMP_NUM_THREADS='1';$env:OPENBLAS_NUM_THREADS='1';$env:MKL_NUM_THREADS='1'
$stamp=Get-Date -Format 'yyyyMMdd_HHmmss'
$logRoot=Join-Path $projectRoot 'methods\Slingshot\logs'
Push-Location $projectRoot
try {
  & $Rscript --vanilla methods/Slingshot/scripts/run_example.R 1> (Join-Path $logRoot ($stamp+'_stdout.log')) 2> (Join-Path $logRoot ($stamp+'_stderr.log'))
  $runExit=$LASTEXITCODE
  [PSCustomObject]@{exit_code=$runExit;utc=(Get-Date).ToUniversalTime().ToString('o');Rscript=$Rscript} |
    ConvertTo-Json | Set-Content (Join-Path $logRoot ($stamp+'_exit.json')) -Encoding utf8
  if($runExit -ne 0) { throw ('R执行失败，退出码'+$runExit+'；请查看本次stdout/stderr。') }
  Write-Output 'Slingshot小例完成，请查看methods/Slingshot/figures与results。'
} finally {
  Pop-Location
  foreach($key in $previous.Keys) { [Environment]::SetEnvironmentVariable($key,$previous[$key],'Process') }
}
