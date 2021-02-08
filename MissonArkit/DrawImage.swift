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
    // UIBezierPath のインスタンス生成
    let line = UIBezierPath();
    
    override func draw(_ rect: CGRect) {
        print("draw\(tapCount)")
        
    if !tapAnchor.isEmpty {
        print("ARanchor0\(tapAnchor[0]!)")
        print("ARanchor1\(tapAnchor[1]!)")
        print("ARanchor2\(tapAnchor[2]!)")
//        // 起点の設定
        
//        line.move(to: CGPoint(x: Int(tapAnchor[0]!.transform.columns.3.x)*100, y: Int(tapAnchor[0]!.transform.columns.3.z)*100));
        
        line.move(to: CGPoint(x: abs(Double(tapAnchor[0]!.transform.columns.3.x))*100, y: abs(Double(tapAnchor[0]!.transform.columns.3.z)*100)))
        
        print("monve:\(Double(tapAnchor[0]!.transform.columns.3.x)*100)")
        
        // 帰着点の設定
        for drawCount in 1...tapCount - 2 {
            
            line.addLine(to: CGPoint(x: abs(Int(Double(tapAnchor[drawCount]!.transform.columns.3.x)))*100, y: abs(Int(Double(tapAnchor[drawCount]!.transform.columns.3.z)))*100))
            
            print("point:\(drawCount)\(tapAnchor[drawCount]!.transform.columns.3.x*100)")
            
//                line.addLine(to: CGPoint(x: Int(tapAnchor[drawCount]!.transform.columns.3.x)*100, y: Int(tapAnchor[drawCount]!.transform.columns.3.z)*100));
                }
        setting()
        measurePoints()
        }
    }
    
    //描画の設定
    func setting()  {
        // ラインを結ぶ
        line.close()
        // 塗りつぶし色の設定
        UIColor.gray.setFill()
        // 内側の塗りつぶし
        line.fill()
        // stroke 色の設定
        UIColor.red.setStroke()
        // ライン幅
        line.lineWidth = 1
        // 描画
        line.stroke();
        print("描画したよ")
    }
    
    
    //各オブジェクト間の距離を測定する
    func measurePoints()  {
        var measureCount = 1
        
        for i in 0...tapCount - 2 {
            if measureCount == i{
                measureCount = 0
            }
           
            if !tapAnchor.isEmpty {
                let distanceX = Double((tapAnchor[i])!.transform.columns.3.x - (tapAnchor[measureCount])!.transform.columns.3.x)*100
                let distanceY = Double((tapAnchor[i])!.transform.columns.3.z - (tapAnchor[measureCount])!.transform.columns.3.z)*100
                let distancetap = sqrt(distanceX*distanceX + distanceY*distanceY)
                
                edge.append(distancetap)
                measureCount += 1
                
                print("distanceX:\(distanceX)")
                
                distanceDraw(i: i,distanceX: distancetap,distanceY: distanceY,distancetap: distancetap)
            }
        }
    }
    
    //辺の横(辺の中心からx軸で0.1離れた部分)に距離を表示
    func distanceDraw(i: Int , distanceX: Double ,distanceY: Double,distancetap: Double)  {
        let labelCoordinateX = abs((Double(tapAnchor[i]!.transform.columns.3.x) - distanceX/2)*10 + 0.1)
        let labelCoordinateY = abs(Double(tapAnchor[i]!.transform.columns.3.z) - distanceY/2)*10

        print("labelPointX:\(abs((Double(tapAnchor[i]!.transform.columns.3.x) - distanceX/2)*10 + 0.1))cm")

        "\(String(describing:distancetap))cm".draw(at: CGPoint(x: labelCoordinateX, y: labelCoordinateY), withAttributes: [
                NSAttributedString.Key.foregroundColor : UIColor.red,
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18),])
    }
    
//////縮小する場合の比率を計算
//    func measureScale()   {
//
//        self.transform = self.transform.scaledBy(x: 0, y: 0)
//    }
}
