//
//  SetTest.swift
//  MissonArkit
//
//  Created by Kenshiro on 2021/01/20.
//

import Foundation
import UIKit
import SceneKit
import ARKit

class PrintCoordinate: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self

        sceneView.scene = SCNScene()
    }
    
    //画面が呼ばれる直前の処理
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 特徴点を表示(なくてもいい)
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // ライト追加
        sceneView.autoenablesDefaultLighting = true;
        
        //空間認識をするARWorldTrackingConfigurationをインスタンス化
        let configuration = ARWorldTrackingConfiguration()
        //平面の検出を有効化
        configuration.planeDetection = [.horizontal]
        //ARセッションを開始
        sceneView.session.run(configuration)
    }

    //viewの表示が終了(アプリが閉じられたり)した場合の処理
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //ARセッションを停止
        sceneView.session.pause()
        
    }
    
    
//タップした最初の5つの座標を取得してprintする
var fingers = [String?](repeating: nil, count:5)

override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches{
        let point = touch.location(in: self.view)
        for (index,finger)  in fingers.enumerated() {
            if finger == nil {
                fingers[index] = String(format: "%p", touch)
                print("finger \(index+1): x=\(point.x) , y=\(point.y)")
                break
            }
        }
    }
}
}
