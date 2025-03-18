import Foundation
import SwiftUI

class UserSession: ObservableObject {
    @Published var userID: Int?
    @Published var userName: String?
    @Published var isLoggedIn: Bool = false
}
