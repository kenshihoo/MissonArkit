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
    
    var appDelegate:ImageSave = UIApplication.shared.delegate as! ImageSave
    
    
    override func draw(_ rect: CGRect) {
        // UIBezierPath のインスタンス生成
        let line = UIBezierPath();
    if !appDelegate.tapAnchor.isEmpty {
        // 起点
        line.move(to: CGPoint(x: Int(appDelegate.tapAnchor[0]!.transform.columns.3.x), y: Int(appDelegate.tapAnchor[0]!.transform.columns.3.z)));
        
        // 帰着点
        var drawCount = 1
        
        for _ in 0...appDelegate.tapCount - 3 {
            
                line.addLine(to: CGPoint(x: Int(appDelegate.tapAnchor[drawCount]!.transform.columns.3.x), y: Int(appDelegate.tapAnchor[drawCount]!.transform.columns.3.z)));
                
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
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
         Drawing code
    }
    */

}
