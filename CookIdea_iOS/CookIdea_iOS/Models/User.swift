//
//  User.swift
//  CookIdea_iOS
//
//  Created by Edoardo Tagliani on 27/07/24.
//

import Foundation

struct User: Identifiable, Codable{
    var id: Int?
    var name: String?
    var surname: String?
    var birthDate: Date?
    var email: String?
    var username: String
    var password: String?
}
