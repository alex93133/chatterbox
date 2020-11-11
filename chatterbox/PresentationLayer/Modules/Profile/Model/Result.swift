import Foundation

enum Result<Success> {
    case success(Success)
    case error
}
