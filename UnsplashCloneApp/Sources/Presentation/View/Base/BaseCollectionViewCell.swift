//
//  BaseCollectionViewCell.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/5/25.
//

import UIKit
import RxSwift

class BaseCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    lazy private(set) var className: String = {
        return type(of: self).description().components(separatedBy: ".").last ?? ""
    }()
    
    // MARK: - Rx
    var disposeBag = DisposeBag()
    
    
    // MARK: Initializing
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(frame: .zero)
    }
    
    deinit {
        print("DEINIT: \(self.className)")
    }
}
