//
//  DesignableLabel.swift
//  Team_stopWatch
//
//  Created by Dave Minney on 12/17/17.
//  Copyright © 2017 dminn. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableLabel: UILabel {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.masksToBounds = true
            layer.cornerRadius = cornerRadius
        }
    }
    
}
