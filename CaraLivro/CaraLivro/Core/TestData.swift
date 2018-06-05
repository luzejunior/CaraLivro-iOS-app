//
//  TestData.swift
//  CaraLivro
//
//  Created by Luzenildo Junior on 30/05/18.
//  Copyright © 2018 Luzenildo Junior. All rights reserved.
//

import Foundation

struct UserDetails {
    var userName: String?
    var userImage: String?
    var userEmail: String?

    init(name: String, email: String, imageName: String) {
        userName = name
        userImage = imageName
        userEmail = email
    }
}

struct GroupsDetails {
    var groupName: String?

    init(name: String) {
        groupName = name
    }
}

struct TextPost {
    var idPost: Int?
    var contentText: String?
    var userPosted: UserDetails?

    init(id: Int, content: String, user: UserDetails) {
        idPost = id
        contentText = content
        userPosted = user
    }
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

struct Comments {
    var idComments: Int?
    var numberOfResponses: Int?
    var idPost: Int?
    var idUserProfilePostOwner: Int?
    var idUserProfilePostCommenter: Int?
    var commentText: String?

    init(id: Int, nmbrResponses: Int, idPost: Int, postOwner: Int?, postCommenter: Int, text: String?) {
        idComments = id
        numberOfResponses = nmbrResponses
        self.idPost = idPost
        idUserProfilePostOwner = postOwner
        idUserProfilePostCommenter = postCommenter
        commentText = text
    }
}

struct CommentResponses {
    var idResponse: Int?

}

let user1 = UserDetails(name: "Luzenildo", email: "luzenildo@email.cu", imageName: "luzenildo")
let user2 = UserDetails(name: "Luan", email: "luanviadao@email.cu", imageName: "luan")
let testUsers: [UserDetails] = [user1, user2]

let post1 = TextPost(id: 0, content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur cursus lacus in lorem tristique, tristique gravida ex pellentesque. Proin tristique, eros ut lobortis luctus, erat odio ultricies lacus, sit amet gravida est risus non turpis. Cras odio mi, sagittis at convallis non, ultricies eu nulla.", user: user1)
let post2 = TextPost(id: 1, content: "Quisque sit amet massa sem. Mauris euismod sit amet nibh volutpat commodo.", user: user2)
let post3 = TextPost(id: 2, content: "Texto do tamanho do mundo porque eu to sem paciencia pra escrever texto aqui, meu Deus pensa num trabalho trabalhoso.", user: user1)
let testPosts: [TextPost] = [post1, post2, post3]

let textPost1 = ImagePost(content: "Imagem linda e maravilhosa", image: "photo", user: user1)
let imagePosts: [ImagePost] = [textPost1]

let group1 = GroupsDetails(name: "Amamos Alan")
let group2 = GroupsDetails(name: "BD é Vida")
let group3 = GroupsDetails(name: "BD melhor disciplina")
let groupList: [GroupsDetails] = [group1, group2, group3]


