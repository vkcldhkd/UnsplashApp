//
//  PhotoBookmarkEmptyView.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/8/25.
//

import UIKit
import SnapKit
import Then

final class BookmarkEmptyView: UIView {
    // MARK: - UI
    private let imageView = UIImageView().then {
        $0.image = UIImage(systemName: "heart.slash")
        $0.tintColor = .tertiaryLabel
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "북마크된 사진이 없습니다."
        $0.font = .preferredFont(forTextStyle: .headline)
        $0.textColor = .secondaryLabel
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = "상세 페이지에서 마음에 드는 사진을 하트로 저장해보세요."
        $0.font = .preferredFont(forTextStyle: .subheadline)
        $0.textColor = .tertiaryLabel
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 12
    }
    
    // MARK: - Initializing
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupUI()
        self.setupConstraints()
    }
}

private extension BookmarkEmptyView {
    // MARK: - setupUI
    func setupUI() {
        self.backgroundColor = .systemBackground
        
        self.addSubview(self.stackView)
        
        [self.imageView, self.titleLabel, self.descriptionLabel]
            .forEach { self.stackView.addArrangedSubview($0) }
    }
    
    // MARK: - setupConstraints
    func setupConstraints() {
        self.imageView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
        
        self.stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
}
