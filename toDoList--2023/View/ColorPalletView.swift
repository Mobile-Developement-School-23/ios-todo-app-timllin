//
//  ColorPalletView.swift
//  toDoList--2023
//
//  Created by Тимур Калимуллин on 22.06.2023.
//

import UIKit


class ColorPickerView : UIView {
    public var chosenColor: UIColor? = nil
    var onColorDidChange: ((_ color: UIColor) -> ())?

    let saturationExponentTop:Float = 2.0
    let saturationExponentBottom:Float = 1.3

    //let grayPaletteHeightFactor: CGFloat = 0.1
    var rect_grayPalette = CGRect.zero
    var rect_mainPalette = CGRect.zero

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
        let touchGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.touchedColor(gestureRecognizer:)))
        touchGesture.minimumPressDuration = 0
        touchGesture.allowableMovement = CGFloat.greatestFiniteMagnitude
        self.addGestureRecognizer(touchGesture)
    }



    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()

        //rect_grayPalette = CGRect(x: 0, y: 0, width: rect.width, height: rect.height * grayPaletteHeightFactor)
        rect_mainPalette = CGRect(x: 0, y: 0,
                                  width: rect.width, height: rect.height)

        // gray palette
//        for y in stride(from: CGFloat(0), to: rect_grayPalette.height, by: elementSize) {
//
//            for x in stride(from: (0 as CGFloat), to: rect_grayPalette.width, by: elementSize) {
//                let hue = x / rect_grayPalette.width
//
//                let color = UIColor(white: hue, alpha: 1.0)
//
//                context!.setFillColor(color.cgColor)
//                context!.fill(CGRect(x:x, y:y, width:elementSize, height:elementSize))
//            }
//        }

        // main palette
        for y in stride(from: CGFloat(0), to: rect_mainPalette.height, by: elementSize) {

            var saturation = y < rect_mainPalette.height / 2.0 ? CGFloat(2 * y) / rect_mainPalette.height : 2.0 * CGFloat(rect_mainPalette.height - y) / rect_mainPalette.height
            saturation = CGFloat(powf(Float(saturation), y < rect_mainPalette.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
            let brightness = y < rect_mainPalette.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(rect_mainPalette.height - y) / rect_mainPalette.height

            for x in stride(from: (0 as CGFloat), to: rect_mainPalette.width, by: elementSize) {
                let hue = x / rect_mainPalette.width

                let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)

                context!.setFillColor(color.cgColor)
                context!.fill(CGRect(x:x, y: y + rect_mainPalette.origin.y,
                                     width: elementSize, height: elementSize))
            }
        }
    }



    func getColorAtPoint(point: CGPoint) -> UIColor
        {
        var roundedPoint = CGPoint(x:elementSize * CGFloat(Int(point.x / elementSize)),
                                   y:elementSize * CGFloat(Int(point.y / elementSize)))

        let hue = roundedPoint.x / self.bounds.width


        // main palette
                     // offset point, because rect_mainPalette.origin.y is not 0
        roundedPoint.y -= rect_mainPalette.origin.y

        var saturation = roundedPoint.y < rect_mainPalette.height / 2.0 ? CGFloat(2 * roundedPoint.y) / rect_mainPalette.height : 2.0 * CGFloat(rect_mainPalette.height - roundedPoint.y) / rect_mainPalette.height

        saturation = CGFloat(powf(Float(saturation), roundedPoint.y < rect_mainPalette.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
        let brightness = roundedPoint.y < rect_mainPalette.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(rect_mainPalette.height - roundedPoint.y) / rect_mainPalette.height

        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }


    @objc func touchedColor(gestureRecognizer: UILongPressGestureRecognizer){
        let point = gestureRecognizer.location(in: self)
        let color = getColorAtPoint(point: point)
        chosenColor = color
        NotificationCenter.default.post(name: .colorChanged, object: nil)
        self.onColorDidChange?(color)
        }
    }
