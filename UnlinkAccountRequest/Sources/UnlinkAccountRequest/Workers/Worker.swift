//
//  Worker.swift
//  APIKit
//
//  Created by Mariano Uriel Delgado on 27/09/2022.
//

import APIKit
import UIKit

final class Worker {
    let serviceProvider: AnyAPIProvider<UnlinkRequest>

    init(apiProvider: AnyAPIProvider<UnlinkRequest> = AnyAPIProvider<UnlinkRequest>(APIProvider<UnlinkRequest>())){
        serviceProvider = apiProvider
    }
}

extension Worker {
    func unlink(onCompletion: ((Result<UnlinkMetadata, Error>) -> Void)?) {
        serviceProvider.perform(.unlink) {
            do {
                let metadata = try JSONDecoder().decode(UnlinkMetadata.self, from: $0)
                onCompletion?(.success(metadata))
            } catch {
                onCompletion?(.failure(error))
            }
        } didFail: { onCompletion?(.failure($0)) }
    }

    private func handleUnlinkSuccess(data: Data) {
        guard let dictionary = data.asDictionary else {
            return
        }
        print(dictionary)
    }
}
