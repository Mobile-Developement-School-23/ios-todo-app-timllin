//
//  FileCacheViewController.swift
//  toDoList--2023
//
//  Created by Тимур Калимуллин on 20.06.2023.
//

import UIKit

class MainViewController: UIViewController {
    private lazy var fileCache = FileCache()
    private lazy var networkWorker = DefaultNetworkingService()
    //private lazy var sqlDatabase = SQLDataStorage()

    private var currentCell: ItemTableViewCell?
    private let transitionDelegate: UIViewControllerTransitioningDelegate = TransitioninDelegate()
    private var keys: [String] {
        return Array(fileCache.toDoItemDict.keys).sorted(by: { fileCache.toDoItemDict[$0]!.getCreationDate() > fileCache.toDoItemDict[$1]!.getCreationDate() })
    }

    private var filterKeys: [String] {
        let filteredDict = fileCache.toDoItemDict.filter { $0.value.getFlag() == false}
        return Array(filteredDict.keys).sorted(by: { filteredDict[$0]!.getCreationDate() > filteredDict[$1]!.getCreationDate() })
    }

    private var flag = true

    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = UIColor(named: "backPrimary")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isScrollEnabled = true
        return view
    }()

    let tableView: SelfSizedTableView = {
        let view = SelfSizedTableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "backSecondary")
        view.layer.cornerRadius = 16
        view.alwaysBounceVertical = false
        view.isScrollEnabled = false
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()

    let completeBar: CompleteBarView = {
        let view = CompleteBarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let newItemButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 44).isActive = true
        view.widthAnchor.constraint(equalToConstant: 44).isActive = true
        view.setImage(UIImage(systemName: "plus.circle.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        view.tintColor = UIColor(named: "blue")
        view.contentVerticalAlignment = .fill
        view.contentHorizontalAlignment = .fill
        view.layer.cornerRadius = view.frame.size.width / 2
        return view
    }()

    private func setup() {
        view.backgroundColor = UIColor(named: "backPrimary")
        navigationItem.title = "Мои дела"
        navigationController?.navigationBar.prefersLargeTitles = true
        loadData()

        let margins = view.layoutMarginsGuide
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        scrollView.addSubview(completeBar)
        completeBar.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        completeBar.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        completeBar.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true

        scrollView.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: completeBar.bottomAnchor, constant: 12).isActive = true
        tableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: "Cell")

        view.addSubview(newItemButton)
        newItemButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -45).isActive = true
        newItemButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getDataFromNetwork()
        newItemButton.addTarget(self, action: #selector(newItemButtonValue(_ :)), for: .touchUpInside)
        completeBar.button.addTarget(self, action: #selector(showHiddenButtonTapped(_ :)), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(handleMyNotification(_ :)), name: .dataChanged, object: nil)
        // NotificationCenter.default.addObserver(self, selector: #selector(hadleDirtyNetwork(_ :)), name: .idDirtyNetwork, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .dataChanged, object: nil)
        // NotificationCenter.default.removeObserver(self, name: .idDirtyNetwork, object: nil)
    }
}

extension MainViewController {
    private func countDoneItems() -> Int {
            return fileCache.toDoItemDict.map { $0.value }.filter { $0.getFlag() == true }.count
    }

    private func loadData() {
        fileCache.loadSQL()
        // fileCache.loadCoreData()
        completeBar.label.text = "Выполнено - \(String(describing: countDoneItems()))"
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let counter = flag ? (fileCache.toDoItemDict.count - countDoneItems()) : fileCache.toDoItemDict.count
        return counter
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ItemTableViewCell else { fatalError() }
        cell.backgroundColor = UIColor(named: "backSecondary")
        if flag {
            let filteredDict = fileCache.toDoItemDict.filter {$0.value.getFlag() == false }
            if let item = filteredDict[filterKeys[indexPath.row]] {
                cell.configure(with: item)
            }
        } else {
            if let item = fileCache.toDoItemDict[keys[indexPath.row]] {
                cell.configure(with: item)
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let todoItemViewController = TodoItemViewController()

        if flag {
            guard let item = fileCache.toDoItemDict[filterKeys[indexPath.row]] else { return }
            todoItemViewController.setToDoItem(item: item)
            todoItemViewController.setFileCache(item: fileCache)
        } else {
            guard let item = fileCache.toDoItemDict[keys[indexPath.row]] else { return }
            todoItemViewController.setToDoItem(item: item)
            todoItemViewController.setFileCache(item: fileCache)
        }
        if let cell = tableView.cellForRow(at: indexPath) as? ItemTableViewCell {
            self.currentCell = cell
        }
        todoItemViewController.modalPresentationStyle = .fullScreen
        let transitionDelegate = self.transitionDelegate
        todoItemViewController.transitioningDelegate = transitionDelegate
        present(todoItemViewController, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: nil) { [weak self] (_, _, completionHandler) in
            self?.handleMakeDone(with: indexPath)
            completionHandler(true)
        }
        action.image =  UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        action.backgroundColor = UIColor(named: "green")
        return UISwipeActionsConfiguration(actions: [action])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, completionHandler) in
            self?.handleMoveToTrash(with: indexPath)
            completionHandler(true)
        }
        action.image =  UIImage(systemName: "trash.square.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        action.backgroundColor = UIColor(named: "red")
        return UISwipeActionsConfiguration(actions: [action])
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        let button = UIButton()
        button.setTitle("Новое", for: .normal)
        button.setTitleColor(UIColor(named: "labelDisable"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        button.contentHorizontalAlignment = .left
        button.contentVerticalAlignment = .center
        button.addTarget(self, action: #selector(newItemButtonValue(_ :)), for: .touchUpInside)
        footer.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.trailingAnchor.constraint(equalTo: footer.trailingAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: footer.leadingAnchor, constant: 12).isActive = true
        button.topAnchor.constraint(equalTo: footer.topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: footer.bottomAnchor).isActive = true
        return footer
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 56
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        var currentKeys = [String]()
        if flag {
            currentKeys = filterKeys
        } else {
            currentKeys = keys
        }
        guard let item = fileCache.toDoItemDict[currentKeys[indexPath.row]] else { return nil }
        let todoItemViewController = TodoItemViewController()
        todoItemViewController.setFileCache(item: fileCache)
        todoItemViewController.setToDoItem(item: item)
        return UIContextMenuConfiguration(identifier: item.getId() as NSCopying,
                                          previewProvider: { return todoItemViewController })
    }

    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        animator.preferredCommitStyle = .pop
        guard let identifier = configuration.identifier as? String else { return }
        let todoItemViewController = TodoItemViewController()
        todoItemViewController.setFileCache(item: fileCache)
        todoItemViewController.setToDoItem(item: fileCache.toDoItemDict[identifier])

        animator.addAnimations {
            self.present(todoItemViewController, animated: true)
        }
    }
}

extension MainViewController {
    @objc func newItemButtonValue(_ button: UIButton) {
        let todoItemViewController = TodoItemViewController()
        let item: TodoItem? = nil
        todoItemViewController.setToDoItem(item: item)
        todoItemViewController.setFileCache(item: fileCache)
        todoItemViewController.modalPresentationStyle = .popover
        present(todoItemViewController, animated: true, completion: nil)
    }

    @objc func showHiddenButtonTapped(_ button: UIButton) {
        if button.titleLabel?.text == "Показать"{
            self.flag = false
            tableView.reloadData()
            button.setTitle("Скрыть", for: .normal)
        } else {
            self.flag = true
            tableView.reloadData()
            button.setTitle("Показать", for: .normal)
        }
    }

    @objc func handleMyNotification(_ sender: Notification) {
        guard let userInfo = sender.userInfo,
              let operationFlag = userInfo["flag"] as? String,
              let item = userInfo["item"] as? TodoItem else { return }
        if operationFlag == "add"{
            fileCache.add(item: item)
            fileCache.insertUpdateSQL(item: item)
            // fileCache.insertCoreData(item: item)
            postItemNetwork(with: item)
        } else if operationFlag == "change"{
            fileCache.add(item: item)
            fileCache.insertUpdateSQL(item: item)
            // fileCache.updateCoreData(item: item)
            putItemNetwork(with: item)
        } else if operationFlag == "delete" {
            fileCache.delete(item: item)
            fileCache.deleteSQL(item: item)
            // fileCache.deleteCoreData(item: item)
            deleteItemNetwork(with: item)
        }
        tableView.reloadData()
        reloadAndUpdateData()
    }

    @objc func hadleDirtyNetwork(_ sender: Notification) {
        patchDataNetwork(with: fileCache.toDoItemDict.map { $0.value })
        networkWorker.setIsDirty(false)
        reloadAndUpdateData()

    }
}

extension MainViewController {
    private func handleMakeDone(with indexPath: IndexPath) {
        var currentKeys = [String]()
        if flag {
            currentKeys = filterKeys
        } else {
            currentKeys = keys
        }
        if let item = fileCache.toDoItemDict[currentKeys[indexPath.row]] {
            let newItem: TodoItem = TodoItem(id: item.getId(),
                                             text: item.getText(),
                                             importanceType: TodoItem.Importance(rawValue: item.getImportanceTypeString()) ?? .reqular,
                                             deadline: item.getDeadline(),
                                             flag: !item.getFlag(),
                                             creationDate: item.getCreationDate(),
                                             changeDate: item.getChangeDate(),
                                             hexCode: item.getHexCode())
            fileCache.add(item: newItem)
            fileCache.insertUpdateSQL(item: newItem)
            // fileCache.updateCoreData(item: newItem)
            putItemNetwork(with: newItem)
            tableView.reloadData()
            reloadAndUpdateData()
        }
    }

    private func handleMoveToTrash(with indexPath: IndexPath) {
        var currentKeys = [String]()
        if flag {
            currentKeys = filterKeys
        } else {
            currentKeys = keys
        }
        if let item = fileCache.toDoItemDict[currentKeys[indexPath.row]] {
            fileCache.delete(item: item)
            fileCache.deleteSQL(item: item)
            // fileCache.deleteCoreData(item: item)
            deleteItemNetwork(with: item)
            tableView.reloadData()
            reloadAndUpdateData()
        }
    }

    private func reloadAndUpdateData() {
        completeBar.label.text = "Выполнено - \(String(describing: countDoneItems()))"
    }

    private func keysToIndexPath(of keys: [String]) -> [IndexPath] {
        let rangeArray: [Int] = Array(0..<keys.count)
        return rangeArray.map { IndexPath.init(row: $0, section: 0)}
    }
}

extension MainViewController {
    public func getCell() -> ItemTableViewCell? {
        return currentCell
    }

    private func getDataFromNetwork() {
        Task {
            let items = try await networkWorker.getDataFromServer()
            fileCache.deleteAllItems()
            fileCache.updateAllItems(with: items)
            fileCache.insertManySQL(items: items)
            // fileCache.insertManyCoreData(items: items)
            reloadAndUpdateData()
            tableView.reloadData()
        }
    }

    private func patchDataNetwork(with items: [TodoItem]) {
        Task {
            let newiItems = try await networkWorker.updateDataOnServer(items: items)
            fileCache.deleteAllItems()
            fileCache.updateAllItems(with: newiItems)
            fileCache.insertManySQL(items: newiItems)
            // fileCache.insertManyCoreData(items: newiItems)
        }
    }

    private func postItemNetwork(with item: TodoItem) {
        if networkWorker.getIsDirty() {
            dirtyNetwork()
        }
        Task {
            try await networkWorker.postItem(with: item)
        }
    }

    private func putItemNetwork(with item: TodoItem) {
        if networkWorker.getIsDirty() {
            dirtyNetwork()
        }
        Task {
            try await networkWorker.putItem(with: item)
        }
    }

    private func deleteItemNetwork(with item: TodoItem) {
        if networkWorker.getIsDirty() {
            dirtyNetwork()
        }
        Task {
            try await networkWorker.deleteItem(with: item)
        }
    }

    private func dirtyNetwork() {
        patchDataNetwork(with: fileCache.toDoItemDict.map { $0.value })
        networkWorker.setIsDirty(false)
        reloadAndUpdateData()
    }
}
