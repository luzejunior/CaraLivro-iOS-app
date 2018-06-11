//
//  Cell.swift
//  CaraLivro
//
//  Created by Luzenildo Junior on 01/06/18.
//  Copyright © 2018 Luzenildo Junior. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

final class FeedImageTableViewCell: UITableViewCell, UITableViewContent {

    weak var presenter: FeedImageTableViewCellPresenter?

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var imagem: UIImageView!

    @IBAction func likeButtonTouched(_ sender: Any) {
        print("Liked")
    }

    @IBAction func commentButtonTouched(_ sender: Any) {
        presenter?.view?.openCommentaries(postID: presenter?.postID ?? 0, postOwnerID: presenter?.posterUser?.idUserProfile ?? 0)
    }

    @IBAction func didSelectedUser(_ sender: Any) {
        self.sendAction(#selector(FeedTableViewCellActions.didTouchUser(_:)), sender: self)
    }

    @IBAction func moreOptions(_ sender: Any) {
        presenter?.view?.presentUIAlert(postID: presenter?.postID ?? 0, postOwnerID: presenter?.posterUser?.idUserProfile ?? 0)
    }


    func load(presenter: FeedImageTableViewCellPresenter) {
        self.presenter = presenter
        configureView()
    }

    func configureView() {
        userName.text = presenter?.userName
        userImage.image = nil
        if presenter?.userImage == nil {
            userImage.image = UIImage(named: "profilePic")
        } else {
            userImage.kf.setImage(with: URL(string: presenter?.userImage ?? ""))
        }
        imagem.kf.setImage(with: URL(string: presenter?.imagePath ?? ""))
        contentLabel.text = presenter?.userContent
    }
}

final class FeedImageTableViewCellPresenter: UITableViewModels {
    var representable: UITableViewRepresentable {
        return UITableViewContentAssembler<FeedImageTableViewCell>(presenter: self)
    }

    var posterUser: UserDetails?
    var postID: Int?
    var userName: String?
    var userImage: String?
    var userContent: String?
    var view: MoreOptionsConform?
    var isCurrentUser: Bool?
    var imagePath: String?
    var image: UIImage?

    init(textPost: TextPost, view: MoreOptionsConform) {
        postID = textPost.idPost
        userContent = textPost.Text
        imagePath = textPost.Attachment_Path
        getPostUserData(userID: textPost.UserProfile_idUserProfile_postOwner ?? 0)
        if textPost.UserProfileMural_idUserProfile != textPost.UserProfile_idUserProfile_postOwner {
            for user in apiUsers {
                if user.idUserProfile == textPost.UserProfileMural_idUserProfile {
                    self.userName = self.userName! + " -> "
                    self.userName = self.userName! + (user.FirstName ?? "") + " " + (user.LastName ?? "")
                }
            }
        }
        self.view = view
    }

    func getPostUserData(userID: Int) {
        for user in apiUsers {
            if user.idUserProfile == userID {
                userName = (user.FirstName ?? "") + " " + (user.LastName ?? "")
                userImage = user.ProfilePicture
                posterUser = user
            }
        }
        isCurrentUser = userID == currentUserInUse?.idUserProfile ? true : false
    }
}
