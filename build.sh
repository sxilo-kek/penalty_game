#!/bin/bash
git clone https://github.com/flutter/flutter.git -b stable --depth 1 /tmp/flutter
export PATH="$PATH:/tmp/flutter/bin"
flutter doctor
flutter build web --release