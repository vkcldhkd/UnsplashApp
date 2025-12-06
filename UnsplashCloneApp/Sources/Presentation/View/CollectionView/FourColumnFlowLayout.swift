//
//  FourColumnFlowLayout.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/7/25.
//

import UIKit

final class FourColumnFlowLayout: UICollectionViewFlowLayout {

    private let itemsPerRow: CGFloat = 4
    private let spacing: CGFloat = 0

    override func prepare() {
        super.prepare()

        guard let collectionView = self.collectionView else { return }

        let totalSpacing = spacing * (itemsPerRow - 1)
        let availableWidth = collectionView.bounds.width - totalSpacing
        let side = floor(availableWidth / itemsPerRow)

        self.itemSize = CGSize(width: side, height: side)
        self.minimumInteritemSpacing = spacing
        self.minimumLineSpacing = spacing
        self.sectionInset = .zero
    }
}
