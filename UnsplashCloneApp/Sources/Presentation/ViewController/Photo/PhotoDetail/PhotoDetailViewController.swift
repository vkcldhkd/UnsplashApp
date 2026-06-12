//
//  PhotoDetailViewController.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/7/25.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxGesture
import Then
import SnapKit
import RxKingfisher
internal import Kingfisher


final class PhotoDetailViewController: BaseViewController {
    
    // MARK: Constants
    typealias Reactor = PhotoDetailViewReactor
    
    // MARK: Properties
    
    
    // MARK: UI
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let photoImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.cornerRadius = 16
    }
    private let infoCardView = UIView().then {
        $0.backgroundColor = .secondarySystemBackground
        $0.cornerRadius = 16
    }
    private let infoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.alignment = .fill
        $0.distribution =  .fill
    }
    
    private let buttonContainerView = ShadowContainerView()
    private let heartButton = FloatingHeartButton()
    
    // MARK: Initializing
    
    init(reactor: PhotoDetailViewReactor) {
        defer { self.reactor = reactor }
        super.init(title: "Detail")
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func setupConstraints() {
        self.scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(self.scrollView.snp.width) // 세로 스크롤용
        }
        
        self.photoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(self.photoImageView.snp.width)
        }
        
        self.infoCardView.snp.makeConstraints { make in
            make.top.equalTo(self.photoImageView.snp.bottom).offset(16)
            make.leading.trailing.equalTo(photoImageView)
            make.bottom.equalToSuperview().inset(16)
        }
        
        self.infoStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.buttonContainerView.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(12)
            make.size.equalTo(56)
        }
        
        self.heartButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

private extension PhotoDetailViewController {
    // MARK: - setupUI
    func setupUI() {
        view.addSubview(self.scrollView)
        self.scrollView.addSubview(contentView)

        // image
        self.contentView.addSubview(self.photoImageView)

        // info card
        self.contentView.addSubview(self.infoCardView)

        // stackView
        self.infoCardView.addSubview(self.infoStackView)
        
        self.view.addSubview(self.buttonContainerView)
        self.buttonContainerView.addSubview(self.heartButton)
    }
}

extension PhotoDetailViewController: ReactorKit.View {
    func bind(reactor: Reactor) {
        // MARK: - Action
        self.heartButton.rx.tap
            .throttle(.milliseconds(700), scheduler: MainScheduler.asyncInstance)
            .map { Reactor.Action.updateLiked }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.photoImageView.rx.tapGesture()
            .when(.recognized)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                print("Clicked PhotoImageView")
                guard let self = self else { return }
                guard let image = self.photoImageView.image else { return }
                let viewerVC = PhotoViewerViewController(image: image)
//                viewerVC.modalPresentationStyle = .custom
                
                let naviVC = BaseNavigationController(rootViewController: viewerVC)
                naviVC.modalPresentationStyle = .fullScreen
                self.present(naviVC, animated: true)
            })
            .disposed(by: self.disposeBag)
        
        // MARK: - State
        reactor.state.map { $0.model }
            .compactMap { URLHelper.createEncodedURL(url: $0.urls?.regular) }
            .bind(to: self.photoImageView.kf.rx.image())
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.rows }
            .distinctUntilChanged { $0 == $1 }
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: self.infoStackView.rx.detailRows)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLiked }
            .distinctUntilChanged()
            .bind(to: self.heartButton.rx.isLiked)
            .disposed(by: self.disposeBag)
    }
}

extension PhotoDetailViewController: PhotoTransitionDestination {
    var transitionDestinationImageView: UIImageView? {
        return self.photoImageView
    }
    
    func prepareTransitionLayout() {
        view.layoutIfNeeded()
        self.photoImageView.superview?.layoutIfNeeded()
    }
}
