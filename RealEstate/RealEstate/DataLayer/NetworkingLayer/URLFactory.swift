//
//  URLFactory .swift
//  RealEstate
//
//  Created by Amr ELghadban on 6/14/18.
//  Copyright © 2018 ADKA. All rights reserved.
//

import Foundation

enum URLFactory {
    case getURL(EndPoint)

    enum EndPoint: String {
        case realestates
    }

    var url: URL? {
        switch self {
        case .getURL(let endPonit):
            let urlString = "\(self.mainDomain)\(endPonit.rawValue)"
            guard let allowedURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                return nil
            }
            guard let url = URL(string: allowedURL) else {
                return nil
            }
            return url
        }
    }

    var stringPath: String? {
        let url = self.url
        let urlAbsoluteString = url?.absoluteString
        return urlAbsoluteString
    }

    var mainDomain: String {
        let baseHostURL = "http://private-91146-mobiletask.apiary-mock.com"
        let webServicePathURL = "/"
        let baseURL = baseHostURL + webServicePathURL
        return baseURL
    }
}
