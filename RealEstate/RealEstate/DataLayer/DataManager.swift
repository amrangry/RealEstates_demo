//
//  DataManager.swift
//  RealEstate
//
//  Created by Amr ELghadban on 6/14/18.
//  Copyright © 2018 ADKA. All rights reserved.
//

import CoreData
import Foundation
import UIKit

class DataManager {
    static func getRealEstates(completionHandler: @escaping (_ isSuccess: Bool, _ status: ResponseStatus, _ result: [Displayable]?) -> Void) {
        ProgressLoader.show()
        BackendAPI.getRealEstate { result in
            ProgressLoader.dismiss()
            debugPrint(result)
            switch result {
            case .success(let value):
                if let response = value as? JSONDictionary {
                    guard let data = response["items"] else {
                        completionHandler(false, ResponseStatus.errorInParsingResponse, nil)
                        return
                    }
                    if let jsonData = Data.convertToData(data) {
                        guard let result = RealEstate.decodeJsonData(parcelable: RealEstate(), jsonData, isObject: false) as? [RealEstate] else {
                            return
                        }

                        let arrayResult = self.combinedDataSourceWithAdsEvery(Constants.adsIntervalPosition, result)
                        completionHandler(true, ResponseStatus.success, arrayResult)
                    }
                }

            case .failure(let error):
                let failureObject = failureErrorCompletionHandler(error: error)
                completionHandler(failureObject.0, failureObject.1, nil)
            }
        }
    }
}

extension DataManager {
    static func failureErrorCompletionHandler(error: NetworkErrorCodeForResponse) -> (Bool, ResponseStatus, String) {
        switch error {
        case .errorInParsingResponse:
            return (false, ResponseStatus.errorInParsingResponse, "Connection error")
        case .errorStatus:
            return (false, ResponseStatus.errorStatus, "Can't Parse")
        case .noInternet:
            return (false, ResponseStatus.connectionError, "Connection error")
        }
    }

    static func combinedDataSourceWithAdsEvery(_ step: Int, _ array: [Displayable]) -> [Displayable] {
        // build consolidated list of items and ads
        var list = array
        let count = array.count
        let adsNumber = getNumberOfAds(step, count)
        let listCount = count + adsNumber
        for index in stride(from: (step - 1), to: listCount, by: step) {
            let diceRoll = Int(arc4random_uniform(5))
            let imageName = "ads_\(diceRoll)"
            let ads = AdRealEstate(id: index, imagURl: imageName)
            list.insert(ads, at: index)
        }

        debugPrint(list)
        return list
    }

    static func getNumberOfAds(_ adsPosistion: Int, _ dataSourceCount: Int) -> Int {
        var count = 1
        var result = 0
        while result < dataSourceCount {
            result = count * adsPosistion
            if result != 0 {
                count += 1
            }
        }
        debugPrint(count)
        return count
    }
}

extension DataManager {
    static func saveRealEstate(_ data: RealEstate) -> Bool {
        return CoreDataHandler.shared.saveRealEstate(data)
    }

    static func deleteRealEstate(WithId id: Int) -> Bool {
        return CoreDataHandler.shared.deleteRealEstate(WithId: id)
    }

    static func isRealEstateExist(_ data: RealEstate) -> Bool {
        return CoreDataHandler.shared.isRealEstateExist(data)
    }
    static func allRealEstates() -> [NSManagedObject]? {
        return CoreDataHandler.shared.allRealEstates()
    }
}
