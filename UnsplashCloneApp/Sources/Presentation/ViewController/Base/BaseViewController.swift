//
//  BaseViewController.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/5/25.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    
    // MARK: Properties
    lazy private(set) var className: String = {
        return type(of: self).description().components(separatedBy: ".").last ?? ""
    }()
    private var backgroundColor: UIColor
    let navigationBarData: NavigationBarData
    // MARK: Rx
    var disposeBag = DisposeBag()
    
    
    // MARK: Layout Constraints
    private(set) var didSetupConstraints = false
    
    // MARK: - UI
    let loadingView: UIActivityIndicatorView = UIActivityIndicatorView()
    
    // MARK: Initializing
    init(
        title: String? = nil,
        backgroundColor: UIColor = UIColor.white,
        barBackgroundColor: UIColor = UIColor.white,
        prefersHidden: Bool? = nil,
        isTranslucent: Bool? = nil,
        hidesBottomBarWhenPushed: Bool = true
    ) {
        
        self.backgroundColor = backgroundColor
        self.navigationBarData = type(of: self).navigationBarDataFactory(
            barBackgroundColor: barBackgroundColor,
            prefersHidden: prefersHidden ?? false,
            isTranslucent: isTranslucent ?? true
        )
        super.init(nibName: nil, bundle: nil)
        self.title = title
        self.hidesBottomBarWhenPushed = hidesBottomBarWhenPushed
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    deinit {
        print("DEINIT: \(self.className)")
    }
    
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        self.view.setNeedsUpdateConstraints()
        self.view.backgroundColor = self.backgroundColor
    }
    
    override func updateViewConstraints() {
        if !self.didSetupConstraints {
            self.setupConstraints()
            self.didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(self.navigationBarData.prefersHidden, animated: true)
    }
    
    func setupConstraints() {
        // Override point
    }
}

private extension BaseViewController {
    private static func navigationBarDataFactory(
        barBackgroundColor: UIColor?,
        prefersHidden: Bool,
        isTranslucent: Bool
    ) -> NavigationBarData {
        return NavigationBarData(
            barBackgroundColor: barBackgroundColor ?? UIColor.white,
            prefersHidden: prefersHidden,
            isTranslucent: isTranslucent
        )
    }
}
extension BaseViewController {
    @objc func endEditing(){
        self.view.endEditing(true)
    }
    
    func loadingViewAddSubView() {
        self.view.addSubview(self.loadingView)
    }
    
//    func loadingViewConstraints(inset: CGFloat = 0) {
//        self.loadingView.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            if inset > 0 {
//                make.centerY.equalTo(UIScreen.main.bounds.midY - inset)
//            } else {
//                make.centerY.equalTo(UIScreen.main.bounds.midY)
//            }
//        }
//    }
}

