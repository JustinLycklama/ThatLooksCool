//
//  AdViewController.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-09-22.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import ClassicClient

import GoogleMobileAds

class AdViewController: UIViewController {

    public let contentView = UIView()
    private let bannerView = UIView()
    
    private let ENABLE_ADS = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        edgesForExtendedLayout = []
        self.view.backgroundColor = TLCStyle.primaryBackgroundColor
        
        // Setup Ad Banner
        let adBanner = GADBannerView(adSize: kGADAdSizeBanner)
     
        #if DEBUG
        adBanner.adUnitID = TLCConfig.apiKey(.adMobTest)
        #else
        adBanner.adUnitID = TLCConfig.apiKey(.adMob)
        #endif
        
        adBanner.rootViewController = self
        adBanner.load(GADRequest())
        
        bannerView.backgroundColor = .white
        
        bannerView.addSubview(adBanner)

        bannerView.addConstraint(NSLayoutConstraint.init(item: adBanner, attribute: .centerX, relatedBy: .equal, toItem: bannerView, attribute: .centerX, multiplier: 1, constant: 0))
        bannerView.constrainSubviewToBounds(adBanner, onEdges: [.top, .bottom], withInset: UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0))
        
        self.view.addSubview(contentView)
        self.view.addSubview(bannerView)

        contentView.backgroundColor = .clear
                
        self.view.constrainSubviewToBounds(contentView, onEdges: [.top, .left, .right], withInset: UIEdgeInsets(TLCStyle.topLevelMargin))
        
        if !ENABLE_ADS {
            self.view.addConstraint(NSLayoutConstraint.init(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -(TLCStyle.topLevelMargin + TLCStyle.topLevelPadding)))
        } else {
            self.view.constrainSubviewToBounds(bannerView, onEdges: [.bottom, .left, .right])
            
            self.view.addConstraint(NSLayoutConstraint.init(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: adBanner, attribute: .top, multiplier: 1, constant: -(TLCStyle.topLevelMargin + TLCStyle.topLevelPadding)))
        }
    }
}
