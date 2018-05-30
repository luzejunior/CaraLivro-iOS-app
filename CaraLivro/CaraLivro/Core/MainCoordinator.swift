//
//  MainCoordinator.swift
//  CaraLivro
//
//  Created by Luzenildo Junior on 29/05/18.
//  Copyright © 2018 Luzenildo Junior. All rights reserved.
//

import UIKit

final class MainCoordinator: Coordinator, FeedViewControllerActions, UserProfileViewControllerActions {

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let feed = FeedViewController.instantiate()
        feed.coordinator = self
        push(feed, animated: true)
    }

    func didTouchProfileButton(userToDisplay: UserDetails) {
        let userProfile = UserProfileViewController.instantiate()
        let userProfilePresenter = UserProfileViewControllerPresenter(with: userProfile, currentUser: userToDisplay)
        userProfile.presenter = userProfilePresenter
        userProfile.coordinator = self
        push(userProfile, animated: true)
    }

    func didTouchFriendListButton() {
        let friendList = FriendListViewController.instantiate()
        friendList.coordinator = self
        push(friendList, animated: true)
    }

    func didTouchGroupsButton() {

    }

    func didTouchPostButton() {

    }

    private func push(_ viewController: UIViewController?, animated: Bool = false) {
        guard let viewController = viewController else {
            return
        }
        navigationController.pushViewController(viewController, animated: animated)
    }
}
