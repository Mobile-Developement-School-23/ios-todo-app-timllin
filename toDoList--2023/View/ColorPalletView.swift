//
//  ColorPalletView.swift
//  toDoList--2023
//
//  Created by Тимур Калимуллин on 22.06.2023.
//
// swiftlint:disable all

import UIKit

class ColorPickerView: UIView {
    public var chosenColor: UIColor? = nil
    var onColorDidChange: ((_ color: UIColor) -> ())?

    let saturationExponentTop: Float = 2.0
    let saturationExponentBottom: Float = 1.3

    var rectGrayPalette = CGRect.zero
    var rectMainPalette = CGRect.zero

    // adjustable
    var elementSize: CGFloat = 10.0 {
        didSet {
        setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        self.clipsToBounds = true
        let touchGesture = UILongPressGestureRecognizer(target: self,
                                                        action: #selector(self.touchedColor(gestureRecognizer:)))
        touchGesture.minimumPressDuration = 0
        touchGesture.allowableMovement = CGFloat.greatestFiniteMagnitude
        self.addGestureRecognizer(touchGesture)
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()

        rectMainPalette = CGRect(x: 0, y: 0,
                                  width: rect.width, height: rect.height)

        // main palette
        for y in stride(from: CGFloat(0), to: rectMainPalette.height, by: elementSize) {

            var saturation = y < rectMainPalette.height / 2.0 ? CGFloat(2 * y) / rectMainPalette.height : 2.0 * CGFloat(rectMainPalette.height - y) / rectMainPalette.height
            saturation = CGFloat(powf(Float(saturation), y < rectMainPalette.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
            let brightness = y < rectMainPalette.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(rectMainPalette.height - y) / rectMainPalette.height

            for x in stride(from: (0 as CGFloat), to: rectMainPalette.width, by: elementSize) {
                let hue = x / rectMainPalette.width

                let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)

                context!.setFillColor(color.cgColor)
                context!.fill(CGRect(x:x, y: y + rectMainPalette.origin.y,
                                     width: elementSize, height: elementSize))
            }
        }
    }

    func getColorAtPoint(point: CGPoint) -> UIColor {
        var roundedPoint = CGPoint(x: elementSize * CGFloat(Int(point.x / elementSize)),
                                   y: elementSize * CGFloat(Int(point.y / elementSize)))

        let hue = roundedPoint.x / self.bounds.width

        roundedPoint.y -= rectMainPalette.origin.y

        var saturation = roundedPoint.y < rectMainPalette.height / 2.0 ? CGFloat(2 * roundedPoint.y) / rectMainPalette.height : 2.0 * CGFloat(rectMainPalette.height - roundedPoint.y) / rectMainPalette.height

        saturation = CGFloat(powf(Float(saturation), roundedPoint.y < rectMainPalette.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
        let brightness = roundedPoint.y < rectMainPalette.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(rectMainPalette.height - roundedPoint.y) / rectMainPalette.height

        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }

    @objc func touchedColor(gestureRecognizer: UILongPressGestureRecognizer) {
        let point = gestureRecognizer.location(in: self)
        let color = getColorAtPoint(point: point)
        chosenColor = color
        NotificationCenter.default.post(name: .colorChanged, object: nil)
        self.onColorDidChange?(color)
        }
    }
