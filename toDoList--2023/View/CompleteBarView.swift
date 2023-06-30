//
//  CompleteBarView.swift
//  toDoList--2023
//
//  Created by Тимур Калимуллин on 26.06.2023.
//

import UIKit

class CompleteBarView: UIView {
    let mainStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .equalSpacing
        view.spacing = 50
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isLayoutMarginsRelativeArrangement = true
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        return view
    }()

    let label: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 15)
        view.textColor = UIColor(named: "labelSecondary")
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        view.text = "5"
        return view
    }()

    let button: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Показать", for: .normal)
        view.setTitleColor(UIColor(named: "blue"), for: .normal)
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        view.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        return view
    }()

    private func setupView() {
        self.addSubview(mainStackView)
        setupLayout()
        mainStackView.addArrangedSubview(label)
        mainStackView.addArrangedSubview(button)
    }

    private func setupLayout() {
        mainStackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
}
