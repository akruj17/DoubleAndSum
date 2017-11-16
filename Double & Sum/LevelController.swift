//
//  LevelController.swift
//  Double & Sum
//
//  Created by Arjun Kunjilwar on 6/12/17.
//  Copyright © 2017 Edumacation!. All rights reserved.
//

import UIKit
import GoogleMobileAds

struct Stack<Element> {
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
    mutating func empty() {
        items.removeAll()
    }
}

class LevelController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, GADBannerViewDelegate {

    @IBOutlet weak var levelGrid: UICollectionView!
    @IBOutlet weak var requiredScore: UILabel!
    @IBOutlet weak var currentScore: UILabel!
    @IBOutlet weak var popUp: PopUpWindow!
    @IBAction func returnToLevelSelector(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func undoPressed(_ sender: Any) {
        undoMove()
    }

    @IBAction func restartLevelPressed(_ sender: Any) {
        for cell in levelGrid.visibleCells as! [LevelCell] {
            if (levelGrid.indexPath(for: cell))?.row != 0 {
                cell.updateTileValue(value: 0)
            }
            
            currentScoreValue = 1
            updateScoreLabel()
            
            tileMatrix = [[Int]](repeating: [Int](repeating: 0, count: 5), count: 5)
            tileMatrix[0][0] = 1
            positions.empty()
        }
        
        if (sender as! UIButton).tag == 1 {
            popUp.isHidden = true
            levelGrid.isUserInteractionEnabled = true
        }
        
    }
    
    var levelNumber: Int!
    let levelScores = [511, 33554431, 535, 765, 131071, 8191, 2047, 1103, 571]
    var tileMatrix = [[Int]](repeating: [Int](repeating: 0, count: 5), count: 5)
    var currentScoreValue = 1
    var positions = Stack<Int>()
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        levelGrid.dataSource = self
        levelGrid.delegate = self

        bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
        bannerView.frame = CGRect(x: 0, y: view.frame.size.height, width: view.frame.size.width, height: 60)
        self.view.addSubview(bannerView)
        bannerView.adUnitID = "ca-app-pub-2169995856607770/9766571444"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
        requiredScore.text = "\(levelScores[levelNumber - 1])"
        
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
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = levelGrid.dequeueReusableCell(withReuseIdentifier: "singleLevelCell", for: indexPath) as? LevelCell {
            if levelNumber == 2 && indexPath.row == 12 {
                cell.backgroundColor = UIColor(red: 1, green: 102/255, blue: 102/255, alpha: 1)
            }
            else if levelNumber == 7 && indexPath.row == 20 {
                cell.backgroundColor = UIColor(red: 1, green: 102/255, blue: 102/255, alpha: 1)
            }
            else if indexPath.row == 24 && levelNumber != 7 && levelNumber != 2 {
                cell.backgroundColor = UIColor(red: 1, green: 102/255, blue: 102/255, alpha: 1)
            }
            else {
                cell.backgroundColor = UIColor(red: 233/255, green: 253/255, blue: 245/255, alpha: 1)
            }
           
            if indexPath.row == 0 {
                cell.setStartingTile()
                tileMatrix[0][0] = 1
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.width / 5)
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let position = indexPath.row
        if position != 0 && (tileMatrix[position / 5][position % 5] == 0) {
            let multiplier = calculateTileValue(position: position)
            if multiplier != 0 {
                let value = 2 * multiplier
                tileMatrix[position / 5][position % 5] = value
                currentScoreValue += value
                if let cell = collectionView.cellForItem(at: indexPath) as? LevelCell {
                    cell.updateTileValue(value: value)
                    positions.push(indexPath.row)
                }
                updateScoreLabel()
            }
        }
        if (levelNumber != 2 && levelNumber != 7 && position == 24) || (levelNumber == 2 && position == 12) || (levelNumber == 7 && position == 20) {
            if let multiplier = calculateTileValue(position: position) as? Int, multiplier != 0 {
                if requiredScore.text == currentScore.text {
                    popUp.didWin(true)
                    levelStatuses[levelNumber-1] = true
                    
                    let preferences = UserDefaults.standard
                    let key = "levelStatuses"
                    preferences.set(levelStatuses, forKey: key)
                    preferences.synchronize()
                    
                } else {
                    popUp.didWin(false)
                }
                    popUp.isHidden = false
                levelGrid.isUserInteractionEnabled = false
            }
        }
    }
    
    func updateScoreLabel() {
        currentScore.text = "\(currentScoreValue)"
    }
    
    func calculateTileValue(position: Int) -> Int {
        let row = position / 5
        let col = position % 5
        var largestMultiplier = 0
        
        if col != 0 {
            largestMultiplier = tileMatrix[row][col-1]
        }
        if col != 4 {
            largestMultiplier = max(largestMultiplier, tileMatrix[row][col+1])
        }
        if row != 0 {
            largestMultiplier = max(largestMultiplier, tileMatrix[row-1][col])
        }
        if row != 4 {
            largestMultiplier = max(largestMultiplier, tileMatrix[row+1][col])
        }
        
        return largestMultiplier
    }
    
    func undoMove() {
        if positions.items.count > 0 {
            let lastPosition = positions.pop()
            let indexPath = IndexPath(row: lastPosition, section: 0)
            if let cell = levelGrid.cellForItem(at: indexPath) as? LevelCell {
                currentScoreValue -= cell.getTileValue()
                updateScoreLabel()
                
                cell.updateTileValue(value: 0)
                tileMatrix[lastPosition/5][lastPosition%5] = 0
            }
        }
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        showBanner(bannerView)
    }
    
    func showBanner(_ banner: UIView) {
        banner.frame = CGRect(x: view.frame.size.width/2 - banner.frame.size.width/2, y: view.frame.size.height - banner.frame.size.height, width: banner.frame.size.width, height: banner.frame.size.height)
    }

    

}
