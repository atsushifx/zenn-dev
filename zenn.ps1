$zenn = $PSScriptRoot + "/node_modules/.bin/zenn.ps1"
pushd $PSScriptRoot
& $zenn @args
$myexitcode = $LASTEXITCODE
popd
exit $myexitcode
