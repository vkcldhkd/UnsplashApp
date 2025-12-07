//
//  ShadowContainerView.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/7/25.
//
import UIKit

final class ShadowContainerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupShadow()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupShadow()
    }
}

private extension ShadowContainerView {
    func setupShadow() {
        backgroundColor = .clear
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.masksToBounds = false
    }
}
