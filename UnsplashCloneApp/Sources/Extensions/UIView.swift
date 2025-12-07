//
//  UIView.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/7/25.
//

import UIKit

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
