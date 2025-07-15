//
//  ViewModel.swift
//  PlayboiFashion
//
//  Created by Playboi In Central on 3/20/25.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

enum RegistrationStep {
    case none, phonenumber, address, done
}

class ViewModel: ObservableObject {
    @Published var selectedTab: Int = 0
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var fullname: String = ""
    @Published var phonenumber: String = ""
    @Published var address: String = ""
    @Published var errorMessage: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var isProfileSetupDone: Bool = false
    @Published var currentUser: User?
    @Published var registrationStep: RegistrationStep = .none
    @Published var users: [User] = []
    @Published var cartItems: [CartItem] = []
    @Published var alertMessage: String?
    @Published var orders: [Order] = []
    
    private let db = Firestore.firestore()
    
    func fetchBrandName(for brandID: String, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        db.collection("Brand").document(brandID).getDocument { snapshot, error in
            if let error = error {
                print("Lỗi khi lấy brand: \(error.localizedDescription)")
                completion(nil)
            } else if let data = snapshot?.data(), let brandName = data["brandName"] as? String {
                completion(brandName)
            } else {
                completion(nil)
            }
        }
    }
    
    func fetchProducts(type: String? = nil, brand: String? = nil) {
        self.isLoading = true
        var query: Query = db.collection("Product")
        if let type = type {
            query = query.whereField("typeID", isEqualTo: type)
        }
        if let brand = brand {
            query = query.whereField("brandID", isEqualTo: brand)
        }
        query.getDocuments { (querySnapshot, error) in
            self.isLoading = false
            
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.products = documents.map { doc in
                let data = doc.data()
                let id = doc.documentID // Lấy id Firestore
                let name = data["name"] as? String ?? ""
                let price = data["price"] as? Double ?? 0.0
                let imgs = data["imgs"] as? [String] ?? []
                let brandID = data["brandID"] as? String ?? ""
                let typeID = data["typeID"] as? String ?? ""
                let rawSizes = data["sizes"] as? [[String: Any]] ?? []
                let sizes = rawSizes.compactMap { dict -> SizeStock? in
                    guard let size = dict["size"] as? String,
                          let quantity = dict["quantity"] as? Int else { return nil }
                    return SizeStock(size: size, quantity: quantity)
                }
                return Product(id: id, name: name, price: price, imgs: imgs, brandID: brandID, typeID: typeID, sizes: sizes)
            }
        }
    }
    
    func fetchUserProfile(uid: String) {
        db.collection("User").document(uid).getDocument { snapshot, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Lỗi khi lấy thông tin người dùng: \(error.localizedDescription)"
                    self.isLoggedIn = false
                    self.isProfileSetupDone = false
                }
                return
            }
            
            guard let data = snapshot?.data() else {
                DispatchQueue.main.async {
                    self.errorMessage = "Không tìm thấy dữ liệu người dùng."
                    self.isLoggedIn = false
                    self.isProfileSetupDone = false
                }
                return
            }
            
            let user = User.from(data: data)
            
            DispatchQueue.main.async {
                self.currentUser = user
                self.email = user.email
                self.fullname = user.fullname
                self.phonenumber = user.phonenumber ?? ""
                self.address = user.address ?? ""
                self.isLoggedIn = true
                self.isProfileSetupDone = user.isProfileComplete
                self.fetchCartItems(for: user.id)
            }
        }
    }
    
    func checkUserStatus() {
        if let currentUser = Auth.auth().currentUser {
            self.isLoggedIn = true
            fetchUserProfile(uid: currentUser.uid)
        } else {
            self.isLoggedIn = false
        }
    }
    
    func login() {
        // B1: Đăng nhập bằng email & password
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Đăng nhập thất bại: \(error.localizedDescription)"
                    self.isLoggedIn = false
                }
                return
            }
            
            guard let uid = result?.user.uid else {
                DispatchQueue.main.async {
                    self.errorMessage = "Không lấy được thông tin người dùng."
                    self.isLoggedIn = false
                }
                return
            }
            
            // B2: Lấy thông tin người dùng từ Firestore
            self.fetchUserProfile(uid: uid)
        }
    }
    
    func register() {
        Auth.auth().createUser(withEmail: self.email, password: self.password) { result, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Đăng ký thất bại: \(error.localizedDescription)"
                }
                return
            }
            
            guard let authUser = result?.user else {
                DispatchQueue.main.async {
                    self.errorMessage = "Không thể lấy thông tin người dùng."
                }
                return
            }
            
            let uid = authUser.uid
            
            // Tạo Users object và lưu vào Firestore
            let newUser = User(
                id: uid,
                email: self.email,
                fullname: self.fullname,
                phonenumber: self.phonenumber,
                address: self.address,
                role: 1
            )
            
            self.db.collection("User").document(uid).setData(newUser.toDictionary()) { error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.errorMessage = "Lỗi lưu dữ liệu: \(error.localizedDescription)"
                    } else {
                        self.currentUser = newUser
                        self.isLoggedIn = true
                        self.isProfileSetupDone = false
                        self.errorMessage = ""
                    }
                }
            }
        }
    }
    
    func logout() {
        try? Auth.auth().signOut()
        DispatchQueue.main.async {
            self.isLoggedIn = false
            self.registrationStep = .none
            self.currentUser = nil
            self.email = ""
            self.password = ""
            self.fullname = ""
            self.phonenumber = ""
            self.address = ""
            self.errorMessage = ""
            self.isProfileSetupDone = false
        }
    }
    
    func updateProfileField(field: String, value: Any) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("User").document(uid).updateData([field: value]) { error in
            DispatchQueue.main.async {
                self.errorMessage = error?.localizedDescription ?? ""
            }
        }
    }
    
    func addProduct(_ product: Product) {
        db.collection("Product").document(product.id).setData(product.toDict()) { error in
            if let error = error {
                print("Lỗi thêm sản phẩm: \(error.localizedDescription)")
                return
            }
            self.fetchProducts()
        }
    }
    
    func updateProduct(_ product: Product) {
        db.collection("Product").document(product.id).setData(product.toDict()) { error in
            if let error = error {
                print("Lỗi cập nhật: \(error.localizedDescription)")
                return
            }
            self.fetchProducts()
        }
    }
    
    func deleteProduct(_ product: Product) {
        db.collection("Product").document(product.id).delete { error in
            if let error = error {
                print("Lỗi xoá sản phẩm: \(error.localizedDescription)")
                return
            }
            self.fetchProducts()
        }
    }
    
    func fetchUsers() {
        db.collection("User").getDocuments { snapshot, error in
            if let error = error {
                print("Lỗi lấy user: \(error.localizedDescription)")
                return
            }
            
            guard let docs = snapshot?.documents else { return }
            
            self.users = docs.compactMap { doc in
                User.from(data: doc.data())
            }
        }
    }
    
    func deleteUser(_ user: User) {
        db.collection("User").document(user.id).delete { error in
            if let error = error {
                print("Lỗi xoá user: \(error.localizedDescription)")
                return
            }
            self.fetchUsers()
        }
    }
    
    func updateUserRole(user: User, to role: Int) {
        var updated = user
        updated.role = role
        db.collection("User").document(user.id).setData(updated.toDictionary()) { error in
            if let error = error {
                print("Lỗi cập nhật role: \(error.localizedDescription)")
                return
            }
            self.fetchUsers()
        }
    }
    
    func addToCart(product: Product, selectedSize: String, userID: String) {
        let id = UUID().uuidString
        let item = CartItem(
            id: id,
            productID: product.id,
            productName: product.name,
            price: product.price,
            selectedSize: selectedSize,
            userID: userID,
            imgs: product.imgs
        )
        
        db.collection("Cart").document(id).setData(item.toDict()) { error in
            if let error = error {
                print("Lỗi khi thêm vào giỏ: \(error.localizedDescription)")
            } else {
                print("Đã thêm vào giỏ hàng")
                DispatchQueue.main.async {
                    self.cartItems.append(item)
                }
            }
        }
    }
    
    func fetchCartItems(for userID: String? = nil) {
        guard let userID = userID ?? self.currentUser?.id else { return }
        
        db.collection("Cart").whereField("userID", isEqualTo: userID).getDocuments { snapshot, error in
            if let error = error {
                print("Lỗi lấy giỏ hàng: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                self.cartItems = []
                return
            }
            
            DispatchQueue.main.async {
                self.cartItems = documents.map { doc in
                    let data = doc.data()
                    return CartItem.from(data: data)
                }
            }
        }
    }
    
    func deleteCartItem(_ item: CartItem) {
        db.collection("Cart").document(item.id).delete { error in
            if let error = error {
                print("Lỗi khi xoá sản phẩm khỏi giỏ: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    self.cartItems.removeAll { $0.id == item.id }
                }
            }
        }
    }
    
    func uploadOrderToFirestore(order: Order) {
        do {
            try db.collection("Order").document(order.id).setData(from: order)
        } catch {
            print("❌ Failed to upload order: \(error.localizedDescription)")
        }
    }
    
    func fetchOrder() {
        db.collection("Order").getDocuments { snapshot, error in
            if let error = error {
                print("Lỗi lấy đơn hàng: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                self.orders = []
                return
            }
            
            DispatchQueue.main.async {
                self.orders = documents.compactMap { doc in
                    let data = doc.data()
                    return Order.from(data: data)
                }
            }
        }
    }
    
    func confirmOrder(
        items: [CartItem],
        quantities: [String: Int],
        total: Double,
        note: String
    ) async throws {
        guard let user = currentUser else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user"])
        }
        
        let batch = db.batch()
        for item in items {
            let productRef = db.collection("Product").document(item.productID)
            let snapshot = try await productRef.getDocument()
            guard let productData = snapshot.data() else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Product not found"])
            }
            
            // Parse sizes từ Firestore (kiểu [[String: Any]]) → [SizeStock]
            guard let rawSizes = productData["sizes"] as? [[String: Any]] else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid size data"])
            }
            
            var sizes: [SizeStock] = rawSizes.compactMap { dict in
                guard let size = dict["size"] as? String,
                      let quantity = dict["quantity"] as? Int else { return nil }
                return SizeStock(size: size, quantity: quantity)
            }
            
            let selectedSize = item.selectedSize
            let quantityOrdered = quantities[item.id] ?? 1
            
            guard let index = sizes.firstIndex(where: { $0.size == selectedSize }) else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Size \(selectedSize) not found in product \(item.productName)"])
            }
            
            guard sizes[index].quantity >= quantityOrdered else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Not enough stock for \(item.productName) - size \(selectedSize)"])
            }
            
            // Trừ số lượng size
            sizes[index].quantity -= quantityOrdered
            
            // Chuyển lại về dạng [[String: Any]] để lưu lên Firestore
            let updatedSizes = sizes.map { ["size": $0.size, "quantity": $0.quantity] }
            
            batch.updateData(["sizes": updatedSizes], forDocument: productRef)
        }
        
        // 1. Khởi tạo Order
        let order = Order(
            id: UUID().uuidString,
            userID: user.id,
            fullname: user.fullname,
            email: user.email,
            phonenumber: user.phonenumber,
            address: user.address,
            items: items,
            quantities: quantities,
            total: total,
            note: note,
            createdAt: Date(),
            status: "pending"
        )
        
        // 2. Upload lên Firestore
        let orderRef = db.collection("Order").document(order.id)
        try batch.setData(from: order, forDocument: orderRef)
        
        try await batch.commit()
        // 3. Xóa CartItem
        for item in items {
            deleteCartItem(item)
        }
    }
    
    func updateOrderStatus(orderID: String, to newStatus: String) {
        let orderRef = db.collection("Order").document(orderID)
        
        orderRef.getDocument { snapshot, error in
            if let error = error {
                print("❌ Failed to fetch order: \(error.localizedDescription)")
                return
            }
            
            guard let snapshot = snapshot,
                  let data = snapshot.data(),
                  let order = try? Firestore.Decoder().decode(Order.self, from: data) else {
                print("❌ Failed to parse order data")
                return
            }
            
            // Nếu huỷ đơn hàng, cộng lại số lượng
            if newStatus == "cancelled" {
                let dispatchGroup = DispatchGroup()
                
                for item in order.items {
                    let productRef = self.db.collection("Product").document(item.productID)
                    dispatchGroup.enter()
                    
                    productRef.getDocument { productSnapshot, error in
                        defer { dispatchGroup.leave() }
                        
                        guard let productData = productSnapshot?.data(),
                              var product = Product.fromDict(productData) else {
                            print("⚠️ Failed to load product \(item.productID)")
                            return
                        }
                        
                        let selectedSize = item.selectedSize
                        let quantity = order.quantities[item.productID] ?? 1
                        
                        if let index = product.sizes.firstIndex(where: { $0.size == selectedSize }) {
                            product.sizes[index].quantity += quantity
                        } else {
                            product.sizes.append(SizeStock(size: selectedSize, quantity: quantity))
                        }
                        
                        productRef.setData(product.toDict(), merge: true) { error in
                            if let error = error {
                                print("⚠️ Failed to update product \(item.productID): \(error.localizedDescription)")
                            }
                        }
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    // Cập nhật trạng thái đơn hàng sau khi đã cộng lại số lượng
                    orderRef.updateData([
                        "status": newStatus
                    ]) { error in
                        if let error = error {
                            print("❌ Error updating order status: \(error.localizedDescription)")
                        } else {
                            print("✅ Order \(orderID) cancelled and stock restored.")
                            self.fetchOrder()
                        }
                    }
                }
            } else {
                // Trường hợp khác chỉ cập nhật trạng thái đơn
                orderRef.updateData([
                    "status": newStatus
                ]) { error in
                    if let error = error {
                        print("❌ Error updating order status: \(error.localizedDescription)")
                    } else {
                        print("✅ Order \(orderID) updated to status: \(newStatus)")
                        self.fetchOrder()
                    }
                }
            }
        }
    }
    
    
    func fetchOrderForCurrentUser() {
        guard let currentUserID = currentUser?.id else { return }
        db.collection("Order")
            .whereField("userID", isEqualTo: currentUserID)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Lỗi lấy đơn hàng: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                DispatchQueue.main.async {
                    self.orders = documents.compactMap { Order.from(data: $0.data()) }
                }
            }
    }
}
