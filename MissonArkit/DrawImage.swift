//
//  DrawImage.swift
//  MissonArkit
//
//  Created by Kenshiro on 2021/01/26.
//

import UIKit
import SceneKit
import ARKit

class DrawImage: UIView {

    //ViewControllerから値を持って来たい
    var tapCount :Int!
    var tapAnchor : [ARAnchor?] = []
    
    var distancePoint : [Double?] = []
    
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
    
    override func draw(_ rect: CGRect) {
        // UIBezierPath のインスタンス生成
        let line = UIBezierPath();
    if !tapAnchor.isEmpty {
        // 起点の設定
        line.move(to: CGPoint(x: Int(tapAnchor[0]!.transform.columns.3.x), y: Int(tapAnchor[0]!.transform.columns.3.z)));
        
        var drawCount = 1
        
        // 帰着点の設定
        for _ in 0...tapCount - 3 {

                line.addLine(to: CGPoint(x: Int(tapAnchor[drawCount]!.transform.columns.3.x), y: Int(tapAnchor[drawCount]!.transform.columns.3.z)));
                
                drawCount += 1
                }
        
                // ラインを結ぶ
                line.close()
                // 塗りつぶし色の設定
                UIColor.gray.setFill()
                // 内側の塗りつぶし
                line.fill()
                
                // stroke 色の設定
                UIColor.green.setStroke()
                // ライン幅
                line.lineWidth = 1
                // 描画
                line.stroke();
                }
        
            //各辺の下部(辺の中心からx軸で0.01離れ部分)に距離(distancePointの情報)を表示
            "MyText".draw(at: CGPoint(x: 100, y: 100), withAttributes: [
                NSAttributedString.Key.foregroundColor : UIColor.blue,
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 50),
                    ])
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
         Drawing code
    }
    */

}
