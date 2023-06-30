
import UIKit

class CandyDetailViewController: UIViewController {
    var currentCandy : Candy?
    @IBOutlet weak var candyNameLabel: UILabel!
    @IBOutlet weak var candyCategoryLabel: UILabel!
    @IBOutlet weak var candyImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    // MARK: - 선택된 셀의 정보를 화면에 표시합니다.
    func setUI() {
        guard let currentCandy = currentCandy, let candyName = currentCandy.name, let candyCategory = currentCandy.category else {return}
        candyNameLabel.text = candyName
        candyCategoryLabel.text = candyCategory
        candyImageView.image = UIImage(named: candyName)
    }
    
}
