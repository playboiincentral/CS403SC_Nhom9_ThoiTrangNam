//
//  CartItem.swift
//  PlayboiFashion
//
//  Created by Playboi In Central on 6/18/25.
//

import Foundation

struct CartItem: Identifiable, Codable {
    var id: String
    var productID: String
    var productName: String
    var price: Double
    var selectedSize: String
    var userID: String
    var imgs: [String]

    func toDict() -> [String: Any] {
        return [
            "id": id,
            "productID": productID,
            "productName": productName,
            "price": price,
            "selectedSize": selectedSize,
            "userID": userID,
            "imgs": imgs
        ]
    }

    static func from(data: [String: Any]) -> CartItem {
        return CartItem(
            id: data["id"] as? String ?? UUID().uuidString,
            productID: data["productID"] as? String ?? "",
            productName: data["productName"] as? String ?? "",
            price: data["price"] as? Double ?? 0.0,
            selectedSize: data["selectedSize"] as? String ?? "",
            userID: data["userID"] as? String ?? "",
            imgs: data["imgs"] as? [String] ?? []
        )
    }
}
