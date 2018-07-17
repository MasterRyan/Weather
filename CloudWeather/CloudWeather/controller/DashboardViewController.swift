//
//  DashboardViewController.swift
//  CloudWeather
//
//  Created by matthew.ryan on 7/17/18.
//  Copyright © 2018 Ryan. All rights reserved.
//

import UIKit

class DashboardViewController: DashboardDataController {

    @IBOutlet weak var fiveDayCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //fiveDayCollectionView
    }

    override func refresh() {
        fiveDayCollectionView.reloadData()
    }
}

extension DashboardViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension DashboardViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.bounds.size

        return CGSize(width: (size.width / 6), height: size.height)
    }

}

extension DashboardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fiveDayData?.list.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HOUR_CELL", for: indexPath) as? SummeryCollectionViewCell,
            let data = fiveDayData?.list[indexPath.item] else { return UICollectionViewCell()}

        cell.setup(with: data)

        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

}
