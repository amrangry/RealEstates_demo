//
//  BackendAPI.swift
//  RealEstate
//
//  Created by Amr ELghadban on 6/14/18.
//  Copyright © 2018 ADKA. All rights reserved.
//

import Foundation

class BackendAPI {
    static func getRealEstate(completionHandler: @escaping (NetworkResult<Any>) -> Void) {
        guard let url = URLFactory.getURL(.realestates).url else {
            completionHandler(NetworkResult.failure(.noInternet))
            return
        }

        URLSessionManager.share.invokeAPI(url) { response in
            completionHandler(response)
        }
    }
}
