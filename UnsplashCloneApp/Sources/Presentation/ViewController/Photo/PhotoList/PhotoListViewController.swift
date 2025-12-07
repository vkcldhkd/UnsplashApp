//
//  PhotoListViewController.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/5/25.
//

import UIKit
import Then
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources
import ReusableKit
import SnapKit

final class PhotoListViewController: BaseViewController {
    // MARK: Constants
    typealias Reactor = PhotoListViewReactor
    fileprivate struct Reusable {
        static let activityIndicatorView = ReusableView<CollectionActivityIndicatorView>()
        static let listCell = ReusableCell<PhotoListItemCell>()
        static let emptyView = ReusableView<UICollectionReusableView>()
    }
    
    // MARK: Properties
    let dataSource: RxCollectionViewSectionedReloadDataSource<PhotoListSection>
    private static func dataSourceFactory() -> RxCollectionViewSectionedReloadDataSource<PhotoListSection> {
        return .init(
            configureCell: { dataSource, collectionView, indexPath, sectionItem in
                switch sectionItem {
                case let .listItem(cellReactor):
                    let cell = collectionView.dequeue(Reusable.listCell, for: indexPath)
                    cell.reactor = cellReactor
                    return cell
                }
            }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                switch kind {
                case UICollectionView.elementKindSectionFooter:
                    return collectionView.dequeue(Reusable.activityIndicatorView, kind: kind, for: indexPath)
                    
                default:
                    return collectionView.dequeue(Reusable.emptyView, kind: "empty", for: indexPath)
                }
            }
        )
    }
    
    // MARK: UI
    var heartButton: UIButton = UIButton().then {
        let heartImage = UIImage().heartImage
        $0.setImage(heartImage, for: .normal)
        $0.tintColor = .systemRed
        $0.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    }
    
    let searchBar: UISearchBar = UISearchBar(frame: .zero)
    lazy var collectionView = BaseCollectionView(
        frame: .zero,
        collectionViewLayout: FourColumnFlowLayout()
    ).then {
        $0.register(Reusable.listCell)
        $0.register(Reusable.activityIndicatorView, kind: UICollectionView.elementKindSectionFooter)
    }
    
    // MARK: Initializing
    init(reactor: Reactor) {
        defer { self.reactor = reactor }
        self.dataSource = type(of: self).dataSourceFactory()
        super.init(title: "Photo")
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
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

private extension PhotoListViewController {
    // MARK: - setupUI
    func setupUI() {
        self.setupPhotoBar()
        self.setupNavigationBar()
        self.setupCollectionView()
    }
    
    // MARK: - setupPhotoBar
    func setupPhotoBar() {
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


extension PhotoListViewController: ReactorKit.View {
    func bind(reactor: Reactor) {
        // MARK: - Action
        self.heartButton.rx.tap
            .throttle(.milliseconds(700), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: {
                print("HEART BUTTON")
            })
            .disposed(by: self.disposeBag)
        
        self.collectionView.rx.itemSelected(dataSource: self.dataSource)
            .throttle(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] sectionItem in
                guard let self = self else { return }
                switch sectionItem {
                case let .listItem(cellReactor):
                    let photoItem = cellReactor.currentState.model
                    let detailVC = PhotoDetailViewController(reactor: PhotoDetailViewReactor(model: photoItem))
                    self.navigationController?.pushViewController(detailVC, animated: true)
                }
                
            })
            .disposed(by: self.disposeBag)
        
        
        // MARK: - State
        reactor.state.map { $0.sections }
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
    }
}
