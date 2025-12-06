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
import RxDataSources
import ReusableKit
import SnapKit

final class SearchListViewController: BaseViewController {
    // MARK: Constants
    typealias Reactor = SearchListViewReactor
    fileprivate struct Reusable {
        static let activityIndicatorView = ReusableView<CollectionActivityIndicatorView>()
        static let listCell = ReusableCell<SearchListItemCell>()
        static let emptyView = ReusableView<UICollectionReusableView>()
    }
    
    // MARK: Properties
    let dataSource: RxCollectionViewSectionedReloadDataSource<SearchListSection>
    private static func dataSourceFactory() -> RxCollectionViewSectionedReloadDataSource<SearchListSection> {
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
        reactor.state.map { $0.sections }
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
    }
}
