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
    
    var sceneView: ARSCNView!

    var tapCount :Int!
    var tapAnchor : [ARAnchor?] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Screen Size の取得
        let screenWidth = self.view.bounds.width
        let screenHeight = self.view.bounds.height
         
        let planeDraw = DrawImage(frame: CGRect(x: 0, y: 0,width: screenWidth, height: screenHeight))
        self.view.addSubview(planeDraw)
        
        // 不透明にしない（透明）
        planeDraw.isOpaque = false
        // 背景色
        self.view.backgroundColor = UIColor.orange
    }
}
