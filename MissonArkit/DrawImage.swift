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
    var tapCount = 0
    //CGPoint型に変換した独自の配列(didsetで行う)同時にScaleの計算もしておきたい
    var tapAnchor : [ARAnchor?] = []
    var edge :[Double?] = []
    
    override func draw(_ rect: CGRect) {
        print("draw")
        print(tapCount)
        // UIBezierPath のインスタンス生成
        let line = UIBezierPath();
        
    if !tapAnchor.isEmpty {
        // 起点の設定
        line.move(to: CGPoint(x: Int(tapAnchor[0]!.transform.columns.3.x), y: Int(tapAnchor[0]!.transform.columns.3.z)));
        
        // 帰着点の設定
        for drawCount in 1...tapCount - 2 {
                line.addLine(to: CGPoint(x: Int(tapAnchor[drawCount]!.transform.columns.3.x), y: Int(tapAnchor[drawCount]!.transform.columns.3.z)));
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
    }
    
    //各オブジェクト間の距離を測定する
    func measurePoints()  {
        var measureCount = 1
        
        for i in 0...tapCount - 2 {
            
            if measureCount == i{
                measureCount = 0
            }
           
            if !tapAnchor.isEmpty {
                let distanceX = Double((tapAnchor[i])!.transform.columns.3.x - (tapAnchor[measureCount])!.transform.columns.3.x)
                let distanceY = Double((tapAnchor[i])!.transform.columns.3.z - (tapAnchor[measureCount])!.transform.columns.3.z)
                let distancetap = sqrt(distanceX*distanceX + distanceY*distanceY)
                
                edge.append(distancetap)
                
                measureCount += 1
                
                distanceDraw(i: i,distanceX: distancetap,distanceY: distanceY,distancetap: distancetap)
            }
        }
    }
    
    //辺の横(辺の中心からx軸で0.01離れた部分)に距離を表示
    func distanceDraw(i: Int , distanceX: Double ,distanceY: Double,distancetap: Double)  {
        let labelCoordinateX = (Double(tapAnchor[i]!.transform.columns.3.x) - distanceX/2) + 0.01
        let labelCoordinateY = Double(tapAnchor[i]!.transform.columns.3.z) - distanceY/2
        
        "\(String(describing:distancetap ))*100".draw(at: CGPoint(x: labelCoordinateX, y: labelCoordinateY), withAttributes: [
                NSAttributedString.Key.foregroundColor : UIColor.red,
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18),])
    }
    
////縮小する場合の比率を計算
//    func measureScale()   {
//
//        print(edge[0]! as Double)
//        self.transform = self.transform.scaledBy(x: <#T##CGFloat#>, y: <#T##CGFloat#>)
//    }
}
