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
        
        //タッチするごとにtouchesBeganが呼ばれるので、その都度.firstを呼べばいい(for文を1つなくせる)
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
         
            //guard節使って3回未満ならbreakとかやるとわかりやすくなりそう
            //3回目以降のタップからセッションを終了するかを判断する
            if tapCount > 2{
                
                if !tapAnchor.isEmpty {

                    //メソッドに切り出せるのでは？(.firstと.lastの部分を引数にすると別の部分でも使える)
                    //三平方の定理を用いて2点間の距離を測定
                    let distanceX = Double((tapAnchor.first!).transform.columns.3.x - (tapAnchor.last!).transform.columns.3.x)
                    
                    let distanceZ = Double((tapAnchor.first!).transform.columns.3.z - (tapAnchor.last!).transform.columns.3.z)
                    
                    let distancetap = sqrt(distanceX*distanceX + distanceZ*distanceZ)
              
                    //メソッドに切り出せるのでは？
                    //2点の距離が3cm以内ならセッション終了させる
                    if distancetap < 0.03{
                        //ARセッションを停止
                        sceneView.session.pause()
                        //画面遷移
                        segueToImageSave()
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
    
    
    //画面遷移(各種変数の値を受け渡す)
    func segueToImageSave (){
        
        self.performSegue(withIdentifier: "toImageSave", sender: nil)
        func  prepare(for segue: UIStoryboardSegue, sender: Any?){
            
            if segue.identifier == "toImageSave" {
                let imageSave = segue.destination as! ImageSave
                //値の受け渡し
                imageSave.tapCount = tapCount
                imageSave.tapAnchor = tapAnchor
            }
        }
    }
}
