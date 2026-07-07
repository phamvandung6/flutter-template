$ErrorActionPreference = 'Stop'

fvm flutter analyze
fvm dart format lib test --set-exit-if-changed
