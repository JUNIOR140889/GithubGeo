//
//  ViewController.swift
//  UnlinkAccountRequest
//
//  Created by marianougeo on 09/27/2022.
//  Copyright (c) 2022 marianougeo. All rights reserved.
//

import UIKit
import APIKit
import LoginResolver
import UnlinkAccountRequest

class ViewController: UIViewController {
    var unlinkAccount = UnlinkAccount()
    var loginResolver = LoginResolver(authenticationMethod: .legacy,
                                      biometricConfigurator: .init(onboardingConfiguration: nil))
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAPIKit()
        let user = User(email: "jose.zamora+new@geopagos.com", password: "Geopagos123.")
        loginResolver.performLogin(for: user) { _ in
            self.unlinkAccount.execute { unlinkResult in
                switch unlinkResult {
                case .success(let data):
                    self.showUnlinkAlert(unlinkData: data)
                case .failure(let error):
                    self.showErrorAlert(error: error)
                }
            }
        } _: { _ in
        }
    }

    private func showUnlinkAlert(unlinkData: UnlinkResult) {
        let alertController = UIAlertController(title: unlinkData.title,
                                                message: unlinkData.message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: unlinkData.actionTitle,
                                                style: .default, handler: { _ in
            UIApplication.shared.open(unlinkData.action)
        }))
        self.present(alertController, animated: true)
    }

    private func showErrorAlert(error: Error) {
        let alertController = UIAlertController(title: nil,
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        self.present(alertController, animated: true)
    }

    private func setupAPIKit() {
        APISettings.main.update(app: App(paths: [.sandbox: "https://api-mpos-macro.qa.geopagos.cloud"],
                                         clientIds: [.sandbox: "b261a1e9-3c09-45e9-8391-e38b00fec520"], applicationKey: ""),
                                currentEnvironment: .sandbox)
    }
}
