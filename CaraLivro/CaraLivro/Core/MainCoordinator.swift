//
//  MainCoordinator.swift
//  CaraLivro
//
//  Created by Luzenildo Junior on 29/05/18.
//  Copyright © 2018 Luzenildo Junior. All rights reserved.
//

import UIKit

final class MainCoordinator: Coordinator, FeedViewControllerActions, UserProfileViewControllerActions, FeedTableViewCellActions, LoginViewControllerActions, CreatePostViewControllerActions {

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var window: UIWindow?

    var userProfile: UserProfileViewController?

    init(navigationController: UINavigationController, window: UIWindow?) {
        self.navigationController = navigationController
        self.window = window
    }

    func start() {
        presentLogin()
    }

    func presentLogin() {
        let login = LoginViewController.instantiate()
        let loginPresenter = LoginViewControllerPresenter(with: login)
        login.presenter = loginPresenter
        login.coordinator = self
        push(login, animated: true)
    }

    func didSelectedUserToLogin(currentUser: UserDetails) {
        currentUserInUse = currentUser
        navigationController = UINavigationController()
        window?.rootViewController = navigationController
        let feed = FeedViewController.instantiate()
        feed.coordinator = self
        push(feed, animated: true)
    }

    func presentUserPage(user: UserDetails) {
        userProfile = UserProfileViewController.instantiate()
        let userProfilePresenter = UserProfileViewControllerPresenter(with: userProfile!, currentUser: user)
        userProfile?.presenter = userProfilePresenter
        userProfile?.coordinator = self
        push(userProfile, animated: true)
    }

    func didTouchProfileButton(userToDisplay: UserDetails) {
        userProfile = UserProfileViewController.instantiate()
        let userProfilePresenter = UserProfileViewControllerPresenter(with: userProfile!, currentUser: userToDisplay)
        userProfile?.presenter = userProfilePresenter
        userProfile?.coordinator = self
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

    func didTouchPostButton(postUserID: Int) {
        let createPost = CreatePostViewController.instantiate()
        createPost.currentMuralUserID = postUserID
        createPost.coordinator = self
        push(createPost, animated: true)
    }

    func didTouchPostButton() {
        pop(animated: true)
        userProfile?.presenter?.fetchData()
    }

    private func push(_ viewController: UIViewController?, animated: Bool = false) {
        guard let viewController = viewController else {
            return
        }
        navigationController.pushViewController(viewController, animated: animated)
    }

    private func pop(animated: Bool = false) {
        navigationController.popViewController(animated: animated)
    }

    private func present(_ viewController: UIViewController?, animated: Bool = false) {
        guard let viewController = viewController else {
            return
        }
        navigationController.view.window?.rootViewController?.present(viewController, animated: animated)
    }
}
