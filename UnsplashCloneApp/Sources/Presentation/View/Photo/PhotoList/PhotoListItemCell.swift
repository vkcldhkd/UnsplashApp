//
//  PhotoListItemCell.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/5/25.
//

import UIKit
import ReactorKit
import SnapKit
import RxSwift
import RxKingfisher
import Then
import RxCocoa
internal import Kingfisher

final class PhotoListItemCell: BaseCollectionViewCell {
    // MARK: - Constants
    typealias Reactor = PhotoListItemCellReactor
    
    // MARK: - UI
    let itemImageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    let heartImageView:  UIImageView = UIImageView(image: UIImage().heartImage).then {
        $0.tintColor = .systemRed
    }
    
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


private extension PhotoListItemCell {
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

extension PhotoListItemCell: ReactorKit.View {
    func bind(reactor: Reactor) {
        // MARK: - Action
        
        // MARK: - State
        reactor.state.map { $0.model }
            .compactMap { URLHelper.createEncodedURL(url: $0.urls?.thumb) }
            .bind(to: self.itemImageView.kf.rx.image())
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLiked }
            .map { !$0 }
            .distinctUntilChanged()
            .bind(to: self.heartImageView.rx.isHidden)
            .disposed(by: self.disposeBag)
    }
}
