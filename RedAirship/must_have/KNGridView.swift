//
//  CollectionView.swift
//  Ogenii
//
//  Created by Ky Nguyen Coinhako on 7/19/18.
//  Copyright © 2018 Ogenii. All rights reserved.
//

import UIKit

class knGridCell<U>: knCollectionCell {
    var data: U?
}

class knGridView<C: knGridCell<U>, U>: KNView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var datasource = [U]() { didSet { collectionView.reloadData() }}
    fileprivate let cellId = String(describing: C.self)
    var collectionView: UICollectionView!
    var contentInset = UIEdgeInsets.zero
    var layout: UICollectionViewLayout!
    var itemSize: CGSize!
    var lineSpacing: CGFloat = 0
    var columnSpacing: CGFloat = 0
    
    override func setupView() {
        layout = layout ?? UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(C.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = contentInset
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return datasource.count }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! C
        cell.data = datasource[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = itemSize ?? .zero
        if size.height == 0 {
            size.height = collectionView.frame.height
        }
        if size.width == 0 {
            size.width = collectionView.frame.width
        }
        return size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { return columnSpacing }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { didSelectItem(at: indexPath) }
    func didSelectItem(at indexPath: IndexPath) {}
}

class GridController<C: knGridCell<U>, U>: KNController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var datasource = [U]() { didSet {
        collectionView.reloadData() }}
    fileprivate let cellId = String(describing: C.self)
    var collectionView: UICollectionView!
    var contentInset = UIEdgeInsets.zero
    var layout: UICollectionViewLayout!
    var itemSize: CGSize = .zero
    var lineSpacing: CGFloat = 0
    var columnSpacing: CGFloat = 0
    var hasHeader = false
    var headerSize = CGSize.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func setupView() {
        guard let layout = layout else { fatalError() }
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(C.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = contentInset
    }
    
    func fillGrid() {
        view.addSubviews(views: collectionView)
        collectionView.fill(toView: view)
    }
    
    func registerHeader(headerClass: AnyClass) {
        collectionView.register(headerClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return datasource.count }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! C
        cell.data = datasource[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { return columnSpacing }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { didSelectItem(at: indexPath) }
    func didSelectItem(at indexPath: IndexPath) {}
    
    func setHeader(at index: IndexPath) -> UICollectionReusableView {
        return getHeader(at: index)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if hasHeader { return setHeader(at: indexPath) }
        return UICollectionReusableView()
    }
    
    func getHeader(at index: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: index)
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize { return headerSize }
}
