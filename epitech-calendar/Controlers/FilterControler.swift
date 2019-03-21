//
//  FilterViewControler.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 11/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import UIKit

class FilterControler : UICollectionViewController {
    
    // MARK - Constants
    let reuseCellIdentifier = "FilterCell"
    let reuseHeaderIdentifier = "FilterHeader"
    let itemsPerRow: CGFloat = 3
    let itemPadding: CGFloat = 20
    let itemHeight: CGFloat = 40
    
    // MARK - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

// MARK - UICollectionViewDataSource
extension FilterControler {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return FilterModel.sections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FilterModel.sections[section].items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCellIdentifier, for: indexPath) as! FilterCellView
        let section = FilterModel.sections[indexPath.section]
        cell.label = section.items[indexPath.item]
        cell.isCellSelected = section.isSelected(index: indexPath.item)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseHeaderIdentifier, for: indexPath) as! FilterSectionHeaderView
            let section = FilterModel.sections[indexPath.section]
            headerView.sectionTitle.text = section.key
            return headerView
        default:
            fatalError("Invalid element type")
        }
    }

}

// MARK - UICollectionViewLayout
extension FilterControler : UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = itemPadding * (itemsPerRow + 1)
        let avaibleWidth = view.frame.width - padding
        let widthPerItem = avaibleWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: itemHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: itemPadding, left: itemPadding, bottom: itemPadding, right: itemPadding)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemPadding
    }

}

// MARK - UICollectionViewEvent
extension FilterControler {
    
    private func toggleRadioView(_ collectionView: UICollectionView, section: FilterSection, indexPath: IndexPath) {
        let view = collectionView.cellForItem(at: indexPath) as! FilterCellView
        let previousRow = section.getSelectedItems().first!
        guard previousRow != indexPath.row else { return }

        let previousIndexPath = IndexPath(row: previousRow, section: indexPath.section)
        let previousView = collectionView.cellForItem(at: previousIndexPath) as! FilterCellView
 
        DispatchQueue.main.async {
            previousView.isCellSelected = false
            view.isCellSelected = true
        }
    }
    
    private func toggleSelectView(_ collectionView: UICollectionView, indexPath: IndexPath) {
        let view = collectionView.cellForItem(at: indexPath) as! FilterCellView

        DispatchQueue.main.async {
            view.isCellSelected = !view.isCellSelected
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = FilterModel.sections[indexPath.section]
        
        if section.inputType == .Radio {
            toggleRadioView(collectionView, section: section, indexPath: indexPath)
        } else {
            toggleSelectView(collectionView, indexPath: indexPath)
        }

        section.toggle(index: indexPath.row)
    }
    
}

