// TODO: Import google_mobile_ads
import google_mobile_ads
import UIKit

// TODO: Implement ListTileNativeAdFactory
class ListTileNativeAdFactory : FLTNativeAdFactory {

    func createNativeAd(_ nativeAd: GADNativeAd,
                        customOptions: [AnyHashable : Any]? = nil) -> GADNativeAdView? {
        let nibView = Bundle.main.loadNibNamed("ListTileNativeAdView", owner: nil, options: nil)!.first
        let nativeAdView = nibView as! GADNativeAdView
        
        
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = (nativeAdView.callToActionView as! UIButton).bounds
        gradientLayer.colors = [UIColor(red: 0.00, green: 0.75, blue: 1.00, alpha: 1.00).cgColor, UIColor(red: 0.20, green: 0.51, blue: 1.00, alpha: 1.00).cgColor]
        //(nativeAdView.callToActionView as! UIButton).buttonType
        (nativeAdView.headlineView as! UILabel).text = nativeAd.headline
        (nativeAdView.bodyView as! UILabel).text = nativeAd.body
        nativeAdView.bodyView!.isHidden = nativeAd.body == nil
        (nativeAdView.iconView as! UIImageView).layer.cornerRadius = (nativeAdView.iconView as! UIImageView).bounds.width / 2
        (nativeAdView.iconView as! UIImageView).layer.masksToBounds = true
        (nativeAdView.iconView as! UIImageView).image = nativeAd.icon?.image
        nativeAdView.iconView!.isHidden = nativeAd.icon == nil
        //add rating
        //(nativeAdView.starRatingView as! UIImageView).image  = nativeAd.starRating
        nativeAdView.callToActionView?.isUserInteractionEnabled = false
        
        let storeLabel = nativeAdView.storeView as! UILabel
        let priceLabel = nativeAdView.priceView as! UILabel
        //ratingView.rating = 3
        //storeLabel.text = "Play store"
        //priceLabel.text = "3000$"
       
        
        if nativeAd.price != nil {
            priceLabel.text = nativeAd.price
        } else {
            priceLabel.isHidden = true
        }
        
        if nativeAd.store != nil {
            storeLabel.text = nativeAd.store
        } else {
            storeLabel.isHidden = true
        }

        nativeAdView.nativeAd = nativeAd

        return nativeAdView
    }
}
