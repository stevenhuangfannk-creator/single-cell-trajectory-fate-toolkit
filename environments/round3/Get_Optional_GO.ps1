param([Parameter(Mandatory=$true)][string]$CacheDirectory)
$ErrorActionPreference='Stop'
New-Item -ItemType Directory -Force $CacheDirectory | Out-Null
$files=@{
 'wb.gaf.gz'='https://current.geneontology.org/annotations/wb.gaf.gz'
 'go-basic.obo'='https://purl.obolibrary.org/obo/go/go-basic.obo'
}
foreach($name in $files.Keys) {
  & curl.exe -4 -L --fail --max-time 180 --max-filesize 80000000 -o (Join-Path $CacheDirectory $name) $files[$name]
  if($LASTEXITCODE -ne 0){throw "Download failed: $name; partial retained"}
}
Write-Output 'Compare downloaded SHA256 with GO_provenance.json before replacing the recorded snapshot.'
