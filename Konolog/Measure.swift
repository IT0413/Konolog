import UIKit

class Measure: UIViewController {
    
    //ファイルパス
    let sizePath:String = NSHomeDirectory()+"/Documents/size.txt"
    var headX:Double = 0.0
    var headY:Double = 0.0
    var footX:Double = 0.0
    var footY:Double = 0.0
    var dist:Double = 0.0
    var virtualFrameX:Double = 0.0
    var virtualFrameY:Double  = 0.0
    
    @IBOutlet weak var imageView: UIImageView!
    var badyHead: UILabel!
    var badyFoot: UILabel!
    
    @IBAction func panHeadLocation(_ senderHead: UIPanGestureRecognizer) {
        //移動量を取得する。
        let move:CGPoint = senderHead.translation(in: self.view)
        //ドラッグした部品の座標に移動量を加算する。
        senderHead.view!.center.x += move.x
        senderHead.view!.center.y += move.y
        //ラベルに現在座標を表示する。
        print("head:\(senderHead.view!.frame.origin.x), \(senderHead.view!.frame.origin.y)")
        headX = Double(senderHead.view!.frame.origin.x)
        headY = Double(senderHead.view!.frame.origin.y)
        //移動量を0にする。
        senderHead.setTranslation(CGPoint.zero, in:view)
    }
    @IBAction func panFootLocation(_ senderFoot: UIPanGestureRecognizer) {
        //移動量を取得する。
        let move:CGPoint = senderFoot.translation(in: self.view)
        //ドラッグした部品の座標に移動量を加算する。
        senderFoot.view!.center.x += move.x
        senderFoot.view!.center.y += move.y
        //ラベルに現在座標を表示する。
        print("foot:\(senderFoot.view!.frame.origin.x), \(senderFoot.view!.frame.origin.y)")
        footX = Double(senderFoot.view!.frame.origin.x)
        footY = Double(senderFoot.view!.frame.origin.y)
        //移動量を0にする。
        senderFoot.setTranslation(CGPoint.zero, in:view)
    }
    
    @IBOutlet weak var headView: UIImageView!
 
    //グラフへ画面遷移
    @IBAction func measureNextBySegue(_ sender:UIButton) {
        dist = distance(x1:headX , y1: headY, x2: footX, y2: footY)//ここでグラフの元データへの書き込みをしたほうがいい
        print(dist)
        //performSegue(withIdentifier: "registerSegue", sender: nil)
    }
    //ホームへ戻る
    @IBAction func homeBack(_ sender: Any) {
        //homeVCへ移動する
        let storyboard: UIStoryboard = self.storyboard!
        let homeView = storyboard.instantiateViewController(withIdentifier: "home") as! Home
        self.present(homeView, animated: true, completion: nil)
    }
    
    //２つのオブジェクト間の距離を計算する
    func distance(x1:Double,y1:Double,x2:Double,y2:Double) -> Double{
        let pixelDistance = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2))
        let bedFrameSize:Double = Double(readFromFile(file: sizePath))!
        let badySize = pixelDistance * bedFrameSize / virtualFrameY
        return badySize
    }
    
    func readFromFile(file:String)  -> String{
        // ファイルマネージャを作る
        let fileSizeManager = FileManager.default
        var sizeData:String = ""
        // ファイルが存在するかどうかチェックする
        if fileSizeManager.fileExists(atPath: file) {
            // テキストデータの読み込みをトライする
            do {
                sizeData = try String(contentsOfFile: file, encoding: String.Encoding.utf8)
                // 読み込みが成功したならば表示する
            } catch let error as NSError {
                print("読み込みに失敗\(error)")
            }
        } else {
            print("ファイルが存在しません。")
        }
        return sizeData
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //画面サイズを取得する
        let myAppFrameSize: CGSize = UIScreen.main.bounds.size
        virtualFrameX = Double(myAppFrameSize.width * 0.9)
        virtualFrameY = Double(myAppFrameSize.height * 0.9)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
