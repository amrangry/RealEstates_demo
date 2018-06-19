//
//  Image.swift
//  RealEstate
//
//  Created by Amr ELghadban on 6/15/18.
//  Copyright © 2018 ADKA. All rights reserved.
//

import Foundation

struct Image: Codable {
    let id: Int?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case id
        case url
    }
}
