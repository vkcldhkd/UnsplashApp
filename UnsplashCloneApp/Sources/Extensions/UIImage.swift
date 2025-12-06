//
//  UIImage.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/5/25.
//

import UIKit

extension UIImage {
    var heartImage: UIImage? {
        return UIImage(systemName: "heart.fill")?.withTintColor(.red, renderingMode: .alwaysTemplate)
    }
}
