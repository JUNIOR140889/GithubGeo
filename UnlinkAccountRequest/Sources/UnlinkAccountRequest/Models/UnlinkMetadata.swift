//
//  UnlinkMetadata.swift.swift
//  Pods
//
//  Created by Mariano Uriel Delgado on 28/09/2022.
//

import Foundation

public struct UnlinkMetadata: Decodable {
    var title: String
    var message: String
    var action: Action

    public init(from decoder: Decoder) throws {
        let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)
        title = try keyedContainer.decode(String.self, forKey: .title)
        message = try keyedContainer.decode(String.self, forKey: .message)
        action = try keyedContainer.decode(Action.self, forKey: .action)
    }

    private enum CodingKeys: String, CodingKey {
        case title, message, action
    }
}

extension UnlinkMetadata {
    public struct Action: Decodable {
        struct Metadata: Decodable {
            var link: String?
            var phone: String?

            init(from decoder: Decoder) throws {
                let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)
                link = try? keyedContainer.decodeIfPresent(String.self, forKey: .link)
                phone = try? keyedContainer.decodeIfPresent(String.self, forKey: .phone)
            }
            private enum CodingKeys: String, CodingKey {
                case link, phone
            }
        }
        enum ActionType: String, Decodable {
            case url, dial, invalid

            init(from decoder: Decoder) throws {
                let singleValue = try decoder.singleValueContainer()
                if let value = try? singleValue.decode(String.self),
                   let type = ActionType(rawValue: value.lowercased()) {
                    self = type
                } else {
                    self = .invalid
                }
          }
        }
        let type: ActionType
        let name: String
        let metadata: Metadata

        public init(from decoder: Decoder) throws {
            let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)
            type = try keyedContainer.decode(ActionType.self, forKey: .type)
            name = try keyedContainer.decode(String.self, forKey: .name)
            metadata = try keyedContainer.decode(Metadata.self, forKey: .metadata)
        }

        private enum CodingKeys: String, CodingKey {
            case type, name
            case metadata = "data"
        }
    }
}
