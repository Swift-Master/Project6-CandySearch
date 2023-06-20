
import UIKit

class CandyListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    }
    
    func setNavigationBar() {
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.backgroundColor = .systemGreen
        navigationAppearance.titleTextAttributes = [.foregroundColor : UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = navigationAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationAppearance
        navigationController?.navigationBar.compactAppearance = navigationAppearance
        navigationController?.navigationBar.compactScrollEdgeAppearance = navigationAppearance
        
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        
        title = "Candy Search"
    }
    
    


}

