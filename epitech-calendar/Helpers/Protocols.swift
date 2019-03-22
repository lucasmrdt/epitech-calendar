//
//  Protocols.swift
//  epitech-calendar
//
//  Created by Lucas Marandat on 14/03/2019.
//  Copyright © 2019 Lucas Marandat. All rights reserved.
//

import UIKit

@objc protocol ScrollerDelegateProtocol {
    func numberOfSections(in collectionView: UICollectionView) -> Int
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    @objc optional func scrollViewDidScroll(_ scrollView: UIScrollView)
    @objc optional func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    @objc optional func viewDidAppear(_ animated: Bool)
}
