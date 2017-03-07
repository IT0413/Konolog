//
//  Set.swift
//  AVCapturePhotoOutput_test
//
//  Created by 伊藤孝史 on 2017/03/05.
//  Copyright © 2017年 井上雄貴. All rights reserved.
//

import UIKit

class Set: UIViewController {

    // テキストビューをOutlet接続する
    @IBOutlet weak var textView1: UITextView!
    @IBOutlet weak var textView2: UITextView!
    
    // テキストファイルのパス
    let theNamePath = NSHomeDirectory()+"/Documents/name.txt"
    
    // ファイルへの保存
    @IBAction func saveToFile(sender: AnyObject) {
        // キーボードを下げる
        view.endEditing(true)
        // 保存するテキストデータ
        let textData = textView1.text
        // テキストデータの保存をトライする
        do {
            try textData.writeToFile(theNamePath, atomically: true, encoding: NSUTF8StringEncoding)
        } catch let error as NSError {
            print("保存に失敗。\n \(error)")
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
