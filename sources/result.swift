enum Result<T>{
    case success(T)
    case failure(String)
}

extension Result: CustomStringConvertible {
    var description: String {
        switch self {
            case .success(let value):
                return String(describing: value)
            case .failure(let error):
                return error
        }
    }
}
