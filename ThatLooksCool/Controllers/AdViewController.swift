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

    private static let Test_Ad_Unit_Id = "ca-app-pub-3940256099942544/2934735716"

    public let contentView = UIView()
    private let bannerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        edgesForExtendedLayout = []
        self.view.backgroundColor = TLCStyle.primaryBackgroundColor
        
        // Setup Ad Banner
        let adBanner = GADBannerView(adSize: kGADAdSizeBanner)

        
        adBanner.adUnitID = AdViewController.Test_Ad_Unit_Id
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
        self.view.constrainSubviewToBounds(bannerView, onEdges: [.bottom, .left, .right])

        self.view.addConstraint(NSLayoutConstraint.init(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: adBanner, attribute: .top, multiplier: 1, constant: -(TLCStyle.topLevelMargin + TLCStyle.topLevelPadding)))
    }
}
