import UIKit

class Measure: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //ファイルパス
    let sizePath:String = NSHomeDirectory()+"/Documents/size.txt"
    let heightPath:String = NSHomeDirectory()+"/Documents/height.txt"
    
    var headX:Double = 0.0
    var headY:Double = 0.0
    var footX:Double = 0.0
    var footY:Double = 0.0
    var dist:Double = 0.0
    var virtualFrameX:Double = 0.0
    var virtualFrameY:Double  = 0.0
    
    @IBAction func addPicture(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)

    }
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
        performSegue(withIdentifier: "registerSegue", sender: nil)
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
        save(field: String(format:"%g",badySize), path: heightPath)
        return badySize
    }
    
    //ファイルに保存する(上書き)
    func save (field:String,path:String){
        let data = field
        do {
            try data.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("名前保存に失敗。\n \(error)")
        }
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
    
    // フォトライブラリを使用できるか確認
    func imageSelect(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            // フォトライブラリの画像・写真選択画面を表示
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.allowsEditing = true
            imagePickerController.delegate = self
            present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 選択された画像
        let selectImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.image = selectImage
        self.dismiss(animated: true, completion: nil )
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
