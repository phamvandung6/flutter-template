$ErrorActionPreference = 'Stop'

fvm use --skip-pub-get
fvm flutter pub get
fvm dart run build_runner build
fvm dart run import_sorter:main
fvm dart format lib test
fvm flutter analyze
