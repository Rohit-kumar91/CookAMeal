//
//  UILabelX.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 27/10/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit

@IBDesignable
class UILabelX: UILabel {

    
        @IBInspectable var topInset: CGFloat = 0.0
        @IBInspectable var leftInset: CGFloat = 0.0
        @IBInspectable var bottomInset: CGFloat = 0.0
        @IBInspectable var rightInset: CGFloat = 0.0
        
        var insets: UIEdgeInsets {
            get {
                return UIEdgeInsetsMake(topInset, leftInset, bottomInset, rightInset)
            }
            set {
                topInset = newValue.top
                leftInset = newValue.left
                bottomInset = newValue.bottom
                rightInset = newValue.right
            }
        }
        
        override func drawText(in rect: CGRect) {
            super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
        }
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            var adjSize = super.sizeThatFits(size)
            adjSize.width += leftInset + rightInset
            adjSize.height += topInset + bottomInset
            
            return adjSize
        }
        
        override var intrinsicContentSize: CGSize {
            var contentSize = super.intrinsicContentSize
            contentSize.width += leftInset + rightInset
            contentSize.height += topInset + bottomInset
            
            return contentSize
        }
   


}
