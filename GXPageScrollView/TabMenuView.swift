//
//  TabMenuView.swift
//  FirstJapaneseLife
//
//  Created by G-Xi0N on 2017/12/14.
//  Copyright © 2017年 G-Xi0N. All rights reserved.
//

import UIKit

class TabMenuView: UIView {

    public var titles: [String] {
        didSet {
            guard titles.count > 0 else { return }
            
            for index in 0..<titles.count {
                collectionView.register(TabMenuCell.self, forCellWithReuseIdentifier: "TabMenuCell_\(index)")
            }
            collectionView.reloadData()
            collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        }
    }
    public var didSelectItemHandler: ((Int) -> Void)?

    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        return collectionView
    }()

    private lazy var dataSource: [TabMenuModel] = {
        titles.map({
            TabMenuModel(title: $0, titleNormalColor: UIColor.black, titleSelectedColor: UIColor.blue, backgroundLayerColor: nil, underlineColor: UIColor.red)
        })
    }()

    private lazy var itemWidths: [CGFloat] = {
        titles.map({
            CGFloat($0.count * 15 + 30)
        })
    }()

    private var currentIndex = 0
    
    override init(frame: CGRect) {
        self.titles = []
        super.init(frame: frame)
        
        addSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = bounds
    }

    // MARK: - private
    private func addSubviews() {
        self.addSubview(collectionView)
    }

    // MARK: - public
    public func selectItem(at index: Int) {

        guard currentIndex != index else { return }
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        currentIndex = index
    }
    
    public func configureItemStyle(normalColor: UIColor,
                                   selectedColor: UIColor,
                                   underlineColor: UIColor,
                                   backgroundLayerColor: UIColor = .clear) {
        dataSource = dataSource.map({
            TabMenuModel(title: $0.title, titleNormalColor: normalColor, titleSelectedColor: selectedColor, backgroundLayerColor: backgroundLayerColor, underlineColor: underlineColor)
        })
        collectionView.reloadData()
        collectionView.selectItem(at: IndexPath(item: currentIndex, section: 0), animated: false, scrollPosition: .centeredHorizontally)
    }
}

// MARK: - UICollectionViewDataSource
extension TabMenuView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TabMenuCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabMenuCell_\(indexPath.item)", for: indexPath) as! TabMenuCell
        cell.model = dataSource[indexPath.item]
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension TabMenuView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

        guard currentIndex != indexPath.item else {
            return
        }
        currentIndex = indexPath.item
        didSelectItemHandler.map({
            $0(currentIndex)
        })
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TabMenuView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemWidths[indexPath.item], height: bounds.height)
    }
}
