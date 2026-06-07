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
    
    private let transitionController = PhotoTransitionController()
    private var selectedIndexPath: IndexPath?
    var selectedCell: PhotoListItemCell? {
        guard let selectedIndexPath else { return nil }
        return collectionView.cellForItem(at: selectedIndexPath) as? PhotoListItemCell
    }
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
        self.navigationController?.delegate = self.transitionController
    }
}

extension PhotoBookmarkViewController: ReactorKit.View {
    func bind(reactor: Reactor) {
        // MARK: - Action
        Observable.zip(
            self.collectionView.rx.itemSelected,
            self.collectionView.rx.itemSelected(dataSource: self.dataSource)
         )
         .throttle(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
         .observe(on: MainScheduler.instance)
         .subscribe(onNext: { [weak self] indexPath, sectionItem in
             guard let self else { return }
             self.selectedIndexPath = indexPath

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

                 self.navigationController?.pushViewController(
                     detailVC,
                     animated: true
                 )
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

extension PhotoBookmarkViewController: PhotoTransitionSource {
    var transitionSourceImageView: UIImageView? {
        return selectedCell?.itemImageView
    }

    var transitionSourceFrame: CGRect? {
        guard let imageView = transitionSourceImageView else { return nil }
        return imageView.superview?.convert(imageView.frame, to: nil)
    }
    
    func updateSelectedIndexPath(_ indexPath: IndexPath) {
        selectedIndexPath = indexPath
    }
}
