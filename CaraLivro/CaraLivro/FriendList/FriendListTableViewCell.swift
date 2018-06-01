//
//  FriendListTableViewCell.swift
//  CaraLivro
//
//  Created by Luan Lima on 30/05/18.
//  Copyright © 2018 Luan Lima. All rights reserved.
//

import UIKit

enum ListType {
    case friends, groups
}

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
        if presenter?.listType == .groups {
            userImage.isHidden = true
        }
    }
}

final class FriendListTableViewCellPresenter: UITableViewModels {
    var representable: UITableViewRepresentable {
        return UITableViewContentAssembler<FriendListTableViewCell>(presenter: self)
    }
    
    var userName: String?
    var userImage: String?
    var listType: ListType?
    
    init(userDetails: UserDetails) {
        userName = userDetails.userName
        userImage = userDetails.userImage
        listType = .friends
    }

    init(groupDetails: GroupsDetails) {
        userName = groupDetails.groupName
        listType = .groups
    }
}
