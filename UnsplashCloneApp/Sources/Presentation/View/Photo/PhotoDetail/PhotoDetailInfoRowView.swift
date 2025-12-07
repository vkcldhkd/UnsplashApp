//
//  Untitled.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/7/25.
//

import UIKit
import SnapKit
import Then

final class PhotoDetailInfoRowView: UIView {

    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .secondaryLabel
    }
    private let valueLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .label
        $0.textAlignment = .right
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        $0.setContentHuggingPriority(.required, for: .horizontal)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String?, value: String?) {
        titleLabel.text = title
        valueLabel.text = value
    }
}


private extension PhotoDetailInfoRowView {
    // MARK: - setupUI
    func setupUI() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.valueLabel)
    }
    
    // MARK: - setupConstraints
    func setupConstraints() {
        self.titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(16)
        }

        self.valueLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().inset(16)
            make.leading.greaterThanOrEqualTo(self.titleLabel.snp.trailing).offset(8)
        }
    }
}
