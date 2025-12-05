//
//  Untitled.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/5/25.
//

import UIKit
import SafariServices

class BaseNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationbar()
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let firstViewController = self.viewControllers.first,
              firstViewController is SFSafariViewController else { return }
        self.setNavigationBarHidden(true, animated: true)
    }
    
    override var shouldAutorotate: Bool{
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let style = super.preferredStatusBarStyle
        return style
    }
}

private extension BaseNavigationController{
    func setNavigationbar(){
        self.modalPresentationStyle = .overFullScreen
    }
}


// MARK: Gesture Recognizer Delegate
extension BaseNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // Ignore interactive pop gesture when there is only one view controller on the navigation stack
        if viewControllers.count <= 1 {
            return false
        } else {
            if let window = UIApplication.shared.delegate?.window {
                guard var rootViewController = window?.rootViewController else { return false }
                if rootViewController is BaseNavigationController {
                    rootViewController = (rootViewController as! UINavigationController).visibleViewController!
                }
            }
        }
        return true
    }    
}

