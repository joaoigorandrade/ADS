import SwiftUI
import GoogleMobileAds

struct NativeAdViewWrapper: UIViewRepresentable {
    var nativeAd: NativeAd?
    
    func makeUIView(context: Context) -> NativeAdView {
        let adView = NativeAdView(frame: .zero)
        
        // 1. Create Subviews for the App Install / Content structure
        
        let iconView = UIImageView()
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.contentMode = .scaleAspectFit
        iconView.layer.cornerRadius = 8
        iconView.clipsToBounds = true
        adView.addSubview(iconView)
        adView.iconView = iconView
        
        let headlineLabel = UILabel()
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        headlineLabel.font = UIFont.boldSystemFont(ofSize: 16)
        headlineLabel.textColor = .label
        adView.addSubview(headlineLabel)
        adView.headlineView = headlineLabel
        
        let advertiserLabel = UILabel()
        advertiserLabel.translatesAutoresizingMaskIntoConstraints = false
        advertiserLabel.font = UIFont.systemFont(ofSize: 12)
        advertiserLabel.textColor = .secondaryLabel
        adView.addSubview(advertiserLabel)
        adView.advertiserView = advertiserLabel
        
        let bodyLabel = UILabel()
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.font = UIFont.systemFont(ofSize: 14)
        bodyLabel.textColor = .secondaryLabel
        bodyLabel.numberOfLines = 2
        adView.addSubview(bodyLabel)
        adView.bodyView = bodyLabel
        
        let mediaView = MediaView()
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        mediaView.layer.cornerRadius = 8
        mediaView.clipsToBounds = true
        adView.addSubview(mediaView)
        adView.mediaView = mediaView
        
        let callToActionButton = UIButton(type: .system)
        callToActionButton.translatesAutoresizingMaskIntoConstraints = false
        callToActionButton.backgroundColor = .systemBlue
        callToActionButton.setTitleColor(.white, for: .normal)
        callToActionButton.layer.cornerRadius = 8
        callToActionButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        adView.addSubview(callToActionButton)
        adView.callToActionView = callToActionButton
        
        // 2. Setup Auto Layout constraints
        NSLayoutConstraint.activate([
            // Icon View Constraints
            iconView.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: 0),
            iconView.topAnchor.constraint(equalTo: adView.topAnchor, constant: 16),
            iconView.widthAnchor.constraint(equalToConstant: 40),
            iconView.heightAnchor.constraint(equalToConstant: 40),
            
            // Headline Label Constraints
            headlineLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            headlineLabel.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -16),
            headlineLabel.topAnchor.constraint(equalTo: adView.topAnchor, constant: 16),
            
            // Advertiser Label Constraints
            advertiserLabel.leadingAnchor.constraint(equalTo: headlineLabel.leadingAnchor),
            advertiserLabel.trailingAnchor.constraint(equalTo: headlineLabel.trailingAnchor),
            advertiserLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 4),
            
            // Body Label Constraints
            bodyLabel.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: 16),
            bodyLabel.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -16),
            bodyLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 12),
            
            // Media View Constraints
            mediaView.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: 16),
            mediaView.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -16),
            mediaView.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 12),
            mediaView.heightAnchor.constraint(equalToConstant: 120),
            
            // Call to Action Button Constraints
            callToActionButton.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: 16),
            callToActionButton.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -16),
            callToActionButton.topAnchor.constraint(equalTo: mediaView.bottomAnchor, constant: 16),
            callToActionButton.heightAnchor.constraint(equalToConstant: 44),
            callToActionButton.bottomAnchor.constraint(equalTo: adView.bottomAnchor, constant: -16)
        ])
        
        // Customizing the ad view look
        adView.backgroundColor = UIColor.systemBackground
        adView.layer.cornerRadius = 20
        adView.layer.shadowColor = UIColor.black.cgColor
        adView.layer.shadowOpacity = 0.1
        adView.layer.shadowOffset = CGSize(width: 0, height: 4)
        adView.layer.shadowRadius = 8
        
        return adView
    }
    
    func updateUIView(_ uiView: NativeAdView, context: Context) {
        uiView.nativeAd = nativeAd
        
        guard let customAd = nativeAd else {
            uiView.isHidden = true
            return
        }
        
        uiView.isHidden = false
        
        if let iconLabel = uiView.iconView as? UIImageView {
            iconLabel.image = customAd.icon?.image
            iconLabel.isHidden = customAd.icon == nil
        }
        
        if let headlineLabel = uiView.headlineView as? UILabel {
            headlineLabel.text = customAd.headline
            headlineLabel.isHidden = customAd.headline == nil
        }
        
        if let advLabel = uiView.advertiserView as? UILabel {
            advLabel.text = customAd.advertiser
            advLabel.isHidden = customAd.advertiser == nil
        }
        
        if let bodyLabel = uiView.bodyView as? UILabel {
            bodyLabel.text = customAd.body
            bodyLabel.isHidden = customAd.body == nil
        }
        
        if let ctaBtn = uiView.callToActionView as? UIButton {
            ctaBtn.setTitle(customAd.callToAction, for: .normal)
            ctaBtn.isHidden = customAd.callToAction == nil
        }
        
        if let mediaV = uiView.mediaView {
            mediaV.mediaContent = customAd.mediaContent
        }
    }
}
