# Branding Tooling

This directory contains example configs for optional app branding generators.

The boilerplate includes the generator packages, but does not ship real brand
assets. Add project-specific assets before running these tools.

## Setup

1. Add brand assets, for example:

```text
assets/branding/app_icon.png
assets/branding/splash_logo.png
```

2. Copy the example configs:

```bash
cp tool/branding/flutter_launcher_icons.yaml.example tool/branding/flutter_launcher_icons.yaml
cp tool/branding/flutter_native_splash.yaml.example tool/branding/flutter_native_splash.yaml
```

3. Adjust colors and asset paths.

4. Generate platform files:

```bash
make gen-icons
make gen-splash
```

On Windows without `make`:

```powershell
fvm dart run flutter_launcher_icons -f tool/branding/flutter_launcher_icons.yaml
fvm dart run flutter_native_splash:create --path=tool/branding/flutter_native_splash.yaml
```

