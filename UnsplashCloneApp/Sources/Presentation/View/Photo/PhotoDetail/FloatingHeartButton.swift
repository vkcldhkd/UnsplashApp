//
//  FloatingHeartButton.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/7/25.
//

import UIKit
import RxSwift

final class FloatingHeartButton: UIButton {

    private let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
    private var currentIsLiked: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.cornerRadius = bounds.width / 2
    }
}

extension FloatingHeartButton {
    func setLiked(_ liked: Bool, animated: Bool) {
        guard liked != self.currentIsLiked else { return }
        self.currentIsLiked = liked
        self.updateAppearance(animated: animated)
    }
}


private extension FloatingHeartButton {
    // MARK: - setupUI
    func setupUI() {
        backgroundColor = .systemBackground

        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 12,
            leading: 12,
            bottom: 12,
            trailing: 12
        )
        self.configuration = config
        self.updateAppearance(animated: false)
    }
    
    func updateAppearance(animated: Bool) {
        let symbolName = currentIsLiked ? "heart.fill" : "heart"
        let image = UIImage(systemName: symbolName, withConfiguration: symbolConfig)
        let tint: UIColor = currentIsLiked ? .systemRed : .systemGray2

        let applyState: () -> Void = { [weak self] in
            guard let self = self else { return }
            if #available(iOS 15.0, *) {
                var config = self.configuration ?? UIButton.Configuration.plain()
                config.image = image
                config.baseForegroundColor = tint
                self.configuration = config
            } else {
                self.setImage(image, for: .normal)
                self.tintColor = tint
            }
        }

        guard animated else {
            applyState()
            return
        }

        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()

        UIView.animate(withDuration: 0.12, animations: {
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { _ in
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 3,
                options: .curveEaseOut,
                animations: {
                    applyState()
                    self.transform = .identity
                },
                completion: nil
            )
        })
    }
}


extension Reactive where Base: FloatingHeartButton {
    var isLiked: Binder<Bool> {
        Binder(base) { button, liked in
            button.setLiked(liked, animated: true)
        }
    }
}
