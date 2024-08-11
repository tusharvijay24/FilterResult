//
//  UIView.swift
//  FilterResult-Mintoak
//
//  Created by Tushar on 10/08/24.
//

import Foundation
import UIKit

@IBDesignable
extension UIView {

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
