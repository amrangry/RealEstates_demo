//
//  RealEstateListViewController.swift
//  RealEstate
//
//  Created by Amr ELghadban on 6/13/18.
//  Copyright © 2018 ADKA. All rights reserved.
//

import UIKit

class RealEstateListViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet var realEstateTableView: UITableView!

    // MARK: - Varibles

    let realEstateTableViewCellIdentifier = "RealEstateTableViewCell"
    let adsTableViewCellIdentifier = "AdsTableViewCell"
    var dataSource: [Displayable] = []

    // MARK: - VC LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        realEstateTableView.estimatedRowHeight = 90

        getRealEstates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favSegue" {
            guard let vc = segue.destination as? FavouriteViewController else {
                return
            }
            vc.delegate = self
        }
    }

    // MARK: - VC Helper Methods

    func getRealEstates() {
        DataManager.getRealEstates { isSuccess, _, result in
            if isSuccess {
                guard let realEstateArray = result else {
                    return
                }
                self.dataSource = realEstateArray
                self.realEstateTableView.reloadData()
            } else {
                let msg = "No Data Found"
                UIAlertController().show(message: msg)
            }
        }
    }
}
extension RealEstateListViewController: CachedDataChanged {
    func dataChanged() {
        getRealEstates()
    }
}
extension RealEstateListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if dataSource.count > 0 {
            tableView.restore()
            return 1
        } else {
            tableView.setEmptyMessage("No Data Found")
            return 0
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataSourceCount = dataSource.count
        return dataSourceCount
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let realEstate = dataSource[indexPath.row] as? RealEstate {
            return getRealEstateCell(tableView, cellForRowAt: indexPath, data: realEstate)
        } else if let ads = dataSource[indexPath.row] as? AdRealEstate {
            return getAdsCell(tableView, cellForRowAt: indexPath, data: ads)
        } else {
            return UITableViewCell()
        }
    }

    func getAdsCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, data: Displayable) -> UITableViewCell {
        let cellIdentifier = adsTableViewCellIdentifier
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AdsTableViewCell else {
            return AdsTableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        cell.bindData(data)
        return cell
    }

    func getRealEstateCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, data: Displayable) -> UITableViewCell {
        let cellIdentifier = realEstateTableViewCellIdentifier
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RealEstateTableViewCell else {
            return RealEstateTableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }

        cell.bindData(data)
        if let realEstate = data as? RealEstate {
            let isCached = DataManager.isRealEstateExist(realEstate)
            cell.updateFavouriteUIForSavedStatus(isCached)
        }
        cell.favBtnPressed = { _ in
            guard let realEstate = data as? RealEstate else {
                return
            }
            let isCached = DataManager.isRealEstateExist(realEstate)
            var operationResult = isCached
            if isCached {
                //Detele from CoreData
                if let realEstateId = realEstate.id {
                let deleteResult = DataManager.deleteRealEstate(WithId: realEstateId)
                    operationResult = !deleteResult
                }
            } else {
                //Save in CoreData
                let saveResult = DataManager.saveRealEstate(realEstate)
                operationResult = saveResult
            }

            cell.updateFavouriteUIForSavedStatus(operationResult)
        }
        return cell
    }
}
