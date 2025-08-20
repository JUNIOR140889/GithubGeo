//
//  UnlinkRequest.swift
//  APIKit
//
//  Created by Mariano Uriel Delgado on 27/09/2022.
//

import APIKit

public enum UnlinkRequest {
    case unlink
}

extension UnlinkRequest: TargetType {
    public var path: String {
        switch self {
            case .unlink:
                return "/api/account/unlink"
        }
    } 

    public var method: HTTPMethod {
        return .get
    }

    public var parameters: Parameters? {
        return nil
    }

    public var contentType: ContentType {
        return .applicationJSON
    }

    public var authorized: Bool {
        return true
    }

    public var sourceType: APIKit.SourceType {
        .default
    }
}
