//
//  MainCoordinator.swift
//  CaraLivro
//
//  Created by Luzenildo Junior on 29/05/18.
//  Copyright © 2018 Luzenildo Junior. All rights reserved.
//

import UIKit

final class MainCoordinator: Coordinator, FeedViewControllerActions, UserProfileViewControllerActions, FeedTableViewCellActions {

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        //presentLogin()
        let feed = FeedViewController.instantiate()
        feed.coordinator = self
        push(feed, animated: true)
    }

    func presentLogin() {
        let login = LoginViewController.instantiate()
        push(login, animated: true)
    }

    func presentUserPage(user: UserDetails) {
        let userProfile = UserProfileViewController.instantiate()
        let userProfilePresenter = UserProfileViewControllerPresenter(with: userProfile, currentUser: user)
        userProfile.presenter = userProfilePresenter
        userProfile.coordinator = self
        push(userProfile, animated: true)
    }

    func didTouchProfileButton(userToDisplay: UserDetails) {
        let userProfile = UserProfileViewController.instantiate()
        let userProfilePresenter = UserProfileViewControllerPresenter(with: userProfile, currentUser: userToDisplay)
        userProfile.presenter = userProfilePresenter
        userProfile.coordinator = self
        push(userProfile, animated: true)
    }

    func didTouchCommentariesButton(postID: Int) {
        let commentaries = CommentariesViewController.instantiate()
        let commentariesPresenter = CommentariesViewControllerPresenter(with: commentaries, postID: postID)
        commentaries.presenter = commentariesPresenter
        push(commentaries, animated: true)
    }

    func didTouchFriendListButton() {
        let friendList = FriendListViewController.instantiate()
        let friendListPresenter = FriendListViewControllerPresenter(with: friendList, listType: .friends)
        friendList.presenter = friendListPresenter
        friendList.coordinator = self
        push(friendList, animated: true)
    }

    func didTouchGroupsButton() {
        let friendList = FriendListViewController.instantiate()
        let friendListPresenter = FriendListViewControllerPresenter(with: friendList, listType: .groups)
        friendList.presenter = friendListPresenter
        friendList.coordinator = self
        push(friendList, animated: true)
    }

    func didTouchPostButton() {
        let createPost = CreatePostViewController.instantiate()
        push(createPost, animated: true)
    }

    private func push(_ viewController: UIViewController?, animated: Bool = false) {
        guard let viewController = viewController else {
            return
        }
        navigationController.pushViewController(viewController, animated: animated)
    }

    private func present(_ viewController: UIViewController?, animated: Bool = false) {
        guard let viewController = viewController else {
            return
        }
        navigationController.view.window?.rootViewController?.present(viewController, animated: animated)
    }
}
