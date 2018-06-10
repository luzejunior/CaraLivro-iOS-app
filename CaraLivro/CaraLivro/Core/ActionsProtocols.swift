//
//  VCProtocols.swift
//  CaraLivro
//
//  Created by Luzenildo Junior on 30/05/18.
//  Copyright © 2018 Luzenildo Junior. All rights reserved.
//

import Foundation

// Actions:
protocol FeedViewControllerActions: CommentariesButtonProtocol, PresentUserButtonProtocol {
    func didTouchProfileButton(userToDisplay: UserDetails)
}

protocol UserProfileViewControllerActions: postButtonProtocol, CommentariesButtonProtocol {
    func didTouchFriendListButton(currentUserID: Int)
    func didTouchGroupsButton(currentUserID: Int)
}

protocol LoginViewControllerActions {
    func didSelectedUserToLogin(currentUser: UserDetails)
    func didTouchAddUserButton()
}

// Conform:
protocol postButtonProtocol {
    func didTouchPostButton(postUserID: Int)
}

protocol MoreOptionsConform: UIAlertOptionsConform {
    func openCommentaries(postID: Int, postOwnerID: Int)
}

protocol UIAlertOptionsConform {
    func presentUIAlert()
}

protocol CommentariesButtonProtocol {
    func didTouchCommentariesButton(postID: Int, postOwnerID: Int)
}

protocol PresentUserButtonProtocol {
    func presentUserPage(user: UserDetails)
}

protocol FriendListTableViewCellConform: UIAlertOptionsConform {

}
