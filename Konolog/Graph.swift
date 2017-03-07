

import UIKit

class Graph: UIViewController {


    //日付の取得

    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var birthField: UITextField!

    //ファイルパス
    let namePath = NSHomeDirectory()+"/Documents/name.txt"
    let sizePath = NSHomeDirectory()+"/Documents/size.txt"
    let birthPath = NSHomeDirectory()+"/Documents/birth.txt"

    @IBAction func readFromFile(_ sender: Any) {
        // ファイルマネージャを作る
        let fileManager = FileManager.default
        // ファイルが存在するかどうかチェックする
        if fileManager.fileExists(atPath: namePath) {
            // テキストデータの読み込みをトライする
            do {
                let nameData = try String(contentsOfFile: namePath, encoding: String.Encoding.utf8)
                // 読み込みが成功したならば表示する
                nameField.text = nameData
            } catch let error as NSError {
                nameField.text = "読み込みに失敗。\n \(error)"
            }
        } else {
            nameField.text = "ファイルが存在しません。"
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
