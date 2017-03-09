

import UIKit

class Graph: UIViewController {

    //ログデータ用配列
    var dataList:[String] = []
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var birthField: UITextField!
    @IBOutlet weak var graphView: UIScrollView!
    
    //ファイルパス
    let namePath = NSHomeDirectory()+"/Documents/name.txt"
    let sizePath = NSHomeDirectory()+"/Documents/size.txt"
    let birthPath = NSHomeDirectory()+"/Documents/birth.txt"

    
    @IBAction func homeBack(_ sender: Any) {
        //homeVCへ移動する
        let storyboard: UIStoryboard = self.storyboard!
        let homeView = storyboard.instantiateViewController(withIdentifier: "home") as! Home
        self.present(homeView, animated: true, completion: nil)
    }
    

    func readFromFile(file:String) {
        // ファイルマネージャを作る
        let fileNameManager = FileManager.default
        let fileBirthManager = FileManager.default
// ファイルが存在するかどうかチェックする
        if fileNameManager.fileExists(atPath: namePath) {
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
        if fileBirthManager.fileExists(atPath: birthPath) {
            // テキストデータの読み込みをトライする
            do {
                var birthData:String = try String(contentsOfFile: birthPath, encoding: String.Encoding.utf8)
                // 読み込みが成功したならば表示する
                birthData = birthData.replacingOccurrences(of: "年", with: "-")
                birthData = birthData.replacingOccurrences(of: "月", with: "-")
                birthData = birthData.replacingOccurrences(of: "日", with: "")
                birthField.text = postnatalCalculate(birth: birthData)
            } catch let error as NSError {
                birthField.text = "読み込みに失敗。\n \(error)"
            }
        } else {
            birthField.text = "ファイルが存在しません。"
        }
    }

    //生後何日めかを計算する関数
    func postnatalCalculate(birth:String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        // 上記の形式の日付文字列から日付データを取得します。
        let today = dateFormatter.date(from: getToday())
        let birthDate = dateFormatter.date(from: birth)
        print(getIntervalDays(date: today, anotherDay:birthDate))
        
        return String(format: "%g", getIntervalDays(date: today, anotherDay:birthDate))
    }
    
    //今日の日付を取得する関数
    func getToday(format:String = "yyyy-MM-dd") -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: now as Date)
    }
    //２つの日付の差を求める関数
    func getIntervalDays(date:Date?,anotherDay:Date? = nil) -> Double {
        var retInterval:Double!
        if anotherDay == nil {
            retInterval = date?.timeIntervalSinceNow
        } else {
            retInterval = date?.timeIntervalSince(anotherDay!)
        }
        let ret = retInterval/86400
        return floor(ret)  // n日
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readFromFile(file: namePath)
        let graphview = graphing() //グラフを表示するクラス
        graphView.addSubview(graphview) //グラフをスクロールビューに配置
        graphview.drawLineGraph() //グラフ描画開始
        graphView.contentSize = CGSize(width:graphview.checkWidth()+20, height:graphview.checkHeight()) //スクロールビュー内のコンテンツサイズ設定
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

class graphing: UIView {
        
        var lineWidth:CGFloat = 3.0 //グラフ線の太さ
        var lineColor:UIColor = UIColor(red:1,  green:1,  blue:0, alpha:0.8) //グラフ線の色
        var circleWidth:CGFloat = 4.0 //円の半径
        var circleColor:UIColor = UIColor(red:1,  green:1,  blue:0, alpha:1) //円の色
        
        var memoriMargin: CGFloat = 70 //横目盛の感覚
        var graphHeight: CGFloat = 300 //グラフの高さ
        var graphPoints: [String] = []
        var graphDatas: [CGFloat] = []
        var logDates:[String] = []
        var logHeight:[CGFloat] = []

    func drawLineGraph()
        {
            //ログファイルから読み込む
            
            graphPoints = ["2000/2/3", "2000/3/3", "2000/4/3", "2000/5/3", "2000/6/3", "2000/7/3", "2000/8/3"]
            graphDatas = [100, 30, 10, -50, 90, 12, 40]
            GraphFrame()
            MemoriGraphDraw()
        }
        
        //グラフを描画するviewの大きさ
        func GraphFrame(){
            self.backgroundColor = UIColor(red:0.972,  green:0.973,  blue:0.972, alpha:1)
            self.frame = CGRectMake(10 , 0, checkWidth(), checkHeight())
        }
        
        //横目盛・グラフを描画する
        func MemoriGraphDraw() {
            
            var count:CGFloat = 0
            for memori in graphPoints {
                
                let label = UILabel()
                label.text = String(memori)
                label.font = UIFont.systemFont(ofSize: 9)
                
                //ラベルのサイズを取得
                let frame = CGSize(width:250, height:CGFloat.greatestFiniteMagnitude)
                let rect = label.sizeThatFits(frame)
                
                //ラベルの位置
                var lebelX = (count * memoriMargin)-rect.width/2
                
                //最初のラベル
                if Int(count) == 0{
                    lebelX = (count * memoriMargin)
                }
                
                //最後のラベル
                if Int(count+1) == graphPoints.count{
                    lebelX = (count * memoriMargin)-rect.width
                }
                
                label.frame = CGRectMake(lebelX , graphHeight, rect.width, rect.height)
                self.addSubview(label)
                
                count += 1
            }
        }
        
        //グラフの線を描画
        override func draw(_ rect: CGRect) {
            
            var count:CGFloat = 0
            let linePath = UIBezierPath()
            var myCircle = UIBezierPath()
            
            linePath.lineWidth = lineWidth
            lineColor.setStroke()
            
            for datapoint in graphDatas {
                
                if Int(count+1) < graphDatas.count {
                    
                    var nowY: CGFloat = datapoint/yAxisMax * (graphHeight - circleWidth)
                    nowY = graphHeight - nowY
                    
                    if(graphDatas.min()!<0){
                        nowY = (datapoint - graphDatas.min()!)/yAxisMax * (graphHeight - circleWidth)
                        nowY = graphHeight - nowY
                    }
                    
                    //次のポイントを計算
                    var nextY: CGFloat = 0
                    nextY = graphDatas[Int(count+1)]/yAxisMax * (graphHeight - circleWidth)
                    nextY = graphHeight - nextY
                    
                    if(graphDatas.min()!<0){
                        nextY = (graphDatas[Int(count+1)] - graphDatas.min()!)/yAxisMax * (graphHeight - circleWidth)
                        nextY = graphHeight - nextY - circleWidth
                    }
                    
                    //最初の開始地点を指定
                    var circlePoint:CGPoint = CGPoint()
                    if Int(count) == 0 {
                        linePath.move(to: CGPoint(x: count * memoriMargin + circleWidth, y: nowY))
                        circlePoint = CGPoint(x: count * memoriMargin + circleWidth, y: nowY)
                        myCircle = UIBezierPath(arcCenter: circlePoint,radius: circleWidth,startAngle: 0.0,endAngle: CGFloat(M_PI*2),clockwise: false)
                        circleColor.setFill()
                        myCircle.fill()
                        myCircle.stroke()
                    }
                    
                    //描画ポイントを指定
                    linePath.addLine(to: CGPoint(x: (count+1) * memoriMargin, y: nextY))
                    
                    //円をつくる
                    circlePoint = CGPoint(x: (count+1) * memoriMargin, y: nextY)
                    myCircle = UIBezierPath(arcCenter: circlePoint,
                                            // 半径
                        radius: circleWidth,
                        // 初角度
                        startAngle: 0.0,
                        // 最終角度
                        endAngle: CGFloat(M_PI*2),
                        // 反時計回り
                        clockwise: false)
                    circleColor.setFill()
                    myCircle.fill()
                    myCircle.stroke()
                    
                }
                count += 1
            }
            linePath.stroke()
        }
        
        // 保持しているDataの中で最大値と最低値の差を求める
        var yAxisMax: CGFloat {
            return graphDatas.max()!-graphDatas.min()!
        }
        
        //グラフ横幅を算出
        func checkWidth() -> CGFloat{
            return CGFloat(graphPoints.count-1) * memoriMargin + (circleWidth * 2)
        }
        
        //グラフ縦幅を算出
        func checkHeight() -> CGFloat{
            return graphHeight
        }
    
        func csvToArray () {
            if let csvPath = Bundle.main.path(forResource: "log.csv", ofType: "csv") {
                do {
                    let csvStr = try String(contentsOfFile:csvPath, encoding:String.Encoding.utf8)
                    let csvArr = csvStr.components(separatedBy: .newlines)
                    print(csvArr)
                } catch let error as NSError {
                    print(error.localizedDescription)
            }
        }
    }

    }
}

//Swift3.0でCGRectMakeを使えるようにWrap
func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
    return CGRect(x: x, y: y, width: width, height: height)
}

