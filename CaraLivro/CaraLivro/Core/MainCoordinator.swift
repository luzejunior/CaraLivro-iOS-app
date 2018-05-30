//
//  MainCoordinator.swift
//  CaraLivro
//
//  Created by Luzenildo Junior on 29/05/18.
//  Copyright © 2018 Luzenildo Junior. All rights reserved.
//

import UIKit

final class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = ViewController.instantiate()
        push(vc, animated: true)
    }

    private func push(_ viewController: UIViewController?, animated: Bool = false) {
        guard let viewController = viewController else {
            return
        }
        navigationController.pushViewController(viewController, animated: animated)
    }

}
