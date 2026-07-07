$ErrorActionPreference = 'Stop'

fvm dart run import_sorter:main

git diff --quiet -- lib test
if ($LASTEXITCODE -ne 0) {
    Write-Error 'Import sorter changed files. Please review and stage the changes, then run quality-check again.'
}

fvm dart format lib test --set-exit-if-changed
fvm flutter analyze
