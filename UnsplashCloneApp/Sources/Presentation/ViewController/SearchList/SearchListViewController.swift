//
//  SearchListViewController.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/5/25.
//

import UIKit
import Then
import ReactorKit
import RxSwift
import RxCocoa
import SnapKit

final class SearchListViewController: BaseViewController {
    // MARK: Constants
    typealias Reactor = SearchListViewReactor
    
    // MARK: Properties
    var heartButton: UIButton = UIButton().then {
        let heartImage = UIImage().heartImage
        $0.setImage(heartImage, for: .normal)
        $0.tintColor = .systemRed
        $0.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    }
    
    // MARK: UI
    let searchBar: UISearchBar = UISearchBar(frame: .zero)
    lazy var collectionView = BaseCollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    // MARK: Initializing
    init(reactor: Reactor) {
        defer { self.reactor = reactor }
        super.init(title: "Search")
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.reactor?.action.onNext(.load)
    }
    
    override func setupConstraints() {
        self.searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.searchBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

private extension SearchListViewController {
    // MARK: - setupUI
    func setupUI() {
        self.setupSearchBar()
        self.setupNavigationBar()
        self.setupCollectionView()
    }
    
    // MARK: - setupSearchBar
    func setupSearchBar() {
        self.view.addSubview(self.searchBar)
    }
    
    // MARK: - setupNavigationBar
    func setupNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.heartButton)
    }
    
    // MARK: - setupCollectionView
    func setupCollectionView() {
        self.view.addSubview(self.collectionView)
    }
}


extension SearchListViewController: ReactorKit.View {
    func bind(reactor: Reactor) {
        // MARK: - Action
        self.heartButton.rx.tap
            .throttle(.milliseconds(700), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: {
                print("HEART BUTTON")
            })
            .disposed(by: self.disposeBag)
        
        // MARK: - State
    }
}
