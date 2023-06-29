
import UIKit

class CandyDetailViewController: UIViewController {
    var candyName : String?
    @IBOutlet weak var candyNameLabel: UILabel!
    @IBOutlet weak var candyImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        guard let candyName = candyName else {return}
        candyNameLabel.text = candyName
        candyImageView.image = UIImage(named: candyName)
    }
    



}
