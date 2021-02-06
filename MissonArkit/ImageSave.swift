//  ImageSave.swift
//  MissonArkit
//
//  Created by Kenshiro on 2021/01/26.
//

import Foundation
import UIKit
import SceneKit
import ARKit

class ImageSave: UIViewController, ARSCNViewDelegate {

    var tapCount = 0
    var tapAnchor : [ARAnchor?] = []
    @IBOutlet weak var drawView: DrawImage!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ImageSAVE")
        print(tapCount)
        //DrawImageに値を渡す
        self.drawView.tapCount = tapCount
        self.drawView.tapAnchor = tapAnchor
        print("値渡した")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Screen Size の取得
        let screenWidth = self.drawView.bounds.width
        let screenHeight = self.drawView.bounds.height
        
         
        let planeDraw = DrawImage(frame: CGRect(x: 0, y: 0,width: screenWidth, height: screenHeight))
        
        self.drawView.addSubview(planeDraw)
        
        // 不透明にしない（透明）
        planeDraw.isOpaque = false
        // 背景色
        self.drawView.backgroundColor = UIColor.black

    }
    
    //保存ボタンが押されたら画像として保存する
    @IBAction func saveButton(_ sender: Any) {
        func getImage(_ view : UIView) -> UIImage {
            
            // キャプチャする範囲を取得する
            let rect = view.bounds
            
            // ビットマップ画像のcontextを作成する
            UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
            let context : CGContext = UIGraphicsGetCurrentContext()!
            
            // view内の描画をcontextに複写する
            view.layer.render(in: context)
            
            // contextのビットマップをUIImageとして取得する
            let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            
            // contextを閉じる
            UIGraphicsEndImageContext()
            
            return image
        }
        
    }
    
    //戻るボタンで測定画面に戻る
    @IBAction func reTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
