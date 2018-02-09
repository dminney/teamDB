//
//  Designable_Button.swift
//  Team_stopWatch
//
//  Created by Dave Minney on 12/20/17.
//  Copyright © 2017 dminn. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableButton: UIButton{
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.masksToBounds = true
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor : UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
}
