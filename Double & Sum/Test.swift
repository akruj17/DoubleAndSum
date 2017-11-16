//
//  Test.swift
//  Double & Sum
//
//  Created by Arjun Kunjilwar on 6/15/17.
//  Copyright © 2017 Edumacation!. All rights reserved.
//

import UIKit
import GoogleMobileAds

class Test: UIViewController, GADBannerViewDelegate {

    var bannerView: GADBannerView!
    
    @IBOutlet weak var adSpace: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
        bannerView.frame = CGRect(x: 0, y: view.frame.size.height, width: view.frame.size.width, height: 60)
        self.view.addSubview(bannerView)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        bannerView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        showBanner(bannerView)
    }
    
    func showBanner(_ banner: UIView) {
        banner.frame = CGRect(x: view.frame.size.width/2 - banner.frame.size.width/2, y: view.frame.size.height - banner.frame.size.height, width: banner.frame.size.width, height: banner.frame.size.height)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
