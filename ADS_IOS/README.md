# ADS_POC — Google Native Ads iOS Lab

> A hands-on Proof of Concept showcasing **every** configuration option available for Google AdMob Native Ads on iOS.

---

## 📱 What's Inside

### 🎛 Ad Loader Configurations (11 examples)

Each configuration demonstrates a different `AdLoaderOptions` you can pass to `AdLoader`:

| Config | Class Used | Property | What It Does |
|--------|-----------|----------|--------------|
| **Standard** | `NativeAdImageAdLoaderOptions` | _(defaults)_ | No special options — baseline behavior |
| **Landscape Media** | `NativeAdMediaAdLoaderOptions` | `.mediaAspectRatio = .landscape` | Prefers landscape aspect ratio for ad creatives |
| **Portrait Media** | `NativeAdMediaAdLoaderOptions` | `.mediaAspectRatio = .portrait` | Prefers portrait aspect ratio for ad creatives |
| **Square Media** | `NativeAdMediaAdLoaderOptions` | `.mediaAspectRatio = .square` | Prefers square aspect ratio for ad creatives |
| **Video (Unmuted)** | `VideoOptions` | `.shouldStartMuted = false` | Video starts with audio ON |
| **Custom Video Controls** | `VideoOptions` | `.areCustomControlsRequested = true` | Requests custom play/pause/mute controls (SDK won't render its own) |
| **Multiple Images** | `NativeAdImageAdLoaderOptions` | `.shouldRequestMultipleImages = true` | Returns all images for multi-image assets |
| **Manual Image Download** | `NativeAdImageAdLoaderOptions` | `.isImageLoadingDisabled = true` | SDK returns URIs only — you download images yourself |
| **Multiple Ads (Feed)** | `MultipleAdsAdLoaderOptions` | `.numberOfAds = 5` | Loads up to 5 unique ads in a single request |
| **AdChoices Top-Left** | `NativeAdViewAdOptions` | `.preferredAdChoicesPosition = .topLeftCorner` | Moves the AdChoices icon to the top-left |
| **AdChoices Bottom-Right** | `NativeAdViewAdOptions` | `.preferredAdChoicesPosition = .bottomRightCorner` | Moves the AdChoices icon to the bottom-right |

### 🎨 Visual Styles (5 layouts)

Each style renders the **same** `NativeAd` data with a completely different layout:

| Style | Description | Best For |
|-------|-------------|----------|
| **Article Feed** | News feed-like card with icon, headline, body, media, star rating, CTA | Content apps, news readers |
| **Compact Banner** | Small horizontal bar with icon, title, and CTA button | Lists, between items |
| **Full Media** | Full-bleed media with overlay text (Instagram-like) | Photo/video apps, stories |
| **App Install Card** | Emphasizes star rating, store, price — App Store style | App promotion campaigns |
| **Video Player** | Large media player area with bottom info bar | Video/streaming apps |

### 🐛 Debug Panel

Tap the **ant icon** 🐜 in the navigation bar to toggle the debug panel, which shows:
- All `NativeAd` properties: headline, body, advertiser, CTA
- `starRating`, `store`, `price` (if available)
- Media info: hasVideo, aspect ratio, number of images
- Extra asset keys

---

## 🔑 Key Native Ad Properties

The `NativeAd` object contains these assets you can display:

```swift
nativeAd.headline        // String? — Primary headline text
nativeAd.body            // String? — Body/description text
nativeAd.callToAction    // String? — CTA button text (e.g. "Install", "Learn More")
nativeAd.icon            // NativeAdImage? — Small app/brand icon
nativeAd.images          // [NativeAdImage]? — Array of images
nativeAd.starRating      // NSDecimalNumber? — App star rating (0-5)
nativeAd.store           // String? — App store name (e.g. "Google Play", "App Store")
nativeAd.price           // String? — Price text (e.g. "Free", "$1.99")
nativeAd.advertiser      // String? — Advertiser name
nativeAd.mediaContent    // MediaContent — Video/image media content
nativeAd.extraAssets      // [String: Any]? — Additional custom assets
```

---

## ⚙️ Configuration Classes Reference

### `NativeAdMediaAdLoaderOptions`
```swift
let options = NativeAdMediaAdLoaderOptions()
options.mediaAspectRatio = .landscape  // .any, .portrait, .landscape, .square
```

### `NativeAdImageAdLoaderOptions`
```swift
let options = NativeAdImageAdLoaderOptions()
options.isImageLoadingDisabled = true     // SDK returns URIs only
options.shouldRequestMultipleImages = true // Get all images in a series
```

### `VideoOptions`
```swift
let options = VideoOptions()
options.shouldStartMuted = false          // Video plays with sound
options.areCustomControlsRequested = true  // You provide play/pause/mute UI
```

### `NativeAdViewAdOptions`
```swift
let options = NativeAdViewAdOptions()
options.preferredAdChoicesPosition = .topLeftCorner
// .topRightCorner (default), .topLeftCorner, .bottomRightCorner, .bottomLeftCorner
```

### `MultipleAdsAdLoaderOptions`
```swift
let options = MultipleAdsAdLoaderOptions()
options.numberOfAds = 5  // Up to 5 unique ads per request
```

### AdChoices Custom View
```swift
let customAdChoicesView = AdChoicesView(frame: CGRect(x: 100, y: 100, width: 15, height: 15))
nativeAdView.addSubview(customAdChoicesView)
nativeAdView.adChoicesView = customAdChoicesView
```

---

## 🔗 Important NativeAdView Assignments

For the SDK to properly track impressions and clicks, you **must** assign views:

```swift
let adView = NativeAdView()

adView.nativeAd = nativeAd              // ⚠️ REQUIRED — connects ad data

adView.headlineView = headlineLabel      // Required
adView.bodyView = bodyLabel              // Optional
adView.iconView = iconImageView          // Optional
adView.mediaView = mediaView             // Optional (but recommended)
adView.callToActionView = ctaButton      // Optional
adView.advertiserView = advertiserLabel  // Optional
adView.starRatingView = starLabel        // Optional
adView.storeView = storeLabel            // Optional
adView.priceView = priceLabel            // Optional
adView.adChoicesView = adChoicesView     // Optional (for custom position)
```

---

## 📋 Test Ad Unit IDs

| Format | Ad Unit ID |
|--------|-----------|
| Native | `ca-app-pub-3940256099942544/3986624511` |
| Native Video | `ca-app-pub-3940256099942544/2521693316` |

---

## 📚 Official Documentation

- [Load a native ad (iOS)](https://developers.google.com/admob/ios/native)
- [Set advanced native features](https://developers.google.com/admob/ios/native/options)
- [Native ad API reference](https://developers.google.com/admob/ios/api/reference/Classes/GADNativeAd)
