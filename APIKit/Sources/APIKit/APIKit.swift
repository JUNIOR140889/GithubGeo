import Foundation

public enum HTTPMethod {
    case get
}

public typealias Parameters = [String: Any]

public enum ContentType {
    case applicationJSON
}

public enum SourceType {
    case `default`
}

public protocol TargetType {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var contentType: ContentType { get }
    var authorized: Bool { get }
    var sourceType: SourceType { get }
}

public protocol APIProviderProtocol {
    associatedtype Target: TargetType
    func perform(_ target: Target, didSucceed: @escaping (Data) -> Void, didFail: @escaping (Error) -> Void)
}

public final class AnyAPIProvider<Target: TargetType>: APIProviderProtocol {
    private let performClosure: (Target, @escaping (Data) -> Void, @escaping (Error) -> Void) -> Void

    public init<P: APIProviderProtocol>(_ provider: P) where P.Target == Target {
        self.performClosure = provider.perform
    }

    public init(perform: @escaping (Target, @escaping (Data) -> Void, @escaping (Error) -> Void) -> Void) {
        self.performClosure = perform
    }

    public func perform(_ target: Target, didSucceed: @escaping (Data) -> Void, didFail: @escaping (Error) -> Void) {
        performClosure(target, didSucceed, didFail)
    }
}

public final class APIProvider<Target: TargetType>: APIProviderProtocol {
    public init() {}
    public func perform(_ target: Target, didSucceed: @escaping (Data) -> Void, didFail: @escaping (Error) -> Void) {
        didFail(NSError(domain: "APIProvider", code: -1, userInfo: nil))
    }
}

public extension Data {
    var asDictionary: [String: Any]? {
        (try? JSONSerialization.jsonObject(with: self, options: [])) as? [String: Any]
    }
}

public extension String {
    func asURL() throws -> URL {
        if let url = URL(string: self) {
            return url
        } else {
            throw URLError(.badURL)
        }
    }
}
