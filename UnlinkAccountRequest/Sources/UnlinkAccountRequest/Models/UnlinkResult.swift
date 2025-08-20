import Foundation

#if canImport(ObjectiveC)
@objcMembers
public final class UnlinkResult: NSObject {
    public let title: String
    public let message: String
    public let actionTitle: String
    public let action: URL

    init(metadata: UnlinkMetadata) {
        title = metadata.title
        message = metadata.message
        actionTitle = metadata.action.name

        var url: URL?
        switch metadata.action.type {
        case .url:
            url = try? metadata.action.metadata.link?.asURL()
        case .dial:
            guard let phone = metadata.action.metadata.phone else { fatalError("String cannot be nil") }
            url = try? "tel://\(phone)".asURL()
        case .invalid:
            break
        }

        guard let finalURL = url else { fatalError("Action should be setted at this point") }
        action = finalURL
    }
}
#else
public final class UnlinkResult {
    public let title: String
    public let message: String
    public let actionTitle: String
    public let action: URL

    init(metadata: UnlinkMetadata) {
        title = metadata.title
        message = metadata.message
        actionTitle = metadata.action.name

        var url: URL?
        switch metadata.action.type {
        case .url:
            url = try? metadata.action.metadata.link?.asURL()
        case .dial:
            guard let phone = metadata.action.metadata.phone else { fatalError("String cannot be nil") }
            url = try? "tel://\(phone)".asURL()
        case .invalid:
            break
        }

        guard let finalURL = url else { fatalError("Action should be setted at this point") }
        action = finalURL
    }
}
#endif
