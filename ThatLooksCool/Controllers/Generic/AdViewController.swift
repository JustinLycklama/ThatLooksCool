//
//  AdViewController.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-09-22.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

import TLCModel
import GoogleMobileAds

import ClassicClient

class AdViewController: UIViewController {

    public let contentArea = UIView()
//    private let bannerArea = UIView()
    
    private lazy var bannerView: UIView = {
//        let adBanner = GADBannerView(adSize: kGADAdSizeBanner)
//
//        #if DEBUG
//        adBanner.adUnitID = TLCConfig.apiKey(.adMobTest)
//        #else
//        adBanner.adUnitID = TLCConfig.apiKey(.adMob)
//        #endif
//
//        adBanner.rootViewController = self
//        adBanner.load(GADRequest())
        
        let container = ShadowView()
        
        container.backgroundColor = TLCStyle.bannerViewColor
        
        container.layer.cornerRadius = 15
        container.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        container.addSubview(adBanner)
        
        container.addConstraint(NSLayoutConstraint.init(item: adBanner, attribute: .centerX, relatedBy: .equal, toItem: container, attribute: .centerX, multiplier: 1, constant: 0))
        container.constrainSubviewToBounds(adBanner, onEdges: [.top], withInset: UIEdgeInsets(0))
        
        container.constrainSubviewToBounds(adBanner, onEdges: [.bottom], withInset: UIEdgeInsets(TLCStyle.safeArea.bottom))
        
        return container
    }()
    
    private lazy var adBanner: GADBannerView = {
        let adBanner = GADBannerView(adSize: kGADAdSizeBanner)
     
        #if DEBUG
        adBanner.adUnitID = TLCConfig.apiKey(.adMobTest)
        #else
        adBanner.adUnitID = TLCConfig.apiKey(.adMob)
        #endif
        
        adBanner.rootViewController = self
        
        return adBanner
    }()
    
    private let ENABLE_ADS = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        edgesForExtendedLayout = []
        
        contentArea.backgroundColor = .clear
//        bannerArea.backgroundColor = .clear
        
        self.view.addSubview(contentArea)
        self.view.addSubview(bannerView)
                
        self.view.constrainSubviewToBounds(contentArea, onEdges: [.top, .left, .right])
        
        if !ENABLE_ADS {
            self.view.addConstraint(.init(item: contentArea, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant:0))
        } else {
            // Setup Banner
//            adBanner.delegate = self
            adBanner.load(GADRequest())
            adBanner.addConstraint(.init(item: adBanner, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50))
            
            self.view.constrainSubviewToBounds(bannerView, onEdges: [.bottom, .left, .right])
            self.view.addConstraint(.init(item: contentArea, attribute: .bottom, relatedBy: .equal, toItem: bannerView, attribute: .top, multiplier: 1, constant:0))
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
