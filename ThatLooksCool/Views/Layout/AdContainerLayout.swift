//
//  AdContainerView.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2021-04-25.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit
import TLCModel
import ClassicClient

import GoogleMobileAds

class AdContainerLayout: UIView {
    private let ENABLE_ADS = true
    
    private let adBanner: GADBannerView
        
    init(rootViewController: UIViewController, content: UIView) {
        adBanner = GADBannerView(adSize: kGADAdSizeBanner)
        adBanner.rootViewController = rootViewController
        
        super.init(frame: .zero)
        
        setup(withContent: content)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(withContent content: UIView) {
        self.backgroundColor = TLCStyle.primaryBackgroundColor
        
        let adContainer = ShadowView()
        
        adContainer.backgroundColor = TLCStyle.bannerViewColor
        
        adContainer.layer.cornerRadius = 15
        adContainer.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        #if DEBUG
        adBanner.adUnitID = TLCConfig.apiKey(.adMobTest)
        #else
        adBanner.adUnitID = TLCConfig.apiKey(.adMob)
        #endif
        
        adContainer.addSubview(adBanner)
        
        adContainer.addConstraint(NSLayoutConstraint.init(item: adBanner, attribute: .centerX, relatedBy: .equal, toItem: adContainer, attribute: .centerX, multiplier: 1, constant: 0))
        adContainer.constrainSubviewToBounds(adBanner, onEdges: [.top])
        adContainer.constrainSubviewToBounds(adBanner, onEdges: [.bottom], withInset: UIEdgeInsets(TLCStyle.safeArea.bottom))
                
        self.addSubview(content)
        self.addSubview(adContainer)
                
        self.constrainSubviewToBounds(content, onEdges: [.top, .left, .right])
        
        if !ENABLE_ADS {
            self.addConstraint(.init(item: content, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant:0))
        } else {
//            adBanner.delegate = self
            adBanner.load(GADRequest())
            adBanner.addConstraint(.init(item: adBanner, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50))
            
            self.constrainSubviewToBounds(adContainer, onEdges: [.bottom, .left, .right])
            self.addConstraint(.init(item: content, attribute: .bottom, relatedBy: .equal, toItem: adContainer, attribute: .top, multiplier: 1, constant:0))
        }
    }
}

//extension AdViewController: GADBannerViewDelegate {
//    func adViewDidReceiveAd(_ bannerView: GADBannerView) {

//        bannerArea.addSubview(bannerView)
//        bannerArea.constrainSubviewToBounds(bannerView)
//
//        bannerArea.addConstraint(.init(item: bannerView, attribute: .width, relatedBy: .equal, toItem: bannerArea, attribute: .width, multiplier: 1, constant: 0))
//        bannerArea.addConstraint(.init(item: bannerView, attribute: .height, relatedBy: .equal, toItem: bannerArea, attribute: .height, multiplier: 1, constant: 0))
//        bannerArea.addConstraint(.init(item: bannerView, attribute: .centerX, relatedBy: .equal, toItem: bannerArea, attribute: .centerX, multiplier: 1, constant: 0))
//
//        let yPosition = NSLayoutConstraint.init(item: bannerView, attribute: .centerY, relatedBy: .equal,
//                                                toItem: bannerArea, attribute: .centerY, multiplier: 1, constant: 0)
//        bannerArea.addConstraint(yPosition)
//
//        view.layoutIfNeeded()
//
//        UIView.animate(withDuration: 1, animations: { [weak self] in
//            yPosition.constant = 0
//            self?.view.layoutIfNeeded()
//        })
//    }
//}


