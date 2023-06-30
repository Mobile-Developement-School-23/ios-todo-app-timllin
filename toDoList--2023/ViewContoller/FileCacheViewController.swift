//
//  FileCacheViewController.swift
//  toDoList--2023
//
//  Created by Тимур Калимуллин on 20.06.2023.
//

import UIKit

class FileCacheViewController: UIViewController {
    var fileCache = FileCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fileCache.loadJSON(fileName: "testApp.json")
        let item = fileCache.toDoItemDict.first
        view.backgroundColor = UIColor(named: "backPrimary")
        navigationItem.title = "Мои дела"
        navigationController?.navigationBar.prefersLargeTitles = true
        let todoItemViewController = TodoItemViewController()
        todoItemViewController.setToDoItem(item: item?.value)
        todoItemViewController.modalPresentationStyle = .overCurrentContext
        //todoItemViewController.modalTransitionStyle = .crossDissolve
        present(todoItemViewController, animated: true, completion: nil)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
