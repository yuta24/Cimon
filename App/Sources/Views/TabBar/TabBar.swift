//
//  TabBar.swift
//  App
//
//  Created by Yu Tawata on 2019/08/10.
//

import Foundation
import UIKit
import Shared

class TabBar: UIView {
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.showsVerticalScrollIndicator = false
            collectionView.showsHorizontalScrollIndicator = false
        }
    }

    var itemSelected: (Int) -> Void = { _ in }

    private var currentView = UIView()

    private var items = [String]() {
        didSet {
            updateLayout()
            collectionView.reloadData()
        }
    }
    private var observations = [NSKeyValueObservation]()
    private var currentViewWidthConstraint: NSLayoutConstraint!
    private var currentViewLeadingConstraint: NSLayoutConstraint!

    private var selected = 0 {
        didSet {
            currentViewLeadingConstraint.constant = itemSize.width * CGFloat(selected)
        }
    }

    private var itemSize: CGSize {
        return CGSize(width: collectionView.bounds.width / CGFloat(items.count), height: collectionView.bounds.height)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    func move(to index: Int) {
        selected = index
    }

    private func commonInit() {
        Xib<TabBar>().load(to: self)

        addSubview(currentView)
        currentView.translatesAutoresizingMaskIntoConstraints = false
        currentView.backgroundColor = Asset.accent.color

        currentViewLeadingConstraint = currentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
        NSLayoutConstraint.activate([
            currentView.heightAnchor.constraint(equalToConstant: 4),
            currentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            currentViewLeadingConstraint])

        observations.append(collectionView.observe(\.bounds, options: [.new]) { [weak self] (_, _) in
            self?.updateLayout()
        })
    }

    private func updateLayout() {
        if let constraint = currentViewWidthConstraint {
            constraint.isActive = false
        }
        currentViewWidthConstraint = currentView.widthAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 1 / CGFloat(items.count))
        NSLayoutConstraint.activate([currentViewWidthConstraint])
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = itemSize
            flowLayout.sectionInset = .zero
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
        }
    }
}

extension TabBar: Configurable {
    struct Context {
        var titles: [String]
    }

    func configure(_ context: TabBar.Context) {
        items = context.titles
    }
}

extension TabBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = TabItemCell.dequeue(for: indexPath, from: collectionView)
        cell.configure(.init(title: items[indexPath.item]))
        return cell
    }
}

extension TabBar: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        itemSelected(indexPath.item)
    }
}
