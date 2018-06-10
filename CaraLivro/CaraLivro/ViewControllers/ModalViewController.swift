//
//  ModalViewController.swift
//  CaraLivro
//
//  Created by Luzenildo Junior on 10/06/18.
//  Copyright © 2018 Luzenildo Junior. All rights reserved.
//

import UIKit
import SnapKit

protocol ModalViewControllerAction {
    func didTouchCloseButton()
}

final class ModalViewController: UIViewController, Storyboarded {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    var delegate: ModalViewControllerAction?
    weak var viewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureModal()
        setupLayout()
    }

    private func configureModal() {
        guard let viewController = self.viewController else {
            return
        }
        addChildViewController(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupLayout() {
        containerView.layer.cornerRadius = 30

        containerView.layer.shadowOffset = CGSize(width: 6, height: 5)
        containerView.layer.shadowOpacity = 0.29
        containerView.layer.shadowRadius = 7
    }

    func modifyBottomContraint(value: CGFloat) {
        bottomConstraint.constant += value
    }

    @IBAction func didTouchFecharButton(_ sender: Any) {
        viewController?.dismiss(animated: false, completion: nil)
        viewController = nil
        self.dismiss(animated: false, completion: nil)
        delegate?.didTouchCloseButton()
    }
}
