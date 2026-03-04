import SwiftUI
import GoogleMobileAds

enum NativeAdLayoutType {
    case topImage
    case bottomImage
    case leftImage
    case rightImage
}

struct NativeAdViewWrapper: UIViewRepresentable {
    var nativeAd: NativeAd?
    var layout: NativeAdLayoutType
    
    func makeUIView(context: Context) -> NativeAdView {
        let adView = NativeAdView(frame: .zero)
        
        let iconView = UIImageView()
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.contentMode = .scaleAspectFit
        iconView.layer.cornerRadius = 4
        iconView.clipsToBounds = true
        adView.addSubview(iconView)
        adView.iconView = iconView
        
        let headlineLabel = UILabel()
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        headlineLabel.font = UIFont.boldSystemFont(ofSize: 15)
        headlineLabel.textColor = .label
        headlineLabel.numberOfLines = 2
        adView.addSubview(headlineLabel)
        adView.headlineView = headlineLabel
        
        let bodyLabel = UILabel()
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.font = UIFont.systemFont(ofSize: 13)
        bodyLabel.textColor = .secondaryLabel
        bodyLabel.numberOfLines = 3
        adView.addSubview(bodyLabel)
        adView.bodyView = bodyLabel
        
        let mediaView = MediaView()
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        adView.addSubview(mediaView)
        adView.mediaView = mediaView
        
        let callToActionButton = UIButton(type: .system)
        callToActionButton.translatesAutoresizingMaskIntoConstraints = false
        callToActionButton.setTitleColor(.systemBlue, for: .normal)
        callToActionButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        callToActionButton.titleLabel?.textAlignment = .center
        callToActionButton.contentHorizontalAlignment = .center
        adView.addSubview(callToActionButton)
        adView.callToActionView = callToActionButton
        
        let adBadge = UILabel()
        adBadge.translatesAutoresizingMaskIntoConstraints = false
        adBadge.text = "Ad"
        adBadge.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        adBadge.textColor = .darkGray
        adBadge.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        adBadge.layer.borderWidth = 0.5
        adBadge.layer.borderColor = UIColor.lightGray.cgColor
        adBadge.layer.cornerRadius = 2
        adBadge.clipsToBounds = true
        adBadge.textAlignment = .center
        adView.addSubview(adBadge)
        
        adView.backgroundColor = UIColor.systemBackground
        adView.layer.borderWidth = 1
        adView.layer.borderColor = UIColor.systemGray4.cgColor
        adView.layer.cornerRadius = 16
        adView.clipsToBounds = true
        
        let adChoice = AdChoicesView()
        adChoice.translatesAutoresizingMaskIntoConstraints = false
        adView.addSubview(adChoice)
        adView.adChoicesView = adChoice
        
        let p: CGFloat = 12
        
        switch layout {
        case .topImage:
            mediaView.layer.cornerRadius = 0
                NSLayoutConstraint.activate([
                    // 1. MediaView at the top
                    mediaView.topAnchor.constraint(equalTo: adView.topAnchor),
                    mediaView.leadingAnchor.constraint(equalTo: adView.leadingAnchor),
                    mediaView.trailingAnchor.constraint(equalTo: adView.trailingAnchor),
                    mediaView.heightAnchor.constraint(equalToConstant: 180),

                    // 2. AdBadge - Moved below the MediaView
                    adBadge.topAnchor.constraint(equalTo: mediaView.bottomAnchor, constant: p),
                    adBadge.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: p),
                    adBadge.widthAnchor.constraint(equalToConstant: 24),
                    adBadge.heightAnchor.constraint(equalToConstant: 16),

                    // 3. AdChoices - Top right of the text area
                    adChoice.topAnchor.constraint(equalTo: mediaView.bottomAnchor, constant: p),
                    adChoice.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -p),
                    adChoice.heightAnchor.constraint(equalToConstant: 24),
                    adChoice.widthAnchor.constraint(equalToConstant: 24),

                    // 4. Headline - Slotted between Badge and Choices
                    headlineLabel.centerYAnchor.constraint(equalTo: adBadge.centerYAnchor),
                    headlineLabel.leadingAnchor.constraint(equalTo: adBadge.trailingAnchor, constant: 8),
                    headlineLabel.trailingAnchor.constraint(equalTo: adChoice.leadingAnchor, constant: -8),

                    // 5. Body below the Headline row
                    bodyLabel.topAnchor.constraint(equalTo: adBadge.bottomAnchor, constant: 8),
                    bodyLabel.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: p),
                    bodyLabel.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -p),

                    // 6. Icon and CTA at the very bottom
                    iconView.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: p),
                    iconView.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: p),
                    iconView.bottomAnchor.constraint(equalTo: adView.bottomAnchor, constant: -p),
                    iconView.widthAnchor.constraint(equalToConstant: 20),
                    iconView.heightAnchor.constraint(equalToConstant: 20),

                    callToActionButton.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
                    callToActionButton.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -p)
                ])
            
        case .bottomImage:
            mediaView.layer.cornerRadius = 0
            NSLayoutConstraint.activate([
                // 1. FIX OVERLAP: Move AdBadge to the top-left corner
                adBadge.topAnchor.constraint(equalTo: adView.topAnchor, constant: p),
                adBadge.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: p),
                adBadge.widthAnchor.constraint(equalToConstant: 24),
                adBadge.heightAnchor.constraint(equalToConstant: 16),
                
                // AdChoices remains at the top-right
                adChoice.topAnchor.constraint(equalTo: adView.topAnchor, constant: p),
                adChoice.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -p),
                adChoice.heightAnchor.constraint(equalToConstant: 24),
                adChoice.widthAnchor.constraint(equalToConstant: 24),
                
                // 2. FIX OVERLAP: Anchor headline strictly between the Ad Badge and AdChoices
                headlineLabel.topAnchor.constraint(equalTo: adView.topAnchor, constant: p),
                headlineLabel.leadingAnchor.constraint(equalTo: adBadge.trailingAnchor, constant: 8),
                headlineLabel.trailingAnchor.constraint(equalTo: adChoice.leadingAnchor, constant: -8),
                
                bodyLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 4),
                bodyLabel.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: p),
                bodyLabel.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -p),
                
                iconView.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: p),
                iconView.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: p),
                iconView.widthAnchor.constraint(equalToConstant: 20),
                iconView.heightAnchor.constraint(equalToConstant: 20),
                
                callToActionButton.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
                callToActionButton.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -p),
                
                // MediaView remains at the bottom, but no longer fights the AdBadge
                mediaView.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: p),
                mediaView.leadingAnchor.constraint(equalTo: adView.leadingAnchor),
                mediaView.trailingAnchor.constraint(equalTo: adView.trailingAnchor),
                mediaView.bottomAnchor.constraint(equalTo: adView.bottomAnchor),
                mediaView.heightAnchor.constraint(equalToConstant: 180)
            ])
            
        case .leftImage:
            mediaView.layer.cornerRadius = 8
            
            NSLayoutConstraint.activate([
                mediaView.topAnchor.constraint(equalTo: adView.topAnchor),
                mediaView.leadingAnchor.constraint(equalTo: adView.leadingAnchor),
                mediaView.widthAnchor.constraint(equalToConstant: 128),
                mediaView.heightAnchor.constraint(equalToConstant: 128),
                // 3. FIX OUT OF BOUNDS: Use <= so the container isn't forced to exactly 128pt height
                mediaView.bottomAnchor.constraint(lessThanOrEqualTo: adView.bottomAnchor),
                
                adChoice.topAnchor.constraint(equalTo: adView.topAnchor, constant: p),
                adChoice.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -p),
                adChoice.widthAnchor.constraint(equalToConstant: 20),
                adChoice.heightAnchor.constraint(equalToConstant: 20),
                
                // 4. FIX OVERLAP: Move Ad Badge to the top-left of the text column, out of the image
                adBadge.topAnchor.constraint(equalTo: adView.topAnchor, constant: p),
                adBadge.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: p),
                adBadge.widthAnchor.constraint(equalToConstant: 24),
                adBadge.heightAnchor.constraint(equalToConstant: 16),
                
                // Headline trails the new Ad Badge position
                headlineLabel.topAnchor.constraint(equalTo: adView.topAnchor, constant: p),
                headlineLabel.leadingAnchor.constraint(equalTo: mediaView.trailingAnchor, constant: 8),
                headlineLabel.trailingAnchor.constraint(equalTo: adChoice.leadingAnchor, constant: -p),
                
                iconView.topAnchor.constraint(greaterThanOrEqualTo: headlineLabel.bottomAnchor, constant: 8),
                iconView.leadingAnchor.constraint(equalTo: mediaView.trailingAnchor, constant: p),
                iconView.widthAnchor.constraint(equalToConstant: 24),
                iconView.heightAnchor.constraint(equalToConstant: 24),
                
                bodyLabel.topAnchor.constraint(greaterThanOrEqualTo: headlineLabel.bottomAnchor, constant: 8),
                bodyLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
                bodyLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 4),
                bodyLabel.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -p),
                
                callToActionButton.leadingAnchor.constraint(equalTo: mediaView.trailingAnchor, constant: p),
                callToActionButton.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -p),
                // This equalTo constraint serves to stretch the adView height if the text column is tall
                callToActionButton.bottomAnchor.constraint(equalTo: adView.bottomAnchor, constant: -p),
                callToActionButton.heightAnchor.constraint(equalToConstant: 24)
            ])
            
        case .rightImage:
            mediaView.layer.cornerRadius = 8
            let adChoicesSize: CGFloat = 20

            NSLayoutConstraint.activate([
                // --- MediaView (Right Side) ---
                mediaView.topAnchor.constraint(equalTo: adView.topAnchor),
                mediaView.trailingAnchor.constraint(equalTo: adView.trailingAnchor),
                mediaView.widthAnchor.constraint(equalToConstant: 128),
                mediaView.heightAnchor.constraint(equalToConstant: 128),
                // Removed bottomAnchor to adView to prevent conflicts with fixed height
                
                // --- AdChoices (Top Left) ---
                adChoice.topAnchor.constraint(equalTo: adView.topAnchor, constant: p),
                adChoice.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: p),
                adChoice.widthAnchor.constraint(equalToConstant: adChoicesSize),
                adChoice.heightAnchor.constraint(equalToConstant: adChoicesSize),

                // --- Headline (Next to AdChoices) ---
                headlineLabel.centerYAnchor.constraint(equalTo: adChoice.centerYAnchor),
                headlineLabel.leadingAnchor.constraint(equalTo: adChoice.trailingAnchor, constant: 4),
                headlineLabel.trailingAnchor.constraint(equalTo: mediaView.leadingAnchor, constant: -p),
                
                // --- Icon & Body (Middle Row) ---
                // Changed to a concrete top anchor to keep it from floating
                iconView.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 12),
                iconView.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: p),
                iconView.widthAnchor.constraint(equalToConstant: 24),
                iconView.heightAnchor.constraint(equalToConstant: 24),
                
                bodyLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
                bodyLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
                bodyLabel.trailingAnchor.constraint(equalTo: mediaView.leadingAnchor, constant: -p),
                
                // --- Call To Action (Bottom Left) ---
                callToActionButton.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: p),
                callToActionButton.trailingAnchor.constraint(equalTo: mediaView.leadingAnchor, constant: -p),
                callToActionButton.bottomAnchor.constraint(equalTo: adView.bottomAnchor, constant: -p),
                callToActionButton.heightAnchor.constraint(equalToConstant: 32), // Slightly taller for better tap target
                
                // --- AdBadge (Usually placed on top of the MediaView or in a corner) ---
                adBadge.bottomAnchor.constraint(equalTo: mediaView.bottomAnchor, constant: -4),
                adBadge.trailingAnchor.constraint(equalTo: mediaView.trailingAnchor, constant: -4),
                adBadge.widthAnchor.constraint(equalToConstant: 24),
                adBadge.heightAnchor.constraint(equalToConstant: 16)
            ])
        }
        
        return adView
    }
    
    func updateUIView(_ uiView: NativeAdView, context: Context) {
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
        
        
        if let bodyLabel = uiView.bodyView as? UILabel {
            bodyLabel.text = customAd.body
        }
        
        if let ctaBtn = uiView.callToActionView as? UIButton {
            ctaBtn.setTitle(customAd.callToAction, for: .normal)
            ctaBtn.isHidden = customAd.callToAction == nil
        }
        
        if let mediaV = uiView.mediaView {
            mediaV.mediaContent = customAd.mediaContent
        }
        
        uiView.nativeAd = nativeAd
    }
}
