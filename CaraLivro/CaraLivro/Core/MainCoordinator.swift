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
    var groupView: GroupViewController?
    var defaultModal: ModalViewController?
    var login: LoginViewController?

    init(navigationController: UINavigationController, window: UIWindow?) {
        self.navigationController = navigationController
        self.window = window
    }

    func start() {
        presentLogin()
    }

    func logOut() {
        presentLogin()
    }

    func presentLogin() {
        login = LoginViewController.instantiate()
        let loginPresenter = LoginViewControllerPresenter(with: login!)
        login?.presenter = loginPresenter
        login?.coordinator = self
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

    func didTouchCommentariesButton(postID: Int, postOwnerID: Int) {
        let commentaries = CommentariesViewController.instantiate()
        let commentariesPresenter = CommentariesViewControllerPresenter(with: commentaries, postID: postID, postOwnerID: postOwnerID, viewType: .commentaries)
        commentaries.presenter = commentariesPresenter
        commentaries.coordinator = self
        push(commentaries, animated: true)
    }

    func didTouchOpenResponsesButton(comment: Comments) {
        let commentaries = CommentariesViewController.instantiate()
        let commentariesPresenter = CommentariesViewControllerPresenter(with: commentaries, comment: comment, viewType: .responses)
        commentaries.presenter = commentariesPresenter
        commentaries.coordinator = self
        push(commentaries, animated: true)
    }

    func didTouchFriendListButton(currentUserID: Int) {
        let friendList = FriendListViewController.instantiate()
        let friendListPresenter = FriendListViewControllerPresenter(with: friendList, listType: .friends, currentUserID: currentUserID)
        friendList.presenter = friendListPresenter
        friendList.coordinator = self
        push(friendList, animated: true)
    }

    func didTouchFriendRequestListButton(currentUserID: Int) {
        let friendList = FriendListViewController.instantiate()
        let friendListPresenter = FriendListViewControllerPresenter(with: friendList, listType: .friendRequests, currentUserID: currentUserID)
        friendList.presenter = friendListPresenter
        friendList.coordinator = self
        push(friendList, animated: true)
    }

    func didTouchGroupsButton(currentUserID: Int) {
        let friendList = FriendListViewController.instantiate()
        let friendListPresenter = FriendListViewControllerPresenter(with: friendList, listType: .groups, currentUserID: currentUserID)
        friendList.presenter = friendListPresenter
        friendList.coordinator = self
        push(friendList, animated: true)
    }

    func didTouchBlockedFriendsButton(currentUserID: Int) {
        let friendList = FriendListViewController.instantiate()
        let friendListPresenter = FriendListViewControllerPresenter(with: friendList, listType: .blockedUsers, currentUserID: currentUserID)
        friendList.presenter = friendListPresenter
        friendList.coordinator = self
        push(friendList, animated: true)
    }

    func didTouchGroupsMemberButton(currentGroupID: Int, isGroupAdmin: Bool) {
        let friendList = FriendListViewController.instantiate()
        let friendListPresenter = FriendListViewControllerPresenter(with: friendList, listType: .groupMembers, currentGroupID: currentGroupID)
        friendListPresenter.isGroupAdmin = isGroupAdmin
        friendList.presenter = friendListPresenter
        friendList.coordinator = self
        push(friendList, animated: true)
    }

    func didTouchGroupsMemberRequestButton(currentGroupID: Int) {
        let friendList = FriendListViewController.instantiate()
        let friendListPresenter = FriendListViewControllerPresenter(with: friendList, listType: .groupRequests, currentGroupID: currentGroupID)
        friendList.presenter = friendListPresenter
        friendList.coordinator = self
        push(friendList, animated: true)
    }

    func didTouchPostButton(postUserID: Int) {
        let createPost = CreatePostViewController.instantiate()
        createPost.modalPresentationStyle = UIModalPresentationStyle.popover
        createPost.currentMuralUserID = postUserID
        createPost.listType = .friends
        createPost.coordinator = self
        present(createPost, animated: true)
    }

    func didTouchPostButton(postGroupID: Int) {
        let createPost = CreatePostViewController.instantiate()
        createPost.modalPresentationStyle = UIModalPresentationStyle.popover
        createPost.currentMuralGroupID = postGroupID
        createPost.listType = .groups
        createPost.coordinator = self
        present(createPost, animated: true)
    }

    func didTouchGroup(group: GroupsDetails) {
        groupView = GroupViewController.instantiate()
        let groupPresenter = GroupViewControllerPresenter(with: groupView!, group: group)
        groupView?.presenter = groupPresenter
        groupView?.coordinator = self
        push(groupView, animated: true)
    }

    func didTouchPostButton(listType: ListType) {
        if listType == .friends {
            userProfile?.presenter?.fetchData()
        } else {
            groupView?.presenter?.getPosts()
        }
    }

    func didTouchAddUserButton() {
        let cadastro = CadastroViewController.instantiate()
        cadastro.coordinator = self
        presentModal(cadastro, constraintValue: CGFloat(90.0))
    }

    func didDismissCadastro() {
        login?.presenter?.fetchData()
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

    private func presentModal(_ viewController: UIViewController?, constraintValue: CGFloat, animated: Bool = false) {
        guard let viewController = viewController else {
            return
        }
        defaultModal = ModalViewController.instantiate()
        defaultModal?.modalPresentationStyle = .overCurrentContext
        defaultModal?.viewController = viewController
        self.navigationController.present(defaultModal!, animated: animated, completion: nil)
        defaultModal?.modifyBottomContraint(value: constraintValue)
    }
}
