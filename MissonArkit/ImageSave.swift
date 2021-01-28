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

class ImageSave: UIViewController, ARSCNViewDelegate,UIApplicationDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    var sceneView: ARSCNView!

    var tapCount :Int!
    var tapAnchor : [ARAnchor?] = []
    var distancePoint : [Double?] = []
    
    
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
    

    
    //各オブジェクト間の距離を測定する
    func measurePoints()  {
        var measureCount = 1
        
        //distancePointを空配列に初期化
        distancePoint.removeAll()
        
        for i in 0...tapCount - 2 {
            
            if measureCount == i{
                measureCount = 0
            }
           
            if !tapAnchor.isEmpty {
                let distanceX = Double((tapAnchor[i])!.transform.columns.3.x - (tapAnchor[measureCount])!.transform.columns.3.x)
                let distanceZ = Double((tapAnchor[i])!.transform.columns.3.z - (tapAnchor[measureCount])!.transform.columns.3.z)
                let distancetap = sqrt(distanceX*distanceX + distanceZ*distanceZ)
                
                distancePoint.append(distancetap)
                
                measureCount += 1
                }
            }
        //動作確認用のprint
        print(distancePoint)
    }
    
    
//    //画像の作成
//    func createImage(didAdd node: SCNNode,sphereNode:SCNNode)  {
//
//        // ノード作成
//        let planeNode = SCNNode()
//        let labelNode = SCNNode()
//
//        // ジオメトリの作成
//
//        let verticesSource = SCNGeometrySource(vertices: tapAnchor, count: tapCount)
//
//        //タップした部分を頂点とする図形を作成
//        let planeGeometry = SCNGeometry(sources: [verticesSource], elements: [])
//        sceneView.rootNode.addChildNode(SCNNode(geometry: planeGeometry))
//        //色と透明度を設定
//        planeGeometry.materials.first?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
//
//        // ノードにGeometryとTransform を指定
//        planeNode.geometry = planeGeometry
//        //SceneKitの座標系をARKitの座標系に変換(ベクトルの回転)
//        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2.0, 1,
//        0, 0)
//        // 検出したアンカーに対応するノードに子ノードとして持たせる
//        node.addChildNode(planeNode)
//
//
//        //各辺の下部(辺の中心からx軸で0.01離れ部分)に距離(distancePointの情報)を表示
//        // ノードにGeometryとTransform を設定
//        labelNode.geometry = SCNText(string:" \(distancePoint[1])" + "cm", extrusionDepth: 0)
//        //設置地の高さ(y座標)を0にする
//        labelNode.position.y = 0
//        //辺の中心からx軸で+0.01の部分に設置
//
//        // 距離を子ノードとしてもたせる
//        node.addChildNode(labelNode)
//
//        //作成したnode(面と距離)画像として書き出す
//
//        //書き出した画像を端末に保存
//    }
    
}
