//
//  Location.swift
//  RealEstate
//
//  Created by Amr ELghadban on 6/15/18.
//  Copyright © 2018 ADKA. All rights reserved.
//

import Foundation

struct Location: Codable {
    let address: String?
    let latitude, longitude: Double?

    enum CodingKeys: String, CodingKey {
        case address
        case latitude
        case longitude
    }
}
