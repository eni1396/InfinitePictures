//
//  PicturesModel.swift
//  Infinite Pictures
//
//  Created by Nikita Entin on 12.02.2021.
//

import Foundation

struct PicturesModel: Decodable {
    var message: [URL]
    var status: String
}
