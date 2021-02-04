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

class ImageSave: UIViewController, ARSCNViewDelegate {

    var tapCount :Int!
    var tapAnchor : [ARAnchor?] = []
    weak var drawView: DrawImage!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //DrawImageに値を渡す
        self.drawView.tapCount = tapCount
        self.drawView.tapAnchor = tapAnchor
        
        // Screen Size の取得
        let screenWidth = self.view.bounds.width
        let screenHeight = self.view.bounds.height
         
        var planeDraw = DrawImage(frame: CGRect(x: 0, y: 0,width: screenWidth, height: screenHeight))
        
        
        self.view.addSubview(planeDraw)
        
        // 不透明にしない（透明）
        planeDraw.isOpaque = false
        // 背景色
        self.view.backgroundColor = UIColor.orange
    }
    
    //保存ボタンが押されたら画像として保存する
    @IBAction func saveButton(_ sender: Any) {
        getImage(DrawImage)
        save()
    }
    // UIViewからUIImageに変換する
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
    
    // viewをimageに変換しカメラロールに保存する
    func save() {
        // viewをimageとして取得
        let image : UIImage = self.viewToImage(view)
        
        // カメラロールに保存する
        UIImageWriteToSavedPhotosAlbum(image,self,#selector(self.didFinishSavingImage(_:didFinishSavingWithError:contextInfo:)),nil)
    }

    // 保存を試みた結果を受け取る
    @objc func didFinishSavingImage(_ image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer) {
        
        // 結果によって出すアラートを変更する
        var title = "保存完了"
        var message = "カメラロールに保存しました"
        
        if error != nil {
            title = "エラー"
            message = "保存に失敗しました"
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
