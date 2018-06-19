//
//  FavouriteViewController.swift
//  RealEstate
//
//  Created by Amr ELghadban on 6/14/18.
//  Copyright © 2018 ADKA. All rights reserved.
//

import UIKit
protocol CachedDataChanged: NSObjectProtocol {
    func dataChanged()
}
class FavouriteViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet var realEstateTableView: UITableView!

    // MARK: - Varibles
    weak var delegate: CachedDataChanged?
    let realEstateTableViewCellIdentifier = "RealEstateTableViewCell"
    var dataSource: [RealEstateManaged] = []

    // MARK: - VC LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.realEstateTableView.estimatedRowHeight = 90
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getRealSavedEstates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - VC Helper Methods

    func getRealSavedEstates() {
        guard let realEstateArray = DataManager.allRealEstates() as? [RealEstateManaged] else {
            return
        }

        self.dataSource = realEstateArray
        self.realEstateTableView.reloadData()
    }
}

extension FavouriteViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.dataSource.count > 0 {
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
        let realEstate = dataSource[indexPath.row]
        let cellIdentifier = realEstateTableViewCellIdentifier
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RealEstateTableViewCell else {
            return RealEstateTableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }

        cell.bindData(realEstate)

        cell.favBtnPressed = { _ in
            let deleteResult = DataManager.deleteRealEstate(WithId: Int(realEstate.id))
            if deleteResult {
                self.getRealSavedEstates()
                self.delegate?.dataChanged()
            }
        }
        return cell
    }
}
