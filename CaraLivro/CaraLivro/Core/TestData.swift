//
//  TestData.swift
//  CaraLivro
//
//  Created by Luzenildo Junior on 30/05/18.
//  Copyright © 2018 Luzenildo Junior. All rights reserved.
//

import Foundation

struct UserDetails: Decodable {
    var idUserProfile: Int?
    var FirstName: String?
    var LastName: String?
    var Email: String?
    var Password: String?
    var ProfilePicture: String?
    var NumberOfFriends: Int?

    init(id: Int?, name: String, email: String, imageName: String) {
        idUserProfile = id
        FirstName = name
        ProfilePicture = imageName
        Email = email
    }
}

struct networkingMessage: Decodable {
    var sucess: Bool
    //var message: String
}

struct CreateUserJson: Encodable {
    var first_name: String
    var last_name: String
    var email: String
    var password: String
}

struct FriendshipRequestJson: Encodable {
    var user_requester_id: Int?
}

struct GroupsDetails {
    var groupName: String?

    init(name: String) {
        groupName = name
    }
}

struct PostInUserMural: Encodable {
    var user_id_poster: Int
    var visibility: String?
    var text: String?
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

    init(id: Int, content: String, user: Int) {
        idPost = id
        Text = content
        UserProfileMural_idUserProfile = user
    }
}

struct CommentInPost: Encodable {
    var user_id_poster: Int
    var user_id_commenter: Int
    var text: String
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

let user1 = UserDetails(id: 0, name: "Luzenildo", email: "luzenildo@email.cu", imageName: "luzenildo")
let user2 = UserDetails(id: 1, name: "Luan", email: "luanviadao@email.cu", imageName: "luan")
let testUsers: [UserDetails] = [user1, user2]
var apiUsers = [UserDetails]()
var currentUserInUse: UserDetails?

let post1 = TextPost(id: 0, content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur cursus lacus in lorem tristique, tristique gravida ex pellentesque. Proin tristique, eros ut lobortis luctus, erat odio ultricies lacus, sit amet gravida est risus non turpis. Cras odio mi, sagittis at convallis non, ultricies eu nulla.", user: 0)
let post2 = TextPost(id: 1, content: "Quisque sit amet massa sem. Mauris euismod sit amet nibh volutpat commodo.", user: 1)
let post3 = TextPost(id: 2, content: "Texto do tamanho do mundo porque eu to sem paciencia pra escrever texto aqui, meu Deus pensa num trabalho trabalhoso.", user: 0)
let testPosts: [TextPost] = [post1, post2, post3]

let textPost1 = ImagePost(content: "Imagem linda e maravilhosa", image: "photo", user: user1)
let imagePosts: [ImagePost] = [textPost1]

let group1 = GroupsDetails(name: "Amamos Alan")
let group2 = GroupsDetails(name: "BD é Vida")
let group3 = GroupsDetails(name: "BD melhor disciplina")
let groupList: [GroupsDetails] = [group1, group2, group3]
//
//let comment1 = Comments(id: 0, nmbrResponses: 0, idPost: 2, postOwner: post2.UserProfileMural_idUserProfile!, postCommenter: user2.idUserProfile ?? 0, text: "Belíssimo texto, muito obrigado pelas sábias palavras")
//let comment2 = Comments(id: 0, nmbrResponses: 0, idPost: 2, postOwner: post2.UserProfileMural_idUserProfile!, postCommenter: user2.idUserProfile ?? 0, text: "Thanks so much!!")
//let testComments: [Comments] = [comment1, comment2]


