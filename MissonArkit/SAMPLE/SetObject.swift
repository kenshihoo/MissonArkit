//
//  SetObject.swift
//  MissonArkit
//
//  Created by Kenshiro on 2021/01/16.
//

//タップした位置に球の設置が可能

import UIKit
import SceneKit
import ARKit

class SetObject: UIViewController, ARSCNViewDelegate {

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
        // 最初にタップした座標を取り出す
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
        
        //hitTestが現在非推奨のメソッドのため、raycastQuerを使うべきだが、変数anchorの設定がわからず挫折…
        //let results = [sceneView.raycastQuery(from: touchPos,allowing: .existingPlane,alignment: .any)]
        //let anchor = ARAnchor(transform: results.first??.accessibilityActivationPoint))
        //sceneView.session.add(anchor: anchor)
    }
    
    // シーンにARAnchorが追加されたときの処理
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode,for anchor: ARAnchor) {
    guard !(anchor is ARPlaneAnchor) else { return }
    // 球のノードを作成
    let sphereNode = SCNNode()
    // ノードにGeometryとTransform を設定
    sphereNode.geometry = SCNSphere(radius: 0.05)
    sphereNode.position.y += Float(0.05)
    // 検出面の子要素にする
    node.addChildNode(sphereNode)
    }
    
   
    
    
    
    
    
                            //Appendix
//    //画面がタップされた場合の処理
//    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
//
//        // sceneView上でタップした座標を検出
//        let tapPoint = sender.location(in: sceneView)
//        let results = [sceneView.raycastQuery(from: tapPoint,allowing: .estimatedPlane,alignment: .any)]
//
//        let hitPoint = results.first
//        // 現実世界の座標に変換
//        let point = SCNVector3()
//
//        //箱状のオブジェクトを設置
//        let box = SCNBox(width: 0.01, height: 0.01, length: 0.01, chamferRadius: 0)
//        let node = SCNNode(geometry: box)
//        sceneView.scene.rootNode.addChildNode(node)
//
//    }
    
    
    
    
//    //平面を検出したら、平面に沿って板状のオブジェクトを表示
//    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//
//        //平面を表す情報を持つARPlaneAnchorにキャスト(これにより、中心座標を表すcenterと平面の幅長さを表すextentが使える)
//        guard let planeAnchor = anchor as? ARPlaneAnchor else
//        {fatalError()}
//
//        // ノード作成
//        let planeNode = SCNNode()
//
//        // ジオメトリの作成(ARPlaneAnchorに格納されている検出した平面の大きさに合わせる)
//        let geometry = SCNPlane(width: CGFloat(planeAnchor.extent.x),
//        height: CGFloat(planeAnchor.extent.z))
//        //色と透明度を設定
//        geometry.materials.first?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
//
//        // ノードにGeometryとTransform を指定
//        planeNode.geometry = geometry
//        //SceneKitの座標系をARKitの座標系に変換(ベクトルの回転)
//        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2.0, 1,
//        0, 0)
//        // 検出したアンカーに対応するノードに子ノードとして持たせる
//        node.addChildNode(planeNode)
//        }
//
//    // 平面が更新(シーン中のアンカー情報が更新)されたときに呼ばれる
//    func renderer(_ renderer: SCNSceneRenderer, didUpdate node:SCNNode, for anchor: ARAnchor) {
//
//        guard let planeAnchor = anchor as? ARPlaneAnchor else{
//        fatalError()
//        }
//        //現在表示している平面ノードを取り出す
//        guard let geometryPlaneNode = node.childNodes.first,
//        let planeGeometory = geometryPlaneNode.geometry as? SCNPlane else {
//        fatalError()
//        }
//        // ジオメトリをアップデート
//        planeGeometory.width = CGFloat(planeAnchor.extent.x)
//        planeGeometory.height = CGFloat(planeAnchor.extent.z)
//        geometryPlaneNode.simdPosition = SIMD3(planeAnchor.center.x, 0,planeAnchor.center.z)
//    }
    
}

