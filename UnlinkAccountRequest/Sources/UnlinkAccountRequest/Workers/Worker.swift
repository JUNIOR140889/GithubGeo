//
//  Worker.swift
//  APIKit
//
//  Created by Mariano Uriel Delgado on 27/09/2022.
//

import APIKit
import UIKit

protocol WorkerProtocol {
    func unlink(onCompletion: ((Result<UnlinkMetadata, Error>) -> Void)?)
}

final class Worker: WorkerProtocol {
    let serviceProvider: AnyAPIProvider<UnlinkRequest>

    init(apiProvider: AnyAPIProvider<UnlinkRequest> = AnyAPIProvider<UnlinkRequest>(APIProvider<UnlinkRequest>())){
        serviceProvider = apiProvider
    }

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
