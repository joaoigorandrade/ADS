package com.example.myapplication

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
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
import androidx.compose.ui.unit.sp
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

enum class NativeAdLayoutType {
    TOP_IMAGE, BOTTOM_IMAGE, LEFT_IMAGE, RIGHT_IMAGE
}

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
            .verticalScroll(rememberScrollState())
            .padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text("Google Ads Native POC", style = MaterialTheme.typography.headlineMedium)
        Spacer(modifier = Modifier.height(16.dp))

        Button(onClick = {
            isLoading = true
            adErrorMsg = null
            
            // Allow multiple ad layouts to refer to the same native ad (for POC reuse)
            nativeAd?.destroy()
            nativeAd = null
            
            val adLoader = AdLoader.Builder(context, "ca-app-pub-3940256099942544/2247696110")
                .forNativeAd { ad: NativeAd ->
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
            Column(
                modifier = Modifier.fillMaxWidth(),
                horizontalAlignment = Alignment.Start
            ) {
                Text("Top Image Layout", style = MaterialTheme.typography.titleMedium, color = Color.Gray)
                Spacer(modifier = Modifier.height(8.dp))
                NativeAdViewComposable(nativeAd = ad, layoutType = NativeAdLayoutType.TOP_IMAGE)
                Spacer(modifier = Modifier.height(24.dp))

                Text("Bottom Image Layout", style = MaterialTheme.typography.titleMedium, color = Color.Gray)
                Spacer(modifier = Modifier.height(8.dp))
                NativeAdViewComposable(nativeAd = ad, layoutType = NativeAdLayoutType.BOTTOM_IMAGE)
                Spacer(modifier = Modifier.height(24.dp))

                Text("Left Image Layout", style = MaterialTheme.typography.titleMedium, color = Color.Gray)
                Spacer(modifier = Modifier.height(8.dp))
                NativeAdViewComposable(nativeAd = ad, layoutType = NativeAdLayoutType.LEFT_IMAGE)
                Spacer(modifier = Modifier.height(24.dp))

                Text("Right Image Layout", style = MaterialTheme.typography.titleMedium, color = Color.Gray)
                Spacer(modifier = Modifier.height(8.dp))
                NativeAdViewComposable(nativeAd = ad, layoutType = NativeAdLayoutType.RIGHT_IMAGE)
            }
        }
    }
}

@Composable
fun NativeAdViewComposable(nativeAd: NativeAd, layoutType: NativeAdLayoutType) {
    val context = LocalContext.current
    val mediaView = remember { MediaView(context) }

    AndroidView(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 8.dp),
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
                    NativeAdCard(nativeAd = nativeAd, mediaView = mediaView, layoutType = layoutType)
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
fun NativeAdCard(nativeAd: NativeAd, mediaView: MediaView, layoutType: NativeAdLayoutType) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(16.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 0.dp),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
        border = androidx.compose.foundation.BorderStroke(1.dp, Color.LightGray)
    ) {
        when (layoutType) {
            NativeAdLayoutType.TOP_IMAGE -> TopImageLayout(nativeAd, mediaView)
            NativeAdLayoutType.BOTTOM_IMAGE -> BottomImageLayout(nativeAd, mediaView)
            NativeAdLayoutType.LEFT_IMAGE -> LeftImageLayout(nativeAd, mediaView)
            NativeAdLayoutType.RIGHT_IMAGE -> RightImageLayout(nativeAd, mediaView)
        }
    }
}

// --- Common Sub-components ---

@Composable
fun AdBadge() {
    Text(
        text = "Ad",
        style = MaterialTheme.typography.labelSmall.copy(fontWeight = FontWeight.Bold, fontSize = 10.sp),
        color = Color.DarkGray,
        modifier = Modifier
            .border(0.5.dp, Color.LightGray, RoundedCornerShape(2.dp))
            .background(Color.White.copy(alpha = 0.8f))
            .padding(horizontal = 4.dp, vertical = 2.dp)
    )
}

@Composable
fun AdHeadline(text: String?) {
    Text(
        text = text ?: "Ad",
        style = MaterialTheme.typography.titleMedium,
        fontWeight = FontWeight.Bold,
        color = MaterialTheme.colorScheme.onSurface,
        maxLines = 2
    )
}

@Composable
fun AdBody(text: String?) {
    text?.let {
        Text(
            text = it,
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            maxLines = 3
        )
    }
}

@Composable
fun AdIcon(nativeAd: NativeAd) {
    nativeAd.icon?.drawable?.let { drawable ->
        AndroidView(
            factory = { ctx -> 
                android.widget.ImageView(ctx).apply {
                    setImageDrawable(drawable)
                    scaleType = android.widget.ImageView.ScaleType.FIT_CENTER
                }
            },
            modifier = Modifier
                .size(20.dp)
                .clip(RoundedCornerShape(4.dp))
        )
    }
}

@Composable
fun AdCallToAction(text: String?) {
    text?.let {
        Text(
            text = it,
            color = MaterialTheme.colorScheme.primary,
            fontWeight = FontWeight.Bold,
            style = MaterialTheme.typography.labelLarge
        )
    }
}

// --- Layout Definitions ---

@Composable
fun TopImageLayout(nativeAd: NativeAd, mediaView: MediaView) {
    Column {
        nativeAd.mediaContent?.let { mc ->
            AndroidView(
                modifier = Modifier.fillMaxWidth().height(180.dp),
                factory = { mediaView },
                update = { it.mediaContent = mc }
            )
        }
        Column(modifier = Modifier.padding(12.dp)) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                AdBadge()
                Spacer(modifier = Modifier.width(8.dp))
                AdHeadline(nativeAd.headline)
            }
            Spacer(modifier = Modifier.height(8.dp))
            AdBody(nativeAd.body)
            Spacer(modifier = Modifier.height(12.dp))
            Row(verticalAlignment = Alignment.CenterVertically) {
                AdIcon(nativeAd)
                Spacer(modifier = Modifier.weight(1f))
                AdCallToAction(nativeAd.callToAction)
            }
        }
    }
}

@Composable
fun BottomImageLayout(nativeAd: NativeAd, mediaView: MediaView) {
    Column {
        Column(modifier = Modifier.padding(12.dp)) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                AdBadge()
                Spacer(modifier = Modifier.width(8.dp))
                AdHeadline(nativeAd.headline)
            }
            Spacer(modifier = Modifier.height(4.dp))
            AdBody(nativeAd.body)
            Spacer(modifier = Modifier.height(12.dp))
            Row(verticalAlignment = Alignment.CenterVertically) {
                AdIcon(nativeAd)
                Spacer(modifier = Modifier.weight(1f))
                AdCallToAction(nativeAd.callToAction)
            }
        }
        nativeAd.mediaContent?.let { mc ->
            AndroidView(
                modifier = Modifier.fillMaxWidth().height(180.dp),
                factory = { mediaView },
                update = { it.mediaContent = mc }
            )
        }
    }
}

@Composable
fun LeftImageLayout(nativeAd: NativeAd, mediaView: MediaView) {
    Row(modifier = Modifier.padding(12.dp)) {
        nativeAd.mediaContent?.let { mc ->
            AndroidView(
                modifier = Modifier
                    .size(128.dp)
                    .clip(RoundedCornerShape(8.dp)),
                factory = { mediaView },
                update = { it.mediaContent = mc }
            )
            Spacer(modifier = Modifier.width(12.dp))
        }
        Column(modifier = Modifier.weight(1f)) {
            Row(verticalAlignment = Alignment.Top) {
                AdBadge()
                Spacer(modifier = Modifier.width(8.dp))
                AdHeadline(nativeAd.headline)
            }
            Spacer(modifier = Modifier.height(8.dp))
            Row(verticalAlignment = Alignment.CenterVertically) {
                AdIcon(nativeAd)
                Spacer(modifier = Modifier.width(4.dp))
                AdBody(nativeAd.body)
            }
            Spacer(modifier = Modifier.weight(1f))
            Box(modifier = Modifier.fillMaxWidth(), contentAlignment = Alignment.BottomEnd) {
                AdCallToAction(nativeAd.callToAction)
            }
        }
    }
}

@Composable
fun RightImageLayout(nativeAd: NativeAd, mediaView: MediaView) {
    Row(modifier = Modifier.padding(12.dp)) {
        Column(modifier = Modifier.weight(1f)) {
            AdHeadline(nativeAd.headline)
            Spacer(modifier = Modifier.height(12.dp))
            Row(verticalAlignment = Alignment.Top) {
                AdIcon(nativeAd)
                Spacer(modifier = Modifier.width(8.dp))
                AdBody(nativeAd.body)
            }
            Spacer(modifier = Modifier.weight(1f))
            Row(verticalAlignment = Alignment.CenterVertically) {
                AdCallToAction(nativeAd.callToAction)
                Spacer(modifier = Modifier.weight(1f))
                AdBadge()
            }
        }
        nativeAd.mediaContent?.let { mc ->
            Spacer(modifier = Modifier.width(12.dp))
            AndroidView(
                modifier = Modifier
                    .size(128.dp)
                    .clip(RoundedCornerShape(8.dp)),
                factory = { mediaView },
                update = { it.mediaContent = mc }
            )
        }
    }
}