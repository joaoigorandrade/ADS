# Google Ads (Native) on Android with Jetpack Compose

This document summarizes the essential information to know about integrating Google Native Ads in an Android app built with Jetpack Compose.

## 1. What are Native Ads?
Native Ads are customizable ad formats that you design to match the exact look and feel of your application. Instead of providing a ready-made banner or interstitial layout, Google provides the **assets** (headline, icon, body text, call to action, etc.), and you place them within your own custom UI.

## 2. Setting Up
- **Grade Dependencies**: Include the Play Services Ads SDK:
  `implementation("com.google.android.gms:play-services-ads:23.x.x")`
- **Application ID**: Add your Ads Application ID as a `<meta-data>` tag in your `AndroidManifest.xml` (inside the `<application>` tag). Failing to do so will result in a runtime crash upon initialization.
- **Initialize SDK**: Call `MobileAds.initialize(context) {}` at the app launch (e.g., in `MainActivity.onCreate` or a custom Application class).

## 3. Jetpack Compose Integration Basics
Currently, Google AdMob **requires** use of the `NativeAdView` (which is a subclass of an Android `ViewGroup`) as the root of the layout displaying the native ad. Consequently, pure-Compose native ads are not fully supported natively without dropping down to interoperability views.

The easiest and safest way to use Native Ads in Compose is by utilizing Jetpack Compose's **`AndroidView`**. 

## 4. Key Implementation Steps
### 1. Pure Compose integration (No XML needed!)
Unlike older tutorials that suggest building a `native_ad_layout.xml` file, you can achieve a complete Jetpack Compose integration by embedding a `ComposeView` inside the required `NativeAdView`.

### 2. The Ad Loader (`AdLoader`)
You request a Native Ad via `AdLoader.Builder`, providing:
- Your ad unit ID.
- A listener for `forNativeAd` where you retrieve the finalized `NativeAd` object.
- A listener for `withAdListener` to handle lifecycle events (like load errors).
- Call `.loadAd(AdRequest.Builder().build())` to trigger the actual request.

### 3. Binding the Ad with AndroidView and ComposeView
Within your Compose UI, create the top-level `AndroidView` that returns the `NativeAdView` and injects a `ComposeView` inside it to handle clicks and UI rendering:

```kotlin
@Composable
fun NativeAdViewComposable(nativeAd: NativeAd) {
    val context = LocalContext.current
    val mediaView = remember { MediaView(context) }

    AndroidView(
        modifier = Modifier.fillMaxWidth().padding(8.dp),
        factory = { ctx ->
            // 1. Create the NativeAdView (Top-level Container required by AdMob)
            val adView = NativeAdView(ctx)
            
            // 2. Create the ComposeView to house the pure Compose UI
            val composeView = ComposeView(ctx)
            adView.addView(composeView)

            // 3. Registering the compose view to handle clicks for all general assets
            adView.callToActionView = composeView
            adView.headlineView = composeView
            adView.bodyView = composeView
            adView.iconView = composeView
            
            // 4. Register the specific NativeAd MediaView
            adView.mediaView = mediaView

            adView
        },
        update = { adView ->
            val composeView = adView.getChildAt(0) as ComposeView
            
            // 5. Render the custom Compose UI inside the NativeAdView
            composeView.setContent {
                MaterialTheme {
                    // Your custom @Composable UI building the Native Ad Design
                    NativeAdCard(nativeAd = nativeAd, mediaView = mediaView)
                }
                
                // 6. Critically bind the NativeAd object via setNativeAd inside a LaunchedEffect
                LaunchedEffect(nativeAd) {
                    adView.setNativeAd(nativeAd)
                }
            }
        }
    )
}
```

### 4. Handling Media Content
Any video or image assets provided by the native ad *must* be rendered inside Google's specific `MediaView`. 
Create this `MediaView` outside your Compose layout (e.g. using `remember`), register it in the `factory` of the outer `AndroidView`, and then inject it back into your inner Compose UI using another nested `AndroidView`:

```kotlin
// Inside your Pure Compose UI
nativeAd.mediaContent?.let { mediaContent ->
    AndroidView(
        modifier = Modifier.fillMaxWidth().height(200.dp),
        factory = { mediaView }, // Return the shared MediaView instance
        update = { view -> view.mediaContent = mediaContent }
    )
}
```

## 5. Important Rules & Gotchas
1. **Never forget `setNativeAd(ad)`**: If you do not pass the loaded `NativeAd` object to the `NativeAdView`, clicks/impressions won't be counted, and your account could be flagged.
2. **Handle Null Assets**: Native Ads aren't guaranteed to return every single asset (e.g., body or icon could be null). Make sure you hide (`View.GONE` / `View.INVISIBLE`) views when the corresponding asset is unavailable.
3. **Clean Up Ad Objects**: Ads can be memory heavy. Call `nativeAd.destroy()` when you remove the ad from the UI or get a new ad to replace an old one.
