//
//  LevelSelectorController.swift
//  Double & Sum
//
//  Created by Arjun Kunjilwar on 6/12/17.
//  Copyright © 2017 Edumacation!. All rights reserved.
//

import UIKit
import GoogleMobileAds

let NUM_LEVELS = 9
var levelStatuses = [Bool](repeating: false, count: 9)

class LevelSelectorController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, GADBannerViewDelegate {

    
    var bannerView: GADBannerView!
    @IBOutlet weak var levelSelector: UICollectionView!
    @IBAction func unwindHere(segue: UIStoryboardSegue) {
        levelSelector.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        levelSelector.delegate = self
        levelSelector.dataSource = self
        
        
        bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
        bannerView.frame = CGRect(x: 0, y: view.frame.size.height, width: view.frame.size.width, height: 60)
        self.view.addSubview(bannerView)
        bannerView.adUnitID = "ca-app-pub-2169995856607770/9766571444"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
//        adBannerView.load(GADRequest())
        
        let preferences = UserDefaults.standard
        let key = "levelStatuses"
        if preferences.object(forKey: key) == nil {
            preferences.set(levelStatuses, forKey: key)
            preferences.synchronize()
        } else {
            levelStatuses = preferences.array(forKey: key) as! [Bool]
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NUM_LEVELS
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (levelSelector.frame.width / 3) - 10
        
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let ask = levelStatuses
        if let cell = levelSelector.dequeueReusableCell(withReuseIdentifier: "LevelCell", for: indexPath) as? LevelSelectorCell {
            cell.configureCell(levelNum: indexPath.row + 1, didComplete: levelStatuses[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let size = (collectionView.frame.width / 3) - 10
        let spacing = ((collectionView.frame.height - (3 * size)) / 2) - 30
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toLevel", sender: indexPath.row + 1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLevel" {
            if let levelVC = segue.destination as? LevelController {
                levelVC.levelNumber = sender as? Int
            }
        }
    }
    
//    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
//        print("Banner loaded successfully")
//        adSpace.frame = bannerView.frame
//        adSpace = bannerView
//    }
//    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        showBanner(bannerView)
    }
    
    func showBanner(_ banner: UIView) {
        banner.frame = CGRect(x: view.frame.size.width/2 - banner.frame.size.width/2, y: view.frame.size.height - banner.frame.size.height, width: banner.frame.size.width, height: banner.frame.size.height)
    }

    
    
    

}
