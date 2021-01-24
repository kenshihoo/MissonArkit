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
    
    var tapCount = 0
    var tapAnchor : [ARAnchor] = []
    var distancePoint : [Double] = []
    
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
    
        //<上記まででARSCNViewの設定と平面検出ができるようになっている>

    
    
    //画面がタップされた場合の処理
    override func touchesBegan(_ touches: Set<UITouch>, with event:UIEvent?) {
        
        //複数タッチの受信を可能にする
        sceneView.isMultipleTouchEnabled = true
        
        //タップされた位置のARanchorを保存する
        for (touch) in touches{
            
            tapCount += 1
            
            //スクリーン座標に変換
            let point = touch.location(in: sceneView)
            
            
            //スクリーン座標に符合するARanchorを保存
            let hitPoint = sceneView.hitTest(point, types:.existingPlaneUsingExtent)
            
            if !hitPoint.isEmpty {
            let hitAnchor = ARAnchor(transform: hitPoint.first!.worldTransform)
            tapAnchor.append(hitAnchor)
         
            //3回目以降のタップからセッションを終了するかを判断する
            if tapCount > 2{
                
                if !tapAnchor.isEmpty {

                    //三平方の定理を用いて2点間の距離を測定
                    let distanceX = Double((tapAnchor.first!).transform.columns.3.x - (tapAnchor.last!).transform.columns.3.x)
                    
                    let distanceZ = Double((tapAnchor.first!).transform.columns.3.z - (tapAnchor.last!).transform.columns.3.z)
                    
                    let distancetap = sqrt(distanceX*distanceX + distanceZ*distanceZ)
              
                    //2点の距離が3cm以内ならセッション終了させる
                    if distancetap < 0.03{
                        //ARセッションを停止
                        sceneView.session.pause()
                        //各オブジェクト同士の距離を算出
                        measurePoints()
                
                //動作確認用のprint
                print("完了")
                print(distancetap)
                                    }
                                }
                            }
                        }
                    }
        
        //オブジェクトを設置
        //シーンにARAnchorを追加。平面が見つかったときと同様の扱いになり(renderer(_:didAdd:for)を呼べる)
        sceneView.session.add(anchor: (tapAnchor)[tapCount - 1])
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
    
    
    //各オブジェクト間の距離を測定する
    func measurePoints()  {
        var measureCount = 1
        
        for i in 0...tapCount - 2 {
            
            if measureCount == i{
                measureCount = 0
            }
           
                let distanceX = Double((tapAnchor[i]).transform.columns.3.x - (tapAnchor[measureCount]).transform.columns.3.x)
            
                let distanceZ = Double((tapAnchor[i]).transform.columns.3.z - (tapAnchor[measureCount]).transform.columns.3.z)
            
                let distancetap = sqrt(distanceX*distanceX + distanceZ*distanceZ)
                
            distancePoint.append(distancetap)
            
           measureCount += 1
        }
        //動作確認用のprint
        print(distancePoint)
    }
}
