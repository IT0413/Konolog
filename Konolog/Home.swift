
import UIKit

class Home: UIViewController {
  
    @IBAction func measureNextBySegue(_ sender:UIButton) {
        performSegue(withIdentifier: "photoSegue", sender: nil)
    }

    @IBAction func setNextBySegue(_ sender:UIButton) {
        performSegue(withIdentifier: "setSegue", sender: nil)
    }

    @IBAction func logNextBySegue(_ sender:UIButton) {
        performSegue(withIdentifier: "logSegue", sender: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png"))
        // Do any additional setup after loading the view.
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
