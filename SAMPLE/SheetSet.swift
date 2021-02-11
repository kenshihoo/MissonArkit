//
//  SheetSet.swift
//  MissonArkit
//
//  Created by Kenshiro on 2021/01/21.
//

import UIKit
import SceneKit
import ARKit

class SheetAet: UIViewController, ARSCNViewDelegate {

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
    
    //平面を検出したら、平面に沿って板状のオブジェクトを表示
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {

        //平面を表す情報を持つARPlaneAnchorにキャスト(これにより、中心座標を表すcenterと平面の幅長さを表すextentが使える)
        guard let planeAnchor = anchor as? ARPlaneAnchor else
        {fatalError()}

        // ノード作成
        let planeNode = SCNNode()

        // ジオメトリの作成(ARPlaneAnchorに格納されている検出した平面の大きさに合わせる)
        let geometry = SCNPlane(width: CGFloat(planeAnchor.extent.x),
        height: CGFloat(planeAnchor.extent.z))
        //色と透明度を設定
        geometry.materials.first?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)

        // ノードにGeometryとTransform を指定
        planeNode.geometry = geometry
        //SceneKitの座標系をARKitの座標系に変換(ベクトルの回転)
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2.0, 1,
        0, 0)
        // 検出したアンカーに対応するノードに子ノードとして持たせる
        node.addChildNode(planeNode)
        }

    // 平面が更新(シーン中のアンカー情報が更新)されたときに呼ばれる
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node:SCNNode, for anchor: ARAnchor) {

        guard let planeAnchor = anchor as? ARPlaneAnchor else{
        fatalError()
        }
        //現在表示している平面ノードを取り出す
        guard let geometryPlaneNode = node.childNodes.first,
        let planeGeometory = geometryPlaneNode.geometry as? SCNPlane else {
        fatalError()
        }
        // ジオメトリをアップデート
        planeGeometory.width = CGFloat(planeAnchor.extent.x)
        planeGeometory.height = CGFloat(planeAnchor.extent.z)
        geometryPlaneNode.simdPosition = SIMD3(planeAnchor.center.x, 0,planeAnchor.center.z)
    }
    
    
}
