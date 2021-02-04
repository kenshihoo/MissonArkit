//
//  ImageSave.swift
//  MissonArkit
//
//  Created by Kenshiro on 2021/01/26.
//

import Foundation
import UIKit
import SceneKit
import ARKit

class ImageSave: UIViewController, ARSCNViewDelegate {

    var tapCount :Int!
    var tapAnchor : [ARAnchor?] = []
    @IBOutlet weak var drawView: DrawImage!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //DrawImageに値を渡す
        self.drawView.tapCount = tapCount
        self.drawView.tapAnchor = tapAnchor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Screen Size の取得
        let screenWidth = self.drawView.bounds.width
        let screenHeight = self.drawView.bounds.height
         
        let planeDraw = DrawImage(frame: CGRect(x: 0, y: 0,width: screenWidth, height: screenHeight))
        
        
        self.drawView.addSubview(planeDraw)
        
        // 不透明にしない（透明）
        planeDraw.isOpaque = false
        // 背景色
        self.drawView.backgroundColor = UIColor.orange
    }
    
    //保存ボタンが押されたら画像として保存する
    @IBAction func saveButton(_ sender: Any) {
    }
    
}
