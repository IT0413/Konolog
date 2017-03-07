

import UIKit
import AVFoundation

class Camera: UIViewController ,AVCapturePhotoCaptureDelegate{

    @IBOutlet weak var imageView: UIImageView!
    
    var captureSesssion: AVCaptureSession!
    //画面のアウトプット
    var stillImageOutput: AVCapturePhotoOutput!
    
    //シャッターボタンを実行
    @IBAction func takePhoto(_ sender: Any){
        let settingsForMonitoring = AVCapturePhotoSettings()
        settingsForMonitoring.flashMode = .auto
        settingsForMonitoring.isAutoStillImageStabilizationEnabled = true
        settingsForMonitoring.isHighResolutionPhotoEnabled = false
        stillImageOutput?.capturePhoto(with: settingsForMonitoring, delegate: self)
    }
    //    AVCapturePhotoSettingsという新しいClassがAVCapturePhotoOutputと一緒に追加された。
    //    フラッシュなどの細かい設定はAVCapturePhotoSettingsで行う
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //セッションの作成
        captureSesssion = AVCaptureSession()
        //解像度の指定
        captureSesssion.sessionPreset = AVCaptureSessionPreset1920x1080
        stillImageOutput = AVCapturePhotoOutput()

        //カメラの起動
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        //カメラからinputを取得する
        do {
            //入力セッション
            let input = try AVCaptureDeviceInput(device: device)
            if (captureSesssion.canAddInput(input)) {
                captureSesssion.addInput(input)
                if (captureSesssion.canAddOutput(stillImageOutput)) {
                    captureSesssion.addOutput(stillImageOutput)
                    captureSesssion.startRunning()
                    let captureVideoLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: captureSesssion)
                    captureVideoLayer.frame = self.imageView.bounds
                    captureVideoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                    self.imageView.layer.addSublayer(captureVideoLayer)
                }
            }
        }
        catch {
            print(error)
        }
        
        
        //画面サイズを取得する
        let myAppFrameSize: CGSize = UIScreen.main.bounds.size
        // 四角形のイメージを作る
        let boxImage = makeRactangleImage(width: myAppFrameSize.width * 0.8, height: myAppFrameSize.height * 0.7)
        // イメージビューに設定する
        let boxView = UIImageView(image: boxImage)
        // 画面に表示する
        boxView.center = view.center
        view.addSubview(boxView)
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let photoSampleBuffer = photoSampleBuffer {
            //ビデオ画像をキャプチャする
            let photoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
            let image = UIImage(data: photoData!)
            //カメラロールに追加する
            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
            
            //measureVCへ移動する
            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "measure") as! Measure
            self.present(nextView, animated: true, completion: nil)
        }
    }
    
    
    func makeRactangleImage(width w:CGFloat, height h:CGFloat) -> UIImage{
        // イメージ処理の開始
        let size:CGSize = CGSize(width: w, height: h)
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        // コンテキスト
        let context = UIGraphicsGetCurrentContext()
        // サイズを決める
        var boxRect = CGRect(x: 0, y: 0, width: w, height: h)
        // 線の1/2幅だけ内側にする
        let lineWidth:CGFloat = 6.0
        boxRect = boxRect.insetBy(dx: lineWidth/2, dy:lineWidth/2)
        // パスを作る
        let drawPath = UIBezierPath(rect: boxRect)
        // 塗り色
        context!.setFillColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        // パスを塗る
        drawPath.fill()
        // 線の色
        context!.setStrokeColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 0.5)
        // 線幅
        drawPath.lineWidth = lineWidth
        // パスを描く
        drawPath.stroke()
        // イメージコンテキストからUIImageを作る
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // イメージ処理の終了
        UIGraphicsEndImageContext()
    
        return image!
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
