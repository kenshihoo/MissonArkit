//
//  TouchesIMage.swift
//  MissonArkit
//
//  Created by Kenshiro on 2021/01/24.
//

import UIKit
import SceneKit
import ARKit

class TouchesImage: UIViewController, ARSCNViewDelegate {

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

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }

    let location = touch.location(in: sceneView)

    // Get minimum and maximum point.
    minimumX = location.x < minimumX ? location.x : minimumX
    maximumX = location.x > maximumX ? location.x : maximumX
    minimumY = location.y < minimumY ? location.y : minimumY
    maximumY = location.y > maximumY ? location.y : maximumY

        UIGraphicsBeginImageContextWithOptions(sceneView.bounds.size, false, 0.0)
    guard let context = UIGraphicsGetCurrentContext() else { return }

    drawStroke(context: context, touch: touch)

    // Update image
     var image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    }


    private func drawStroke(context: CGContext, touch: UITouch) {
    let previousLocation = touch.previousLocation(in: sceneView)
    let location = touch.location(in: sceneView)

    // Calculate line width for drawing stroke
    let lineWidth = lineWidthForDrawing(context: context, touch: touch)

    // Set color
    drawColor.setStroke()

    // Configure line
    context.setLineWidth(lineWidth)
    context.setLineCap(.round)

    // Set up the points
    context.move(to: CGPoint(x: previousLocation.x, y: previousLocation.y))
    moveToPoints.append(CGPoint(x: previousLocation.x, y: previousLocation.y))
    context.addLine(to: CGPoint(x: location.x, y: location.y))
    lineToPoints.append(CGPoint(x: location.x - previousLocation.x, y: location.y - previousLocation.y))

    // Draw the stroke
    context.strokePath()
    }
}
