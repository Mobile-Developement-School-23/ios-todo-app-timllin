//
//  CustomTableView.swift
//  toDoList--2023
//
//  Created by Тимур Калимуллин on 29.06.2023.
//

import UIKit

class SelfSizedTableView: UITableView {
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height
    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
