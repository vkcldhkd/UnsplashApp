//
//  UIStackView.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/7/25.
//

import UIKit
import RxSwift
import SnapKit


extension Reactive where Base: UIStackView {
    var detailRows: Binder<[PhotoDetailRow]> {
        return Binder(base) { stackView, rows in
            
            // 기존 row + 구분선 제거
            stackView.arrangedSubviews.forEach {
                stackView.removeArrangedSubview($0)
                $0.removeFromSuperview()
            }
            
            // 새로운 row 추가
            for (index, row) in rows.enumerated() {
                let rowView = PhotoDetailInfoRowView()
                rowView.configure(title: row.title, value: row.value)
                stackView.addArrangedSubview(rowView)
                
                // 마지막 row가 아닐 때만 separator 추가
                if index < rows.count - 1 {
                    let separator = UIView()
                    separator.backgroundColor = UIColor.separator.withAlphaComponent(0.3)
                    stackView.addArrangedSubview(separator)
                    separator.snp.makeConstraints { make in
                        make.height.equalTo(0.5)
                    }
                }
            }
        }
    }
}
