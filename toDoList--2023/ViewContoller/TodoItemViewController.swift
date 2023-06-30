//
//  ViewController.swift
//  toDoList--2023
//
//
//
// swiftlint:disable all

import UIKit

class TodoItemViewController: UIViewController, UITextViewDelegate {
    
    private var toDoItem: TodoItem?
    private lazy var itemText: String? = nil
    private lazy var itemImportanceType: TodoItem.Importance? = nil
    private lazy var itemDeadLine: Date? = nil
    private lazy var itemHexCode: String? = nil
    
    //private lazy var kkHeight: CGFloat? = nil
    private lazy var hexColor: UIColor? = nil

    var fileCache = FileCache()
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMMM y"
        return dateFormatter
    }()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = UIColor(named: "backPrimary")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 25, right: 0)
        return view
    }()
    
    private let scrollStackView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = UIColor(named: "backPrimary")
        view.axis = .vertical
        view.spacing = 16
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let navigationBarSubview: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 65
        view.distribution = .equalSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let navigationBarBackButton: UIButton = {
        let view = UIButton()
        view.setTitle("Отменить", for: .normal)
        view.setTitleColor(UIColor(named: "blue"), for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 22).isActive = true
        return view
    }()
    
    private let navigationBarTitle: UILabel = {
        let view = UILabel()
        view.text = "Дело"
        view.font = UIFont.boldSystemFont(ofSize: 17.0)
        view.textColor = UIColor(named: "labelPrimary")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 22).isActive = true
        return view
    }()
    
    private let navigationBarSaveButton: UIButton = {
        let view = UIButton()
        view.setTitle("Cохранить", for: .normal)
        view.setTitleColor(UIColor(named: "labelDisable"), for: .normal)
        view.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 22).isActive = true
        view.isEnabled = false
        return view
    }()
    
    private let subview1: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 120).isActive = true
        view.textContainerInset = UIEdgeInsets(top: 16, left: 12, bottom: 12, right: 12)
        view.layer.cornerRadius = 16
        view.backgroundColor = UIColor(named: "backSecondary")
        view.textColor = UIColor(named: "labelDisable")
        view.font = UIFont.systemFont(ofSize: 17.0)
        view.text = "Что надо сделать?"
        return view
    }()
    
    private let subview2: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = UIColor(named: "backSecondary")
        view.layer.cornerRadius = 16
        view.axis = .vertical
        view.spacing = 0
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isLayoutMarginsRelativeArrangement = true
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        return view
    }()
    
    private let subview2Upper : UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.alignment = .center
        view.heightAnchor.constraint(equalToConstant: 56).isActive = true
        return view
    }()
    
    private let subview2UpperLabel: UILabel = {
        let view = UILabel()
        view.text = "Важность"
        view.font = UIFont.systemFont(ofSize: 17)
        view.textColor = UIColor(named: "labelPrimary")
        return view
    }()
    
    private let subview2SegmentedControl: UISegmentedControl = {
        let items = ["↓", "нет", "❗️❗️"]
        let view = UISegmentedControl(items: items)
        return view
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = UIColor(named: "supportSeparator")
        return view
    }()
    
    private let subview2Lower : UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalCentering
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 56).isActive = true
        return view
    }()
    
    private let subview2LowerLeft : UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return view
    }()
    
    private let subview2LowerLeftLabel: UILabel = {
        let view = UILabel()
        view.text = "Сделать до"
        view.font = UIFont.systemFont(ofSize: 17)
        view.textColor = UIColor(named: "labelPrimary")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let subview2LowerLeftButton: UIButton = {
        let view = UIButton()
        view.setTitle("boba", for: .normal)
        view.setTitleColor(UIColor(named: "blue"), for: .normal)
        view.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private let subview2LowerSwitch: UISwitch = {
        let view = UISwitch()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let separatorCalendar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = UIColor(named: "supportSeparator")
        view.isHidden = true
        return view
    }()
    
    private let subview2Calendar: UIDatePicker = {
        let view = UIDatePicker()
        view.datePickerMode = .date
        view.preferredDatePickerStyle = .inline
        view.timeZone = NSTimeZone.local
        view.backgroundColor = UIColor(named: "backSecondary")
        view.isHidden = true
        return view
    }()
    
    private let subview3: UIButton = {
        let view = UIButton()
        view.setTitle("Удалить", for: .normal)
        view.setTitleColor(UIColor(named: "labelDisable"), for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 56).isActive = true
        view.backgroundColor = UIColor(named: "backSecondary")
        view.layer.cornerRadius = 16
        view.isEnabled = false
        return view
    }()
    
    private let subviewColorWeel : UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalCentering
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 56).isActive = true
        return view
    }()
        
    private let subviewColorWeelLabel: UILabel = {
        let view = UILabel()
        view.text = "Цвет"
        view.font = UIFont.systemFont(ofSize: 17)
        view.textColor = UIColor(named: "labelPrimary")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    private let separatorColorWeel: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = UIColor(named: "supportSeparator")
        return view
    }()
        
    private let colorWeel: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "labelPrimary") //.clear //UIColor(named: "labelPrimary")
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1).isActive = true
        return view
    }()
    
    
    private func setupScrollView() {
        view.backgroundColor = UIColor(named: "backPrimary")
        let margins = view.layoutMarginsGuide
        view.addSubview(scrollView)
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        
        scrollView.addSubview(navigationBarSubview)
        navigationBarSubview.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        navigationBarSubview.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        navigationBarSubview.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 17).isActive = true
        
        scrollView.addSubview(scrollStackView)
        scrollStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        scrollStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        //72
        scrollStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 72).isActive = true
        scrollStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        configureNagigationContainerView()
        configureContainerView()
        
    }
    
    private func configureContainerView() {
        subview1.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = false
        scrollStackView.addArrangedSubview(subview1)
        configureSubview2()
        scrollStackView.addArrangedSubview(subview2)
        scrollStackView.addArrangedSubview(subview3)
       
    }
    
    private func configureNagigationContainerView() {
        navigationBarSubview.addArrangedSubview(navigationBarBackButton)
        navigationBarSubview.addArrangedSubview(navigationBarTitle)
        navigationBarSubview.addArrangedSubview(navigationBarSaveButton)
    }
    
    private func configureSubview2() {
        subview2Upper.addArrangedSubview(subview2UpperLabel)
        subview2Upper.addArrangedSubview(subview2SegmentedControl)
        subview2.addArrangedSubview(subview2Upper)
        subview2.addArrangedSubview(separator)
        
        subviewColorWeel.addArrangedSubview(subviewColorWeelLabel)
        subviewColorWeel.addArrangedSubview(colorWeel)
        subview2.addArrangedSubview(subviewColorWeel)
        subview2.addArrangedSubview(separatorColorWeel)
        
        subview2LowerLeft.addArrangedSubview(subview2LowerLeftLabel)
        subview2LowerLeft.addArrangedSubview(subview2LowerLeftButton)
        
        subview2Lower.addArrangedSubview(subview2LowerLeft)
        subview2Lower.addArrangedSubview(subview2LowerSwitch)
        subview2.addArrangedSubview(subview2Lower)
        
        subview2.addArrangedSubview(separatorCalendar)
        subview2.addArrangedSubview(subview2Calendar)
    }
    
    
    @objc public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(named: "labelDisable") {
            textView.text = ""
            textView.textColor = UIColor(named: "labelPrimary")
        }
    }
    
    @objc public func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty{
            textView.text = "Что надо сделать?"
            textView.textColor = UIColor(named: "labelDisable")
        } else {
            if let color = hexColor {
                textView.textColor = color
            } else {
                textView.textColor = UIColor(named: "labelPrimary")
            }
        }
        
        if textView.textColor == UIColor(named: "labelDisable") {
            navigationBarSaveButton.setTitleColor(UIColor(named: "labelDisable"), for: .normal)
            navigationBarSaveButton.isEnabled = false
            subview3.setTitleColor(UIColor(named: "labelDisable"), for: .normal)
            subview3.isEnabled = false
        } else {
            navigationBarSaveButton.setTitleColor(UIColor(named: "blue"), for: .normal)
            navigationBarSaveButton.isEnabled = true
            subview3.setTitleColor(UIColor(named: "red"), for: .normal)
            subview3.isEnabled = true
        }
        updateSubviewHeight(textView)
    }
    
    @objc func cancellButtonValueChanged(_ button: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonValueChanged(_ button: UIButton) {
        if button.isEnabled{
            collateDataItem()
            guard let itemText = itemText, let itemImportanceType = itemImportanceType else { return }
            
            if let item = toDoItem {
                toDoItem = TodoItem(id: item.getId(), text: itemText, importanceType: itemImportanceType, deadline: itemDeadLine, flag: item.getFlag(), creationDate: item.getCreationDate(), changeDate: Date(), hexCode: itemHexCode)
            } else {
                toDoItem = TodoItem(text: itemText, importanceType: itemImportanceType, deadline: itemDeadLine, hexCode: itemHexCode)
            }
            guard let item = toDoItem else { return }
            NotificationCenter.default.post(name: .dataChanged, object: nil, userInfo: ["flag": "add","item": item])
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func segmentedControlValueChanged(_ segmentedControl: UISegmentedControl) {
        let selectedIndex = segmentedControl.selectedSegmentIndex
        let _ = segmentedControl.titleForSegment(at: selectedIndex)
    }
    
    @objc func switchChanged(_ mySwitch: UISwitch) {
        let value = mySwitch.isOn
        
        if value{
            let tommorow: Date = {
                return Calendar.current.date(byAdding: .day, value: 1, to: Date())!
            }()
            let dateString = dateFormatter.string(from: tommorow)
            subview2LowerLeftButton.setTitle(dateString, for: .normal)
            subview2Calendar.setDate(tommorow, animated: true)
        } else {
            separatorCalendar.isHidden = !value
            subview2Calendar.alpha = 1.0
            UIView.animate(withDuration: 0.3, delay: 0, options: .layoutSubviews, animations: {
                self.subview2Calendar.alpha = 0
            }) { (finished) in
                self.subview2Calendar.isHidden = finished
            }
            
        }
        subview2LowerLeftButton.isHidden = !value
        
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate: String = dateFormatter.string(from: sender.date)
        subview2LowerLeftButton.setTitle(selectedDate, for: .normal)
        
    }
    
    @objc func buttonDateTapped() {
        separatorCalendar.isHidden = !separatorCalendar.isHidden
        if subview2Calendar.isHidden{
            subview2Calendar.alpha = 0.0
            subview2Calendar.isHidden = false
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn){
                self.subview2Calendar.alpha = 1.0
            }
        } else {
            subview2Calendar.alpha = 1.0
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                self.subview2Calendar.alpha = 0
            }) { (finished) in
                self.subview2Calendar.isHidden = finished
            }
        }
    }
    
    @objc func subview3ButtonValueChanged(_ button: UIButton) {
        if button.isEnabled{
            guard let item = toDoItem else { return }
            toDoItem = nil
            NotificationCenter.default.post(name: .dataChanged, object: nil, userInfo: ["flag": "delete", "item": item])
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    private func collateDataItem() {
        guard let text = subview1.text else { return }
        itemText = text
        
        let selectedIndex = subview2SegmentedControl.selectedSegmentIndex
        itemImportanceType = TodoItem.Importance.reqular
        switch selectedIndex{
        case 0:
            itemImportanceType = TodoItem.Importance.unimportant
        case 1:
            itemImportanceType = TodoItem.Importance.reqular
        case 2:
            itemImportanceType = TodoItem.Importance.important
        default:
            break
        }
        
        if !subview2LowerLeftButton.isHidden{
            itemDeadLine = subview2Calendar.date
        }
        
    }
    
    private func loadTodoItem(item: TodoItem?) {
        guard let item = item else { return }
        subview1.text = item.getText()
        updateSubviewHeight(subview1)
        
        switch item.getImportanceTypeString() {
        case "unimportant":
            subview2SegmentedControl.selectedSegmentIndex = 0
        case "reqular":
            subview2SegmentedControl.selectedSegmentIndex = 1
        case "important":
            subview2SegmentedControl.selectedSegmentIndex = 2
        default:
            break
        }
        
        if let deadline = item.getDeadline() {
            subview2LowerLeftButton.setTitle(dateFormatter.string(from: deadline), for: .normal)
            subview2Calendar.setDate(deadline, animated: true)
            subview2LowerSwitch.setOn(true, animated: false)
            subview2LowerLeftButton.isHidden = false
        }
        
        if let hexCode = item.getHexCode() {
            itemHexCode = hexCode
            hexColor = UIColor(hex: hexCode)
            subview1.textColor = hexColor
            colorWeel.backgroundColor = hexColor
        } else {
            subview1.textColor = UIColor(named: "labelPrimary")
        }
        
        navigationBarSaveButton.setTitleColor(UIColor(named: "blue"), for: .normal)
        navigationBarSaveButton.isEnabled = true
        subview3.setTitleColor(UIColor(named: "red"), for: .normal)
        subview3.isEnabled = true
    }
    
    public func setToDoItem(item: TodoItem?) {
        guard let item = item else { return }
        toDoItem = item
    }
    
    public func setFileCache(item: FileCache){
        fileCache = item
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            view.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height-view.safeAreaInsets.bottom, right: 0)
        }
        //view.frame.size.height -= view.keyboardLayoutGuide.layoutFrame.size.height
        view.layoutSubviews()
       
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        //view.frame.size.height += view.keyboardLayoutGuide.layoutFrame.size.height
        view.layoutMargins = UIEdgeInsets.zero
        view.layoutSubviews()
    }
    
    @objc func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func colorWellValueChanged(_ button: UIButton) {
        let nextViewController = CustomColorPickerViewController()
        present(nextViewController, animated: true)
    }
    
    @objc func handleMyNotification(_ sender: Notification) {
        guard let userInfo = sender.userInfo,
           let hex = userInfo["key"] as? String,
           let color = userInfo["color"] as? UIColor else { return }
        itemHexCode = hex
        hexColor = color
        colorWeel.backgroundColor = color
        if subview1.text != "Что надо сделать?" {
            subview1.textColor = color
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        loadTodoItem(item: toDoItem)
        registerForKeyboardNotifications()
        hideKeyboardWhenTappedAround()
    
        navigationBarBackButton.addTarget(self, action: #selector(cancellButtonValueChanged(_ :)), for: .touchUpInside)
        navigationBarSaveButton.addTarget(self, action: #selector(saveButtonValueChanged(_ :)), for: .touchUpInside)
        subview1.delegate = self
        subview2SegmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        subview2LowerSwitch.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        subview2LowerLeftButton.addTarget(self, action: #selector(buttonDateTapped), for: .touchUpInside)
        subview2Calendar.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        subview3.addTarget(self, action: #selector(subview3ButtonValueChanged(_ :)), for: .touchUpInside)
        
        colorWeel.addTarget(self, action: #selector(colorWellValueChanged(_ :)), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(handleMyNotification(_ :)), name: .colorHasChosen, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .colorHasChosen, object: nil)
        NotificationCenter.default.removeObserver(self, name: .dataChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
        
    }

}

extension UIViewController{
    public func updateSubviewHeight(_ textView: UITextView) {
        let minHeight = 120
        let contentHeiht = textView.contentSize.height
        textView.constraints[0].constant = max(CGFloat(minHeight), contentHeiht)
        textView.layoutIfNeeded()
    }
}

extension TodoItemViewController{
    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        subview1.endEditing(true)
    }
    
    @objc func orientationDidChange() {
        if UIDevice.current.orientation.isLandscape {
            subview2.isHidden = true
            subview3.isHidden = true
        } else {
            subview2.isHidden = false
            subview3.isHidden = false           
        }
        subview1.layoutIfNeeded()
    }
}
