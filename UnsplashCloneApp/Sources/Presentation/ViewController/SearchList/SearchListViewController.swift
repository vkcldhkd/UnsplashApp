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
import SnapKit

final class SearchListViewController: BaseViewController {
    // MARK: Constants
    
    // MARK: Properties
    var heartButton: UIButton = UIButton().then {
        let heartImage = UIImage(systemName: "heart.fill")?
            .withTintColor(.red, renderingMode: .alwaysTemplate)
        
        $0.setImage(heartImage, for: .normal)
        $0.tintColor = .systemRed
        $0.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    }
    
    // MARK: UI
    let searchBar: UISearchBar = UISearchBar(frame: .zero)
    
    
    // MARK: Initializing
    init() {
        super.init(title: "Search")
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func setupConstraints() {
        self.searchBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

private extension SearchListViewController {
    // MARK: - setupUI
    func setupUI() {
        self.setupSearchBar()
        self.setupNavigationBar()
    }
    
    // MARK: - setupSearchBar
    func setupSearchBar() {
        self.view.addSubview(self.searchBar)
    }
    
    // MARK: - setupNavigationBar
    func setupNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.heartButton)
    }
}
