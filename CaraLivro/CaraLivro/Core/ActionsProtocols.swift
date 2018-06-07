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
    func didTouchFriendListButton()
    func didTouchGroupsButton()
}

protocol LoginViewControllerActions {
    func didSelectedUserToLogin(currentUser: UserDetails)
}

// Conform:
protocol postButtonProtocol {
    func didTouchPostButton()
}

protocol MoreOptionsConform: UIAlertOptionsConform {
    func openCommentaries(postID: Int)
}

protocol UIAlertOptionsConform {
    func presentUIAlert()
}

protocol CommentariesButtonProtocol {
    func didTouchCommentariesButton(postID: Int)
}

protocol PresentUserButtonProtocol {
    func presentUserPage(user: UserDetails)
}

protocol FriendListTableViewCellConform: UIAlertOptionsConform {

}
