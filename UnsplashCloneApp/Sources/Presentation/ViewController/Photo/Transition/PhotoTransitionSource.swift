//
//  PhotoTransitionSource.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 6/7/26.
//

import UIKit

protocol PhotoTransitionSource: AnyObject {
    var transitionSourceImageView: UIImageView? { get }
    var transitionSourceFrame: CGRect? { get }
}
