//
//  PhotoBookmarkViewController.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/8/25.
//

import UIKit
import ReusableKit
import RxDataSources
import ReactorKit
import RxSwift
import Then
import SnapKit
import RxCocoa

final class PhotoBookmarkViewController: BaseViewController {
    // MARK: Constants
    typealias Reactor = PhotoBookmarkViewReactor
    fileprivate struct Reusable {
        static let listCell = ReusableCell<PhotoListItemCell>()
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
            }
        )
    }
    
    // MARK: UI
    lazy var collectionView = BaseCollectionView(
        frame: .zero,
        collectionViewLayout: FourColumnFlowLayout()
    ).then {
        $0.register(Reusable.listCell)
    }
    let emptyView = BookmarkEmptyView()
    
    // MARK: Initializing
    
    init(reactor: Reactor) {
        defer { self.reactor = reactor }
        self.dataSource = type(of: self).dataSourceFactory()
        super.init(title: "Bookmark")
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.emptyView.frame = self.collectionView.bounds
    }
    
    override func setupConstraints() {
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
}

private extension PhotoBookmarkViewController {
    // MARK: - setupUI
    func setupUI() {
        self.view.addSubview(self.collectionView)
    }
}

extension PhotoBookmarkViewController: ReactorKit.View {
    func bind(reactor: Reactor) {
        // MARK: - Action
        self.collectionView.rx.itemSelected(dataSource: self.dataSource)
            .throttle(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(
                onNext: { [weak self] sectionItem in
                    guard let self = self else { return }
                    switch sectionItem {
                    case let .listItem(cellReactor):
                        let photoItem = cellReactor.currentState.model
                        let repository = PhotoBookmarkRepositoryImpl()
                        let useCase = ToggleBookmarkUseCaseImpl(repository: repository)
                        let detailVC = PhotoDetailViewController(
                            reactor: PhotoDetailViewReactor(
                                model: photoItem,
                                toggleBookmarkUseCase: useCase
                            )
                        )
                    self.navigationController?.pushViewController(detailVC, animated: true)
                }
            })
            .disposed(by: self.disposeBag)
        
        // MARK: - State
        reactor.state.map { $0.sections }
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.sections.first?.items.isEmpty ?? true }
            .distinctUntilChanged()
            .bind(to: self.collectionView.rx.isEmptyBackground(emptyView: self.emptyView))
            .disposed(by: self.disposeBag)
    }
}
