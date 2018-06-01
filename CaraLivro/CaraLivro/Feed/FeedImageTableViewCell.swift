//
//  Cell.swift
//  CaraLivro
//
//  Created by Luzenildo Junior on 01/06/18.
//  Copyright © 2018 Luzenildo Junior. All rights reserved.
//

import Foundation
import UIKit

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
        print("commented")
    }

    @IBAction func moreOptions(_ sender: Any) {
        presenter?.view?.presentUIAlert()
    }


    func load(presenter: FeedImageTableViewCellPresenter) {
        self.presenter = presenter
        configureView()
    }

    func configureView() {
        userName.text = presenter?.userName
        userImage.image = UIImage(named: presenter?.userImage ?? "")
        imagem.image = UIImage(named: presenter?.imageName ?? "")
        contentLabel.text = presenter?.userContent

    }
}

final class FeedImageTableViewCellPresenter: UITableViewModels {
    var representable: UITableViewRepresentable {
        return UITableViewContentAssembler<FeedImageTableViewCell>(presenter: self)
    }

    var userName: String?
    var userImage: String?
    var userContent: String?
    var imageName: String?
    var view: MoreOptionsConform?

    init(textPost: ImagePost, view: MoreOptionsConform) {
        userName = textPost.userPosted?.userName
        userImage = textPost.userPosted?.userImage
        imageName = textPost.imageName
        userContent = textPost.contentText
        self.view = view
    }
}
