 
name: Build Android APK
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
      - name: Find and Build Flutter App
        run: |
          # Find directory containing pubspec.yaml
          PUBSPEC_DIR=$(find . -name "pubspec.yaml" -exec dirname {} \; | head -n 1)
          if [ -z "$PUBSPEC_DIR" ]; then
            echo "Error: pubspec.yaml not found!"
            exit 1
          fi
          cd "$PUBSPEC_DIR"
          flutter pub get
          flutter build apk --release
          
          # Move APK to root for easy upload
          mkdir -p $GITHUB_WORKSPACE/output
          cp build/app/outputs/flutter-apk/app-release.apk $GITHUB_WORKSPACE/output/app-release.apk
      - uses: actions/upload-artifact@v3
        with:
          name: release-apk
          path: output/app-release.apk
          
