//
//  LevelSelectorCell.swift
//  Double & Sum
//
//  Created by Arjun Kunjilwar on 6/12/17.
//  Copyright © 2017 Edumacation!. All rights reserved.
//

import UIKit

class LevelSelectorCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailImg: UIImageView!
    @IBOutlet weak var levelNumber: UILabel!
    
    func configureCell(levelNum: Int, didComplete: Bool) {
        self.levelNumber.text = "\(levelNum)"
        if !didComplete {
            thumbnailImg.isHidden = true
        } else {
            thumbnailImg.isHidden = false
        }
    }
    
}
