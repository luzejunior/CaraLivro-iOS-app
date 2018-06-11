//
//  TestData.swift
//  CaraLivro
//
//  Created by Luzenildo Junior on 30/05/18.
//  Copyright © 2018 Luzenildo Junior. All rights reserved.
//

import Foundation
import UIKit

struct UserDetails: Decodable {
    var idUserProfile: Int?
    var FirstName: String?
    var LastName: String?
    var Email: String?
    var Password: String?
    var ProfilePicture: String?
    var NumberOfFriends: Int?
}

struct networkingMessage: Decodable {
    var sucess: Bool
    var message: String
}

struct CreateUserJson: Encodable {
    var first_name: String
    var last_name: String
    var email: String
    var password: String
    var ProfilePicture: String?
}

struct FriendshipRequestJson: Encodable {
    var user_requester_id: Int?
}

struct GroupsDetails: Decodable {
    var idGroups: Int?
    var Name: String?
    var Description: String?
    var NumberOfMembers: Int?
}

struct PostInUserMural: Encodable {
    var user_id_poster: Int
    var visibility: String?
    var text: String?
    var attachment_type: String?
    var attachment_path: String?
}

struct TextPost: Decodable {
    var idPost: Int?
    var Text: String?
    var NumberOfComments: Int?
    var Visibility: Int?
    var UserProfile_idUserProfile_postOwner: Int?
    var GroupsMural_idGroups: Int?
    var UserProfileMural_idUserProfile: Int?
    var NumberOfLikes: Int?
    var Attachment_Path: String?
    var Attachment_Type: String?
}

struct CommentInPost: Encodable {
    var user_id_poster: Int
    var user_id_commenter: Int
    var text: String
}

struct PostIntoGroupMural: Encodable {
    var id_poster: Int
    var visibility: String
    var text: String
    var attachment_type: String?
    var attachment_path: String?
}

struct ImagePost {
    var contentText: String?
    var imageName: String?
    var userPosted: UserDetails?

    init(content: String, image: String, user: UserDetails) {
        contentText = content
        imageName = image
        userPosted = user
    }
}

struct Comments: Decodable {
    var idComments: Int?
    var NumberOfResponses: Int?
    var Post_idPost: Int?
    var Post_UserProfile_idUserProfile_postOwner: Int?
    var UserProfile_idUserProfile_commenter: Int?
    var text: String?
}

struct CommentResponses {
    var idResponse: Int?

}

var apiUsers = [UserDetails]()
var apiGroups = [GroupsDetails]()
var currentUserInUse: UserDetails?
