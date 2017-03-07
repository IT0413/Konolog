
import UIKit

class Set: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var sizeField: UITextField!
    // テキストビューをOutlet接続する
    
    // テキストファイルのパス
    let namePath = NSHomeDirectory()+"/Documents/name.txt"
    let sizePath = NSHomeDirectory()+"/Documents/size.txt"
    let birthPath = NSHomeDirectory()+"/Documents/birth.txt"
 
    
    @IBAction func saveStatus(_ sender: Any) {
        // キーボードを下げる
        view.endEditing(true)
        // 保存するテキストデータ
        let nameData = nameField.text
        let sizeData = sizeField.text
        // テキストデータの保存をトライする
        do {
            try nameData?.write(toFile: namePath, atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("保存に失敗。\n \(error)")
        }
        do {
            try sizeData?.write(toFile: sizePath, atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("保存に失敗。\n \(error)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Set.DismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func DismissKeyboard(){
        view.endEditing(true)
    }
}
