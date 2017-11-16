//
//  LevelCell.swift
//  Double & Sum
//
//  Created by Arjun Kunjilwar on 6/12/17.
//  Copyright © 2017 Edumacation!. All rights reserved.
//

import UIKit

class LevelCell: UICollectionViewCell {
    
   
    @IBOutlet weak var tileValueLabel: UILabel!
    var tileValue: Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
    }
    
    func setStartingTile()
    {
        tileValueLabel.text = "1"
    }
    
    func getTileValue() -> Int
    {
        return tileValue
    }
    
    func updateTileValue(value: Int) {
        if value == 0 {
            tileValueLabel.text = ""
            tileValue = 0
        } else {
            tileValueLabel.text = "\(value)"
            tileValue = value
        }
    
    }
    
}
