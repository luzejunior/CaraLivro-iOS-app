//
//  FeedTableViewCell.swift
//  CaraLivro
//
//  Created by Luzenildo Junior on 29/05/18.
//  Copyright © 2018 Luzenildo Junior. All rights reserved.
//

import UIKit

@objc protocol FeedTableViewCellActions: class {
    @objc optional func didTouchUser(_ sender: FeedTableViewCell)
}

final class FeedTableViewCell: UITableViewCell, UITableViewContent {

    weak var presenter: FeedTableViewCellPresenter?

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!

    @IBAction func likeButtonTouched(_ sender: Any) {
        print("Liked")
    }

    @IBAction func commentButtonTouched(_ sender: Any) {
        print("commented")
    }

    @IBAction func moreOptions(_ sender: Any) {
        presenter?.view?.presentUIAlert(postID: presenter?.postID ?? 0, postOwnerID: presenter?.posterUser?.idUserProfile ?? 0)
    }

    @IBAction func didTuchCommentaries(_ sender: Any) {
        presenter?.view?.openCommentaries(postID: presenter?.postID ?? 0, postOwnerID: presenter?.posterUser?.idUserProfile ?? 0)
    }

    @IBAction func didSelectedUserButton(_ sender: Any) {
        self.sendAction(#selector(FeedTableViewCellActions.didTouchUser(_:)), sender: self)
    }

    func load(presenter: FeedTableViewCellPresenter) {
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
        contentLabel.text = presenter?.userContent
    }
}

final class FeedTableViewCellPresenter: UITableViewModels {
    var representable: UITableViewRepresentable {
        return UITableViewContentAssembler<FeedTableViewCell>(presenter: self)
    }

    var posterUser: UserDetails?
    var postID: Int?
    var userName: String?
    var userImage: String?
    var userContent: String?
    var view: MoreOptionsConform?
    var isCurrentUser: Bool?

    init(textPost: TextPost, view: MoreOptionsConform) {
        postID = textPost.idPost
        userContent = textPost.Text
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
