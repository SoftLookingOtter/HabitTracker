import Foundation
import SwiftData

@Model
class Habit {
    var name: String
    var isCompleted: Bool

    init(name: String) {
        self.name = name
        self.isCompleted = false
    }
}
