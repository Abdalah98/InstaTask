//
//  Albums.swift
//  InstaBostaTask
//
//  Created by Abdallah on 01/02/2023.
//

import Foundation

// MARK: - Album
struct Albums: Codable {
    let userID, id: Int
    let title: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title
    }
}
 
