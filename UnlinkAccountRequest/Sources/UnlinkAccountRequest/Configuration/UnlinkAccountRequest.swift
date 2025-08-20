//
//  UnlinkAccountRequest.swift
//  APIKit
//
//  Created by Mariano Uriel Delgado on 30/09/2022.
//

import Foundation
import APIKit

public class UnlinkAccount: NSObject {
    let worker: Worker

    public init(apiProvider: AnyAPIProvider<UnlinkRequest> = AnyAPIProvider<UnlinkRequest>(APIProvider<UnlinkRequest>())){
        worker = Worker(apiProvider: apiProvider)
    }

    public func execute(onCompletion: ((Result<UnlinkResult, Error>) -> Void)?)  {
        worker.unlink {
            switch $0 {
            case .failure(let error):
                onCompletion?(.failure(error))
            case .success(let metadata):
                onCompletion?(.success(UnlinkResult(metadata: metadata)))
            }
        }
    }
}
