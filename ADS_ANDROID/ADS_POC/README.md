# Google Ads Native POC - iOS (SwiftUI)

This project contains a Proof-of-Concept (POC) for integrating **Google AdMob Native Advanced Ads** in a modern iOS SwiftUI application.

## Integration Steps

To run this project successfully, please ensure you complete the following steps:

### 1. Add GoogleMobileAds SDK using Swift Package Manager
1. Open the `.xcodeproj` file in Xcode.
2. Navigate to **File > Add Package Dependencies...**
3. Enter the URL for the Google Mobile Ads SDK repository:
   `https://github.com/googleads/swift-package-manager-google-mobile-ads.git`
4. Choose the appropriate version rule (e.g., Up to Next Major Version) and click **Add Package**.
5. Make sure `GoogleMobileAds` is added to your target.

### 2. Configure `Info.plist` (Required)
AdMob requires the application identifier to be provided in the targets' properties before building:
1. Go to your Xcode project settings.
2. Select your Target (`ADS_POC`) -> **Info** tab.
3. Under "Custom iOS Target Properties", add a new Key-Value pair:
   - **Key**: `GADApplicationIdentifier`
   - **Type**: `String`
   - **Value**: `ca-app-pub-3940256099942544~1458002511` *(This is Google's test application ID. Replace with your actual ID for production.)*

### 3. Build & Run
- Everything is wired up:
  - `ADS_POCApp.swift` initializes the SDK inside the `AppDelegate`.
  - `NativeAdViewModel.swift` fetches the ad using a test Native Ad unit ID (`ca-app-pub-3940256099942544/3986624511`).
  - `NativeAdView.swift` maps the UI components (Headline, Body, Image, CTA) smoothly using `UIViewRepresentable` and `GADNativeAdView`.
  - `ContentView.swift` integrates the ad logic seamlessly inside SwiftUI.

## Architecture
- `NativeAdViewModel`: Handles ad lifecycle utilizing `GADAdLoader` and AdMob Delegate events.
- `NativeAdView`: Wraps `GADNativeAdView` using `UIViewRepresentable` to bridge between UIKit (`UIView`) and SwiftUI.
- Custom Views: You can adjust the UI Constraints inside `NativeAdView`'s `makeUIView` function to fit your specific design needs.
