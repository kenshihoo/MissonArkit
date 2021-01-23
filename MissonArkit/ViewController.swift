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
    var tapAnchor : [ARAnchor] = []
    
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
            
            //スクリーン座標を保存
            let point = touch.location(in: sceneView)
                tapSceen.append(point)
            
            //スクリーン座標に符合するARanchorを保存
            let hitPoint = sceneView.hitTest(point, types:.existingPlaneUsingExtent)
            
        
            if !hitPoint.isEmpty {
            let hitAnchor = ARAnchor(transform: hitPoint.first!.worldTransform)
            tapAnchor.append(hitAnchor)
         
            
            //2回目以上のタップからセッションを終了するかを判断する
            if tapSceen.count > 1{
                
                if !tapAnchor.isEmpty {

                    //三平方の定理を用いて2点間の距離を測定
                    let distanceX = Double((tapAnchor.first!).transform.columns.3.x - (tapAnchor.last!).transform.columns.3.x)
                    
                    let distanceZ = Double((tapAnchor.first!).transform.columns.3.z - (tapAnchor.last!).transform.columns.3.z)
                    
                    let distancetap = sqrt(distanceX*distanceX + distanceZ*distanceZ)
                    
                    print(distancetap)
              
            //2点の距離が3cm以内ならセッション終了させる(100倍でcm)
            if distancetap < 0.03{
                //ARセッションを停止
                sceneView.session.pause()
                print("完了")
                print(distancetap)
                                    }
                                }
                            }
                        }
                    }
        //オブジェクトを設置する
        guard let firstTouch = touches.first else {return}
        
        // タップした座標をスクリーン座標に変換する
        let touchPos = firstTouch.location(in: sceneView)
        
        // タップされた位置のARアンカーを探す(タップされた2Dの座標に合う3Dの平面があるかを判定)P41参照
        let hitTest = sceneView.hitTest(touchPos, types:.existingPlaneUsingExtent)
            
            //タップした位置に合う面を検出できていた場合
            if !hitTest.isEmpty {
            //アンカーを追加(タップされた位置の座標をARアンカーとして追加)
            let anchor = ARAnchor(transform: hitTest.first!.worldTransform)
            //シーンにARAnchorを追加。平面が見つかったときと同様の扱いになる(renderer(_:didAdd:for)を呼べる)
            sceneView.session.add(anchor: anchor)
            }
    }
    
    // シーンにARAnchorが追加されたときの処理
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode,for anchor: ARAnchor) {
    guard !(anchor is ARPlaneAnchor) else { return }
    // 球のノードを作成
    let sphereNode = SCNNode()
    // ノードにGeometryとTransform を設定
    sphereNode.geometry = SCNSphere(radius: 0.01)
    //設置地の高さ(y座標)を0にする
    sphereNode.position.y = 0
    // 検出面の子要素にする
    node.addChildNode(sphereNode)
    }
}
