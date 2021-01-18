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
    
    var tapCount = 0
    var tapPos = CGPoint(x: 0, y: 0)
    var startPos = float3(0,0,0)
    var currentPos = float3(0,0,0)
    
    // 球を描画するメソッド
    func putSphere(at pos: float3) {
            
    let node = SCNNode()
                
    //geometryを作成（半径と配置位置を設定）
    node.geometry = SCNSphere(radius:0.003)
    node.position = SCNVector3(pos.x, pos.y, pos.z)
                
    self.sceneView.scene.rootNode.addChildNode(node)
    }
        
    // 直線を描画するメソッド
    func drawLine(from : SCNVector3, to : SCNVector3) -> SCNNode{
        // 直線のGeometryを作成
        let source = SCNGeometrySource(vertices: [from, to])
        let element = SCNGeometryElement(data: Data.init(bytes: [0, 1]),primitiveType: .line,primitiveCount:1,bytesPerIndex: 1)
        let geometry = SCNGeometry(sources: [source], elements:[element])
        
        // 直線ノードの作成
        let node = SCNNode()
        
        node.geometry = geometry
        node.geometry?.materials.first?.diffuse.contents = UIColor.white
        
        return node
    }
        
    
    //画面がタップされたときの処理
    override func touchesBegan(_ touches: Set<UITouch>, with event:UIEvent?) {
        
        // タップが1回目の場合
        if tapCount == 0{
            
            tapCount = +1
            
            // 最初にタップした座標を取り出す
            guard let firsTouch = touches.first else {return}
            
            // タップした座標をスクリーン座標に変換する
            let touchPos = firsTouch.location(in: sceneView)
            tapPos = touchPos
            
            // タップされた位置のARアンカーを探す
            let hitTest = sceneView.hitTest(touchPos, types:.existingPlaneUsingExtent)
                if !hitTest.isEmpty {
                    
                //タップした箇所が取得できていればアンカーを追加
                let anchor = ARAnchor(transform: hitTest.first!.worldTransform)
                    
                //シーンにARAnchorを追加
                sceneView.session.add(anchor: anchor)
                    
                //startPosにアンカーを代入
                startPos = anchor as! float3
                    
                // タップされた位置を取得する（面との当たり判定）
                let hitResults = sceneView.hitTest(tapPos, types:[.existingPlaneUsingExtent])
                    
                // 結果取得に成功しているかどうか
                if !hitResults.isEmpty {
                    if let hitTResult = hitResults.first {
                            
                        // 実世界の座標をSCNVector3で返す
                        currentPos = float3(hitTResult.worldTransform.columns.3.x,hitTResult.worldTransform.columns.3.y,hitTResult.worldTransform.columns.3.z)}
                    
                // 球の配置
                putSphere(at:currentPos)
                }
            }
        
        //2回目以降のタップの場合
        else{tapCount = +1
            
                // 球の配置
                putSphere(at:currentPos)
                
                //線状のオブジェクトを配置（1度目のタップと2度目のタップの間に配置）
                let lineNode = drawLine(from:SCNVector3(startPos),to:SCNVector3(currentPos))
                
                sceneView.scene.rootNode.addChildNode(lineNode)
            }
        }
    }
}
