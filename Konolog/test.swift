//
//  test.swift
//  Konolog
//
//  Created by 伊藤孝史 on 2017/03/09.
//  Copyright © 2017年 伊藤孝史. All rights reserved.
//

import UIKit

class test: UIViewController {


    @IBOutlet weak var testLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // パンを定義
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(test.panView(sender:)))  //Swift3
        // viewにパンを登録
        self.view.addGestureRecognizer(panGesture)
    }

    /// パン時に実行される
    func panView(sender: UIPanGestureRecognizer) {
        print("パン")
        //移動後の相対位置を取得
        let location: CGPoint = sender.translation(in: self.view)  //Swift3
        print(location)
        //testLabel.text = String(locationX)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
