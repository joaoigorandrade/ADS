import Foundation
import GoogleMobileAds
import Combine
import UIKit

class NativeAdViewModel: NSObject, ObservableObject, AdLoaderDelegate, NativeAdLoaderDelegate, NativeAdDelegate {
    @Published var nativeAd: NativeAd?
    @Published var isLoading: Bool = false
    
    private var adLoader: AdLoader?
    
    let adUnitID = "ca-app-pub-3940256099942544/3986624511"
    
    func refreshAd() {
        isLoading = true
        nativeAd = nil
        
        var rootVC: UIViewController?
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let activeWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            rootVC = activeWindow.rootViewController
        }
        
        let options = NativeAdImageAdLoaderOptions()
        let mediaOptions = NativeAdMediaAdLoaderOptions()
        mediaOptions.mediaAspectRatio = .portrait
        adLoader = AdLoader(
            adUnitID: adUnitID,
            rootViewController: rootVC,
            adTypes: [.native],
            options: [mediaOptions, options]
        )
        
        adLoader?.delegate = self
        adLoader?.load(Request())
    }
    
    // MARK: - AdLoaderDelegate
    
    func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: Error) {
        print("Ad Loader failed with error: \(error.localizedDescription)")
        self.isLoading = false
    }
    
    // MARK: - NativeAdLoaderDelegate
    
    func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
        self.nativeAd = nativeAd
        self.nativeAd?.delegate = self
        self.isLoading = false
    }
    
    // MARK: - NativeAdDelegate
    
    func nativeAdDidRecordClick(_ nativeAd: NativeAd) {
        print("Native Ad recorded a click.")
    }
    
    func nativeAdDidRecordImpression(_ nativeAd: NativeAd) {
        print("Native Ad recorded an impression.")
    }
}
