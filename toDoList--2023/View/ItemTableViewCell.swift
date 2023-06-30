//
//  CustomTableViewCell.swift
//  toDoList--2023
//
//  Created by Тимур Калимуллин on 26.06.2023.
//
// swiftlint:disable all

import UIKit

class ItemTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    lazy var toDoItem: TodoItem? = nil
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMMM"
        return dateFormatter
    }()
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fill
        view.spacing = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isLayoutMarginsRelativeArrangement = true
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        return view
    }()
    
    let button: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 24).isActive = true
        view.widthAnchor.constraint(equalToConstant: 24).isActive = true
        view.clipsToBounds = true
        view.contentVerticalAlignment = .fill
        view.contentHorizontalAlignment = .fill
        return view
    }()
    
    let importantImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        view.widthAnchor.constraint(equalToConstant: 16).isActive = true
        return view
    }()
    
    let textStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .equalSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let textView: UILabel = {
        let view = UILabel()
        view.numberOfLines = 3
        view.backgroundColor = UIColor(named: "backSecondary")
        view.textColor = UIColor(named: "labelPrimary")
        view.font = UIFont.systemFont(ofSize: 17.0)
        return view
    }()
    
    let deadlineView: UILabel = {
        let view = UILabel()
        view.backgroundColor = UIColor(named: "backSecondary")
        view.textColor = UIColor(named: "labelDisable")
        view.font = UIFont.systemFont(ofSize: 15.0)
        view.isHidden = true
        return view
    }()
    
    let chevronImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "chevron.forward")
        view.clipsToBounds = true
        return view
    }()
    
    private func setup() {
        setupStacks()
        self.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
       
    }
    
    private func setupStacks() {
        textStackView.addArrangedSubview(textView)
        textStackView.addArrangedSubview(deadlineView)
        stackView.addArrangedSubview(button)
        stackView.addArrangedSubview(textStackView)
        stackView.addArrangedSubview(chevronImageView)
    }
    
    func configure(with toDoItem: TodoItem){
        self.toDoItem = toDoItem

        let flag = toDoItem.getFlag()
        if flag == true{
            button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            button.tintColor = UIColor(named: "green")
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: toDoItem.getText())) //NSMutableAttributedString(string: toDoItem.getText())
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
            textView.attributedText = attributeString
            textView.textColor = UIColor(named: "labelDisable")
        } else {
            textView.attributedText = NSAttributedString(string: toDoItem.getText())
            button.setImage(UIImage(systemName: "circle"), for: .normal)
            button.tintColor = UIColor(named: "supportSeparator")
            textView.textColor = UIColor(named: "labelPrimary")
        }
        
        let importanceType = toDoItem.getImportanceTypeString()
        switch importanceType{
        case "important":
            textView.set(text: textView.attributedText!, leftIcon:  UIImage(systemName: "exclamationmark.2")?.withTintColor(UIColor(named: "red") ?? .systemRed, renderingMode: .alwaysOriginal))
            if !flag{
                button.setImage(UIImage(systemName: "circle"), for: .normal)
                button.tintColor = UIColor(named: "red")
            }
        case "unimportant":
            textView.set(text: textView.attributedText!, leftIcon:  UIImage(systemName: "arrow.down")?.withTintColor(UIColor(named: "grey") ?? .systemGray, renderingMode: .alwaysOriginal))
        default:
            break
        }
        
        if let deadline = toDoItem.getDeadline(){
            deadlineView.isHidden = false
            deadlineView.set(text: NSAttributedString(string: dateFormatter.string(from: deadline)), leftIcon: UIImage(systemName: "calendar")?.withTintColor(UIColor(named: "grey") ?? .systemGray, renderingMode: .alwaysOriginal))
        } else {
            deadlineView.attributedText = nil
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.toDoItem = nil
        self.textView.attributedText = nil
        self.deadlineView.attributedText = nil
       }
}
