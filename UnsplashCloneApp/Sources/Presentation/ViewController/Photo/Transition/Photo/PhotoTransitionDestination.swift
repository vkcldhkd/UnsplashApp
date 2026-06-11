//
//  PhotoTransitionDestination.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 6/7/26.
//

import UIKit

protocol PhotoTransitionDestination: AnyObject {
    var transitionDestinationImageView: UIImageView? { get }
    func prepareTransitionLayout()
}
