
import UIKit

class Set: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var sizeField: UITextField!
    @IBOutlet weak var dateSelecter: UITextField!
    // テキストビューをOutlet接続する
   
    @IBAction func homeBack(_ sender: Any) {
        //homeVCへ移動する
        let storyboard: UIStoryboard = self.storyboard!
        let homeView = storyboard.instantiateViewController(withIdentifier: "home") as! Home
        self.present(homeView, animated: true, completion: nil)
    }
    //今日の日付を代入
    let nowDate = NSDate()
    let dateFormat = DateFormatter()
    let inputDatePicker = UIDatePicker()
    
    // テキストファイルのパス
    let namePath = NSHomeDirectory()+"/Documents/name.txt"
    let sizePath = NSHomeDirectory()+"/Documents/size.txt"
    let birthPath = NSHomeDirectory()+"/Documents/birth.txt"
 
    
    @IBAction func saveStatus(_ sender: Any) {
        // キーボードを下げる
        view.endEditing(true)
        // 保存するテキストデータ
        save(field: nameField.text!, path:namePath)
        save(field: sizeField.text!, path:sizePath)
        save(field: dateSelecter.text!, path:birthPath)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Set.DismissKeyboard))
        view.addGestureRecognizer(tap)

        //日付フィールドの設定
        dateFormat.dateFormat = "yyyy年MM月dd日"
        dateSelecter.text = dateFormat.string(from: nowDate as Date)
        self.dateSelecter.delegate = self
        
        
        // DatePickerの設定(日付用)
        inputDatePicker.datePickerMode = UIDatePickerMode.date
        dateSelecter.inputView = inputDatePicker
        
        // キーボードに表示するツールバーの表示
        let pickerToolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        pickerToolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        pickerToolBar.barStyle = .blackTranslucent
        pickerToolBar.tintColor = UIColor.white
        pickerToolBar.backgroundColor = UIColor.black
        
        //完了ボタンを設定
        let toolBarButton = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(toolBarBtnPush(sender:)))
        pickerToolBar.items = [toolBarButton]
        dateSelecter.inputAccessoryView = pickerToolBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    //完了を押すとピッカーの値を、テキストフィールドに挿入して、ピッカーを閉じる
    func toolBarBtnPush(sender: UIBarButtonItem){
        print("ボタン押されたよ！")
        let pickerDate = inputDatePicker.date
        dateSelecter.text = dateFormat.string(from: pickerDate)
        self.view.endEditing(true)
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
    //読み込んだファイルを表示する
    func readTextFile(fileURL: URL) {
        do {
            let text = try String(contentsOf: fileURL, encoding: String.Encoding.utf8)
            print(text)
        } catch let error as NSError {
            print("failed to read: \(error)")
        }
    }
    //Swift3.0でCGRectMakeを使えるようにWrap
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
}
