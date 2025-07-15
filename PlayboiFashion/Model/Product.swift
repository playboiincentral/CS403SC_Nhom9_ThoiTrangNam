//
//  Product.swift
//  PlayboiFashion
//
//  Created by Playboi In Central on 4/21/25.
//

import Foundation

struct SizeStock: Codable, Hashable {
    var size: String
    var quantity: Int
}

struct Product: Identifiable, Codable, Hashable {
    var id: String
    var name: String
    var price: Double
    var imgs: [String]
    var brandID: String
    var typeID: String
    var sizes: [SizeStock]

    // MARK: - Parse từ Firestore Dictionary
    static func fromDict(_ dict: [String: Any]) -> Product? {
        guard let id = dict["id"] as? String,
              let name = dict["name"] as? String,
              let price = dict["price"] as? Double,
              let imgs = dict["imgs"] as? [String],
              let brandID = dict["brandID"] as? String,
              let typeID = dict["typeID"] as? String,
              let rawSizes = dict["sizes"] as? [[String: Any]] else { return nil }

        // Parse sizes
        let sizes = rawSizes.compactMap { sizeDict -> SizeStock? in
            guard let size = sizeDict["size"] as? String,
                  let quantity = sizeDict["quantity"] as? Int else { return nil }
            return SizeStock(size: size, quantity: quantity)
        }

        return Product(id: id, name: name, price: price, imgs: imgs, brandID: brandID, typeID: typeID, sizes: sizes)
    }

    // MARK: - Chuyển thành Firestore Dictionary
    func toDict() -> [String: Any] {
        let sizeDicts = sizes.map { ["size": $0.size, "quantity": $0.quantity] }
        return [
            "id": id,
            "name": name,
            "price": price,
            "imgs": imgs,
            "brandID": brandID,
            "typeID": typeID,
            "sizes": sizeDicts
        ]
    }
}
