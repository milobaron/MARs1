//
//  Models.swift
//  MARRs1
//
//  Created by Mike Veson on 5/15/21.
//

import Foundation

struct Crypto: Codable {
    let asset_id: String
    let name: String?
    var price_usd: Float?
    let id_icon: String?
}
