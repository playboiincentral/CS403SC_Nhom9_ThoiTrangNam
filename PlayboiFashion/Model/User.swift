//
//  User.swift
//  PlayboiFashion
//
//  Created by Playboi In Central on 6/17/25.
//

import Foundation

struct User: Identifiable {
    var id: String
    var email: String
    var fullname: String
    var phonenumber: String?
    var address: String?
    var role: Int
    
    var isProfileComplete: Bool {
        return phonenumber != nil && !phonenumber!.isEmpty &&
        address != nil && !address!.isEmpty
    }
    
    static func from(data: [String: Any]) -> User {
        return User(
            id: data["id"] as? String ?? "",
            email: data["email"] as? String ?? "",
            fullname: data["fullname"] as? String ?? "",
            phonenumber: data["phonenumber"] as? String,
            address: data["address"] as? String,
            role: data["role"] as? Int ?? 1
        )
    }
}

extension User {
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "email": email,
            "fullname": fullname as Any,
            "phonenumber": phonenumber as Any,
            "address": address as Any,
            "role": role,
        ]
    }
}
