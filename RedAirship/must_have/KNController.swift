//
//  KNController.swift
//  Ogenii
//
//  Created by Ky Nguyen on 3/17/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit

import UIKit
class KNController: UIViewController {
    var shouldGetDataViewDidLoad: Bool {
        return false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        if shouldGetDataViewDidLoad {
            getData()
        }
    }
    
    func setupView() {}
    func getData() {}
    deinit {
        print("Deinit \(NSStringFromClass(type(of: self)))")
    }
}

class KNFixedTableController: UITableViewController {
    var itemCount: Int { return 0 }
    var shouldGetDataViewDidLoad = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .white
        registerCells()
        setupView()
        if shouldGetDataViewDidLoad {
            getData()
        }
    }
    
    func setupView() {}
    func registerCells() {}
    func getData() {}
    deinit {
        print("Deinit \(NSStringFromClass(type(of: self)))")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return itemCount }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { return UITableViewCell() }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 100 }
}

class KNTableController: KNController {
    var itemCount: Int { return 0 }
    var rowHeight: CGFloat { return 100 }
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
    }
    
    func registerCells() {}
    
    lazy var tableView: UITableView = { [weak self] in
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.separatorStyle = .none
        tb.showsVerticalScrollIndicator = false
        tb.dataSource = self
        tb.delegate = self
        return tb
        }()
    
    deinit {
        print("Deinit \(NSStringFromClass(type(of: self)))")
    }
}

extension KNTableController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return itemCount }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { return UITableViewCell() }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return rowHeight }
}

class KNFixedCollectionController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var itemCount: Int { return 0 }
    var shouldGetDataViewDidLoad = false

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        setupView()
        if shouldGetDataViewDidLoad {
            getData()
        }
    }
    
    init() { super.init(collectionViewLayout: UICollectionViewFlowLayout()) }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented")}
    func registerCells() {}
    func setupView() {}
    func getData() {}
    
    deinit { print("Deinit \(NSStringFromClass(type(of: self)))") }
}
extension KNFixedCollectionController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return itemCount }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { return UICollectionViewCell() }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { return 0 }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { return UIScreen.main.bounds.size }
}
