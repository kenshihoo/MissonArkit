//
//  ViewController.swift
//  MissonArkit
//
//  Created by Kenshiro on 2021/01/16.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    var tapSceen:[CGPoint] = []
    var tapcount = -1
    
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
    
        //上記まででARSCNViewの設定と平面検出ができるようになっている//

    
    
    //画面がタップされた場合の処理
    override func touchesBegan(_ touches: Set<UITouch>, with event:UIEvent?) {
        
        //複数タッチの受信を可能にする
        sceneView.isMultipleTouchEnabled = true
        
        //タップされた位置の座標を保存する
        for (touch) in touches{
            
            let point = touch.location(in: sceneView)
                tapSceen.append(point)
            tapcount += 1
            
            //更にfor文
            for (index,_)  in tapSceen.enumerated() {
                //タップされた位置のARアンカーを探す(タップされた2Dの座標に合う3Dの平面があるかを判定)P41参照
                let hitTest = sceneView.hitTest(tapSceen[tapcount], types:.existingPlaneUsingExtent)
                //タップした位置に合う面を検出できていた場合
                if !hitTest.isEmpty {
                //アンカーを追加(タップされた位置の座標をARアンカーとして追加)
                let anchor = ARAnchor(transform: hitTest[index].worldTransform)
                //シーンにARAnchorを追加。
                sceneView.session.add(anchor: anchor)
            }
            }
        }
    }
    
    // シーンにARAnchorが追加されたときの処理
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode,for anchor: ARAnchor) {
    guard !(anchor is ARPlaneAnchor) else { return }
    // 球のノードを作成
    let sphereNode = SCNNode()
    // ノードにGeometryとTransform を設定
    sphereNode.geometry = SCNSphere(radius: 0.05)
    //sphereNode.position.y += Float(0.05)
        
    //ノードの設置位置を決める
        
    // 検出面の子要素にする
    node.addChildNode(sphereNode)
    }
    
    //オブジェクトが重なったらセッションを停止する(離れている位置が3cm以内)
    func overlap() {
        let firstTap = tapSceen.first
        let lastTap = tapSceen.last
        
        if firstTap?.x == lastTap?.x{
            if firstTap?.y == lastTap?.y {
                //ARセッションを停止
                sceneView.session.pause()
            }
        }
    }

}
