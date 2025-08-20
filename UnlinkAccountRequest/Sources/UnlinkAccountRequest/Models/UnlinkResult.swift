//
//  UnlinkResult.swift
//  UnlinkAccountRequest
//
//  Created by Mariano Uriel Delgado on 30/09/2022.
//

import Foundation

@objc public final class UnlinkResult: NSObject  {
    @objc public let title: String
    @objc public let message: String
    @objc public let actionTitle: String
    @objc public let action: URL

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

        guard let url = url else { fatalError("Action should be setted at this point") }
        action = url
    }

}
