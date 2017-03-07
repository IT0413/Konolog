//
//  RectangeleDraw.swift
//  AVCapturePhotoOutput_test
//
//  Created by 伊藤孝史 on 2017/02/28.
//  Copyright © 2017年 井上雄貴. All rights reserved.
//

import UIKit

class RectangeleDraw: UIView {
        override func draw(_ rect: CGRect) {
        // 矩形 -------------------------------------
        let rectangle = UIBezierPath(rect: CGRect(x: 200,y: 70,width: 120,height: 100))
        // stroke 色の設定
        UIColor.blue.setStroke()
        // ライン幅
        rectangle.lineWidth = 8
        // 描画
        rectangle.stroke()
    }
}
