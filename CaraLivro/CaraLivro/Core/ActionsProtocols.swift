//
//  VCProtocols.swift
//  CaraLivro
//
//  Created by Luzenildo Junior on 30/05/18.
//  Copyright © 2018 Luzenildo Junior. All rights reserved.
//

import Foundation

protocol FeedViewControllerActions: CommentariesButtonProtocol, PresentUserButtonProtocol {
    func didTouchProfileButton(userToDisplay: UserDetails)
}

protocol UserProfileViewControllerActions: postButtonProtocol, CommentariesButtonProtocol {
    func didTouchFriendListButton()
    func didTouchGroupsButton()
}

protocol postButtonProtocol {
    func didTouchPostButton()
}

protocol MoreOptionsConform {
    func presentUIAlert()
    func openCommentaries(postID: Int)
}

protocol CommentariesButtonProtocol {
    func didTouchCommentariesButton(postID: Int)
}

protocol PresentUserButtonProtocol {
    func presentUserPage(user: UserDetails)
}
