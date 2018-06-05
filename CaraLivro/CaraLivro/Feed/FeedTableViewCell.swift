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

    @IBAction func likeButtonTouched(_ sender: Any) {
        print("Liked")
    }

    @IBAction func commentButtonTouched(_ sender: Any) {
        print("commented")
    }

    @IBAction func moreOptions(_ sender: Any) {
        presenter?.view?.presentUIAlert()
    }

    @IBAction func didTuchCommentaries(_ sender: Any) {
        presenter?.view?.openCommentaries()
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
        userImage.image = UIImage(named: presenter?.userImage ?? "")
        contentLabel.text = presenter?.userContent

    }
}

final class FeedTableViewCellPresenter: UITableViewModels {
    var representable: UITableViewRepresentable {
        return UITableViewContentAssembler<FeedTableViewCell>(presenter: self)
    }

    var posterUser: UserDetails?
    var userName: String?
    var userImage: String?
    var userContent: String?
    var view: MoreOptionsConform?

    init(textPost: TextPost, view: MoreOptionsConform) {
        userName = textPost.userPosted?.userName
        userImage = textPost.userPosted?.userImage
        userContent = textPost.contentText
        posterUser = textPost.userPosted
        self.view = view
    }
}
