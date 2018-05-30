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

    init(userDetails: UserDetails) {
        userName = userDetails.userName
        userImage = userDetails.userImage
        userContent = userDetails.textContent
    }
}
