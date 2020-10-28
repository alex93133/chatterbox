import Foundation

enum FetchResult<Success, Failure: Error> {
    case success(Success)
    case failure(Failure)
}
