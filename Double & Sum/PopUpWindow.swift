//
//  PopUpWindow.swift
//  Double & Sum
//
//  Created by Arjun Kunjilwar on 6/14/17.
//  Copyright © 2017 Edumacation!. All rights reserved.
//

import UIKit

class PopUpWindow: UIView {

    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var againButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    func didWin(_ option: Bool) {
        if option {
            messageLbl.text = "Great job!"
            againButton.setTitle("Play Again", for: .normal)
        } else {
            messageLbl.text = "Don't give up"
            againButton.setTitle("Try Again", for: .normal)
        }
    }

}
