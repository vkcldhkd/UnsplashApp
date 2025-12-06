//
//  SearchListItemCell.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/5/25.
//

import UIKit
import ReactorKit
import SnapKit

final class SearchListItemCell: BaseCollectionViewCell {
    
    // MARK: - UI
    let itemImageView: UIImageView = UIImageView()
    let heartImageView:  UIImageView = UIImageView(image: UIImage().heartImage)
    
    // MARK: Initializing
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setupUI()
        self.setupConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.heartImageView.isHidden = true
    }
}


private extension SearchListItemCell {
    // MARK: - setupUI
    func setupUI() {
        self.contentView.addSubview(self.itemImageView)
        self.contentView.addSubview(self.heartImageView)
    }
    
    
    func setupConstraints() {
        self.itemImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.heartImageView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(12)
            make.size.equalTo(20)
        }
    }
}
