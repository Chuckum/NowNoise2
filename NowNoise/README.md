# NowNoise

A social music discovery platform built with SwiftUI.

## Features

- Share what you're listening to with photos
- Browse posts in a beautiful grid layout
- Filter posts by time period
- Local storage for offline access

## Requirements

- iOS 15.0+
- Xcode 14.0+
- Swift 5.0+

## Setup

1. Clone the repository:
```bash
git clone https://github.com/yourusername/NowNoise.git
```

2. Open the project in Xcode:
```bash
cd NowNoise
open NowNoise.xcodeproj
```

3. Build and run the project in Xcode

## Building with AppCircle

This project is configured to build with AppCircle. The following environment variables need to be set in AppCircle:

- `APPLE_TEAM_ID`: Your Apple Developer Team ID
- `PROVISIONING_PROFILE`: Your provisioning profile name
- `CERTIFICATE`: Your distribution certificate name
- `BUNDLE_IDENTIFIER`: Your app's bundle identifier

## Project Structure

- `Models/`: Data models
- `Views/`: SwiftUI views
- `ViewModels/`: View models for business logic
- `Managers/`: Utility classes and managers

## License

This project is licensed under the MIT License - see the LICENSE file for details. 