//
//  CustomColorPickerViewController.swift
//  toDoList--2023
//
//  Created by Тимур Калимуллин on 22.06.2023.
//
// swiftlint:disable all

import UIKit

class CustomColorPickerViewController: UIViewController {
    private var color: UIColor? = nil
    private let colorPallet: ColorPickerView = {
        let view = ColorPickerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        return view
    }()

    private let colorWindow: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        view.widthAnchor.constraint(equalToConstant: 60).isActive = true
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        return view
    }()

    private let colorCode: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        view.backgroundColor = UIColor(named: "backSecondary")
        view.textAlignment = .left
        view.layer.cornerRadius = 16
        return view
    }()

    private let separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = UIColor.systemGray
        return view
    }()

    private let slider: UISlider = {
        let view = UISlider()
        view.minimumValue = 0
        view.maximumValue = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        view.value = 1
        view.heightAnchor.constraint(equalToConstant: 10).isActive = true
        return view
    }()

    private let closeButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor(named: "backSecondary")
        view.layer.cornerRadius = 16
        view.setImage(UIImage(systemName: "xmark"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 25).isActive = true
        view.widthAnchor.constraint(equalToConstant: 25).isActive = true
        return view
    }()

    @objc func handleMyNotification(_ sender: Notification) {
        guard let color = colorPallet.chosenColor else { return }
        updateColor(color)
    }

    @objc func sliderValueDidChange(_ slider: UISlider) {
        let sliderValue = slider.value
        let oldColor = colorWindow.backgroundColor?.rgba
        guard let oldColor = oldColor else { return }
        let newColor = UIColor(red: oldColor.0, green: oldColor.1, blue: oldColor.2, alpha: CGFloat(sliderValue))
       updateColor(newColor)
    }

    @objc func buttonValueDidChange(_ slider: UISlider) {
        dismiss(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backPrimary")
        view.addSubview(closeButton)
        view.addSubview(colorPallet)
        view.addSubview(colorWindow)
        view.addSubview(separator)
        view.addSubview(colorCode)
        view.addSubview(slider)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            colorWindow.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            colorWindow.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            colorCode.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            colorCode.leadingAnchor.constraint(equalTo: colorWindow.trailingAnchor, constant: 32),
            colorCode.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            separator.topAnchor.constraint(equalTo: colorWindow.bottomAnchor, constant: 32),
            separator.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            separator.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            slider.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            slider.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            slider.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            colorPallet.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 32),
            colorPallet.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: -25),
            colorPallet.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            colorPallet.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15)
            ])
        NotificationCenter.default.addObserver(self, selector: #selector(handleMyNotification(_ :)), name: .colorChanged, object: nil)
        slider.addTarget(self, action: #selector(sliderValueDidChange(_ :)), for: .valueChanged)
        closeButton.addTarget(self, action: #selector(buttonValueDidChange(_ :)), for: .touchUpInside)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .colorChanged, object: nil)

    }
}

extension CustomColorPickerViewController {
    private func toHexCode(_ withcolor: UIColor) -> String? {
        let components = withcolor.rgba
        let red = components.0
        let green = components.1
        let blue = components.2
        let alpha = components.3

        let hexCode = String(format: "#%02lX%02lX%02lX%02X", lroundf(Float(red * 255)), lroundf(Float(green * 255)), lroundf(Float(blue * 255)), lroundf(Float(alpha * 255)))

        return hexCode
    }
    private func updateColor(_ color: UIColor) {
        colorWindow.backgroundColor = color
        guard let hexCode = toHexCode(color) else { return }
        colorCode.text = hexCode
        NotificationCenter.default.post(name: .colorHasChosen, object: nil, userInfo: ["key": hexCode, "color": color])
    }
}
