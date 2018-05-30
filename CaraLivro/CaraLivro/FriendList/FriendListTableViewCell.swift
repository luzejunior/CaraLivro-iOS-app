//
//  FriendListTableViewCell.swift
//  CaraLivro
//
//  Created by Luan Lima on 30/05/18.
//  Copyright © 2018 Luan Lima. All rights reserved.
//

import UIKit

final class FriendListTableViewCell: UITableViewCell, UITableViewContent {
    
    weak var presenter: FriendListTableViewCellPresenter?
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    func load(presenter: FriendListTableViewCellPresenter) {
        self.presenter = presenter
        configureView()
    }
    
    func configureView() {
        userName.text = presenter?.userName
        userImage.image = UIImage(named: presenter?.userImage ?? "")
        
    }
}

final class FriendListTableViewCellPresenter: UITableViewModels {
    var representable: UITableViewRepresentable {
        return UITableViewContentAssembler<FriendListTableViewCell>(presenter: self)
    }
    
    var userName: String?
    var userImage: String?
    
    init(userDetails: UserDetails) {
        userName = userDetails.userName
        userImage = userDetails.userImage
    }
}
