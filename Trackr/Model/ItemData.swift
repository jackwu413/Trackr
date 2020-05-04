//
//  ItemData.swift
//  Trackr
//
//  Created by Jack on 5/1/20.
//  Copyright © 2020 Jack Wu. All rights reserved.
//

import Foundation

struct ItemData: Codable {
    //Values that need to be extracted from JSON in order to finish setting Item values
    var status_code: String?
    var estimated_delivery_date: String?
    var actual_delivery_date: String?
}
