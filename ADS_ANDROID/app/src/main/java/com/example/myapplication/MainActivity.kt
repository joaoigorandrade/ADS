package com.example.myapplication

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.viewinterop.AndroidView
import com.google.android.gms.ads.AdListener
import com.google.android.gms.ads.AdLoader
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.LoadAdError
import com.google.android.gms.ads.MobileAds
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdOptions
import com.google.android.gms.ads.nativead.NativeAdView
import com.google.android.gms.ads.nativead.MediaView

class MainActivity : ComponentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Initialize the Mobile Ads SDK
        MobileAds.initialize(this) {}

        setContent {
            MaterialTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    NativeAdScreen()
                }
            }
        }
    }
}

@Composable
fun NativeAdScreen() {
    val context = LocalContext.current
    var nativeAd by remember { mutableStateOf<NativeAd?>(null) }
    var isLoading by remember { mutableStateOf(false) }
    var adErrorMsg by remember { mutableStateOf<String?>(null) }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text("Google Ads Native POC", style = MaterialTheme.typography.headlineMedium)
        Spacer(modifier = Modifier.height(16.dp))

        Button(onClick = {
            isLoading = true
            adErrorMsg = null
            
            // Clean up old ad before loading a new one
            nativeAd?.destroy()
            nativeAd = null
            
            val adLoader = AdLoader.Builder(context, "ca-app-pub-3940256099942544/2247696110")
                .forNativeAd { ad: NativeAd ->
                    // Discard ad if activity is destroyed, here we just set state
                    nativeAd = ad
                }
                .withAdListener(object : AdListener() {
                    override fun onAdFailedToLoad(error: LoadAdError) {
                        isLoading = false
                        adErrorMsg = error.message
                    }
                    override fun onAdLoaded() {
                        isLoading = false
                    }
                })
                .withNativeAdOptions(NativeAdOptions.Builder().build())
                .build()

            adLoader.loadAd(AdRequest.Builder().build())
        }) {
            Text("Load Native Ad")
        }

        Spacer(modifier = Modifier.height(16.dp))

        if (isLoading) {
            CircularProgressIndicator()
        }

        adErrorMsg?.let {
            Text("Error loading ad: $it", color = MaterialTheme.colorScheme.error)
        }

        nativeAd?.let { ad ->
            NativeAdViewComposable(nativeAd = ad)
        }
    }
}

@Composable
fun NativeAdViewComposable(nativeAd: NativeAd) {
    val context = LocalContext.current
    val mediaView = remember { MediaView(context) }

    AndroidView(
        modifier = Modifier
            .fillMaxWidth()
            .padding(8.dp),
        factory = { ctx ->
            // 1. Create the NativeAdView (Container)
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
            
            // Render the Compose UI inside the NativeAdView
            composeView.setContent {
                MaterialTheme {
                    NativeAdCard(nativeAd = nativeAd, mediaView = mediaView)
                }
                
                // Set the ad only when the composition layout is applied
                LaunchedEffect(nativeAd) {
                    adView.setNativeAd(nativeAd)
                }
            }
        }
    )
}

@Composable
fun NativeAdCard(nativeAd: NativeAd, mediaView: MediaView) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface)
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            
            // Headline
            Text(
                text = nativeAd.headline ?: "Ad",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold,
                color = MaterialTheme.colorScheme.onSurface
            )
            Spacer(modifier = Modifier.height(8.dp))
            
            // Media Content (Image/Video)
            nativeAd.mediaContent?.let { mediaContent ->
                AndroidView(
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(200.dp)
                        .clip(RoundedCornerShape(8.dp)),
                    factory = { mediaView }, // Return the shared MediaView instance
                    update = { view ->
                        view.mediaContent = mediaContent
                    }
                )
                Spacer(modifier = Modifier.height(8.dp))
            }
            
            // Body Text
            nativeAd.body?.let { body ->
                Text(
                    text = body,
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
                Spacer(modifier = Modifier.height(8.dp))
            }
            
            // Call to Action
            nativeAd.callToAction?.let { cta ->
                Box(
                    modifier = Modifier
                        .align(Alignment.End)
                        .background(MaterialTheme.colorScheme.primary, RoundedCornerShape(50))
                        .padding(horizontal = 16.dp, vertical = 8.dp)
                ) {
                    Text(
                        text = cta,
                        color = MaterialTheme.colorScheme.onPrimary,
                        fontWeight = FontWeight.Bold
                    )
                }
            }
        }
    }
}