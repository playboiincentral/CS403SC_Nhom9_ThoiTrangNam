//
//  Order.swift
//  PlayboiFashion
//
//  Created by Playboi In Central on 6/21/25.
//

import Foundation
import FirebaseCore

struct Order: Identifiable, Codable {
    var id: String = UUID().uuidString
    
    // Thông tin người đặt hàng
    var userID: String
    var fullname: String
    var email: String
    var phonenumber: String?
    var address: String?
    
    // Thông tin đơn hàng
    var items: [CartItem]
    var quantities: [String: Int]
    var total: Double
    var note: String
    var createdAt: Date = Date()
    var status: String
}

extension Order {
    init(from user: User, items: [CartItem], quantities: [String: Int], total: Double, note: String, status: String) {
        self.userID = user.id
        self.fullname = user.fullname
        self.email = user.email
        self.phonenumber = user.phonenumber
        self.address = user.address
        self.items = items
        self.quantities = quantities
        self.total = total
        self.note = note
        self.status = status
    }
    
    static func from(data: [String: Any]) -> Order? {
        guard
            let id = data["id"] as? String,
            let userID = data["userID"] as? String,
            let fullname = data["fullname"] as? String,
            let email = data["email"] as? String,
            let itemsData = data["items"] as? [[String: Any]],
            let quantities = data["quantities"] as? [String: Int],
            let total = data["total"] as? Double,
            let note = data["note"] as? String,
            let timestamp = data["createdAt"] as? Timestamp, // from Firestore
            let status = data["status"] as? String
        else {
            return nil
        }
        
        let items: [CartItem] = itemsData.compactMap { CartItem.from(data: $0) }
        let phonenumber = data["phonenumber"] as? String
        let address = data["address"] as? String
        let createdAt = timestamp.dateValue()
        
        return Order(
            id: id,
            userID: userID,
            fullname: fullname,
            email: email,
            phonenumber: phonenumber,
            address: address,
            items: items,
            quantities: quantities,
            total: total,
            note: note,
            createdAt: createdAt,
            status: status
        )
    }
}
