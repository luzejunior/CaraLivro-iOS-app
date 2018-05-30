//
//  FeedTableViewCell.swift
//  CaraLivro
//
//  Created by Luzenildo Junior on 29/05/18.
//  Copyright © 2018 Luzenildo Junior. All rights reserved.
//

import UIKit

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

    var userName: String?
    var userImage: String?
    var userContent: String?

    init(textPost: TextPost) {
        userName = textPost.userPosted?.userName
        userImage = textPost.userPosted?.userImage
        userContent = textPost.contentText
    }
}
