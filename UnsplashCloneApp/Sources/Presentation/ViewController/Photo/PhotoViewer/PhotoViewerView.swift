//
//  PhotoViewerView.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 6/11/26.
//

import UIKit
import Then
import SnapKit

final class PhotoViewerView: UIView {

    let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.bouncesZoom = true
        $0.backgroundColor = .black
        $0.decelerationRate = .fast
        $0.contentInsetAdjustmentBehavior = .never
    }

    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PhotoViewerView {
    func setupUI() {
        backgroundColor = .black

        addSubview(scrollView)
        scrollView.addSubview(imageView)
    }

    func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
