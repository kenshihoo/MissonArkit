//
//  File.swift
//  MissonArkit
//
//  Created by Kenshiro on 2021/02/04.
//

import UIKit
import PGFramework
import RealmSwift

class TopViewController: BaseViewController {

@IBOutlet weak var topMainView: TopMainView!
@IBAction func didTapAddButton(_ sender: UIBarButtonItem) {
    
let alertController: UIAlertController = UIAlertController(title: "todoを追加しますか？", message: nil, preferredStyle: .alert)
let actionButton: UIAlertAction = UIAlertAction(title: "追加", style: .default) { (void) in
let textField = alertController.textFields![0] as UITextField
    
if let text = textField.text{
print("データベースと取得してタスクを追加する処理をここに書く")
let todo = Todo()
todo.text = text

// Get the default Realm
let realm = try! Realm()

// Persist your data easily
try! realm.write {
realm.add(todo)
}

// Query Realm for all dogs less than 2 years old
let todos = realm.objects(Todo.self)
print(todos.count)// => 0 because no dogs have been added to the Realm yet

let todoCount = todos.count
self.topMainView.toolsCount = todoCount
}
}
let cancelButton: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
alertController.addTextField { (textField) in
textField.placeholder = "todeの名前を追加してください"
}
alertController.addAction(actionButton)
alertController.addAction(cancelButton)
present(alertController, animated: true, completion: nil)

}
}

// MARK: - Life cycle
extension TopViewController {
override func viewDidLoad() {
super.viewDidLoad()
print(Realm.Configuration.defaultConfiguration.fileURL!)
}

override func loadView() {
super.loadView()
}
}

// MARK: - Protocol
extension TopViewController {

}

// MARK: - method
extension TopViewController {

}
