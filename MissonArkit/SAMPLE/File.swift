////
////  File.swift
////  MissonArkit
////
////  Created by Kenshiro on 2021/02/06.
////
//
//import UIKit
//import PGFramework
//import RealmSwift
//
//protocol TopMainViewDelegate: NSObjectProtocol{
//
//}
//
//extension TopMainViewDelegate {
//}
//
//// MARK: - Property
//class TopMainView: BaseView {
//weak var delegate: TopMainViewDelegate? = nil
//@IBOutlet weak var tableView: UITableView!
//var toolsCount = ""
//}
//
//// MARK: - Life cycle
//extension TopMainView {
//override func awakeFromNib() {
//super.awakeFromNib()
//tableView.dataSource = self
//tableView.delegate  = self
//loadTableViewCellFromXib(tableView: tableView, cellName: "TopTableViewCell")
//}
//
//}
//
//// MARK: - Protocol
//extension TopMainView: UITableViewDataSource {
//func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//return 10
////        return Int(toolsCount)!
//}
//
//func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//let cell = tableView.dequeueReusableCell(withIdentifier: "TopTableViewCell", for: indexPath)
//return cell
//}
//}
//
//extension TopMainView: UITableViewDelegate{
//
//}
//
//// MARK: - method
//extension TopMainView {
//
//}
