//
//  RealEstate.swift
//  RealEstate
//
//  Created by Amr ELghadban on 6/13/18.
//  Copyright © 2018 ADKA. All rights reserved.
//

import Foundation
struct RealEstate: Codable, JSONDecoderable, Displayable {
    let id: Int?
    let title: String?
    let price: Int?
    let location: Location?
    let images: [Image]?

    enum CodingKeys: String, CodingKey {
        case id, title
        case price
        case location
        case images
    }
}

extension RealEstate {
    init() {
        self.init(id: nil, title: nil, price: nil, location: nil, images: nil)
    }
}
