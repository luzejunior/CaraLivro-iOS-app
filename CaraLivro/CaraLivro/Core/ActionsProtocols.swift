//
//  VCProtocols.swift
//  CaraLivro
//
//  Created by Luzenildo Junior on 30/05/18.
//  Copyright © 2018 Luzenildo Junior. All rights reserved.
//

import Foundation

protocol FeedViewControllerActions {
    func didTouchProfileButton(userToDisplay: UserDetails)
}

protocol UserProfileViewControllerActions: postButtonProtocol {
    func didTouchFriendListButton()
    func didTouchGroupsButton()
}

protocol postButtonProtocol {
    func didTouchPostButton()
}
