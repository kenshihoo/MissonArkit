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
    var tapAnchor : [ARAnchor] = []
    var centerX : Double!
    var centerY : Double!
    @IBOutlet weak var drawView: DrawImage!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        print("ImageSAVE\(tapCount)")
        
        centerX = Double(drawView.bounds.width/2)
        centerY = Double(drawView.bounds.height/2)
        
        //DrawImageに値を渡す
        self.drawView.tapCount = tapCount
        self.drawView.tapAnchor = tapAnchor
        self.drawView.centerX = centerX
        self.drawView.centerY = centerY
        
        print("値渡した\(self.drawView.tapCount)")
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
        //画像の保存
        getImage(view: drawView)
    }
    
    //戻るボタンで測定画面に戻る
    @IBAction func reTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func getImage(view : UIView) -> UIImage {
        // キャプチャする範囲を取得する
        let rect = view.bounds
        
        // ビットマップ画像のcontextを作成する
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context : CGContext = UIGraphicsGetCurrentContext()!
        
        // view内の描画をcontextに複写する
        view.layer.render(in: context)
        
        // contextのビットマップをUIImageとして取得
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        // contextを閉じる
        UIGraphicsEndImageContext()
        
        // カメラロールに保存する
        UIImageWriteToSavedPhotosAlbum(image,self,#selector(self.didFinishSavingImage(_:didFinishSavingWithError:contextInfo:)),nil)
        return image
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
        
        present(alertController, animated: true, completion: nil)
    }
}
