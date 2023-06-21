
import UIKit

class CandyListViewController: UIViewController {
    
    var dataModel : [Candy]?
    
    @IBOutlet weak var candyTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        getDataModel()
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
    
    func getDataModel() {
        dataModel = Candy.getData()
    }
    
    func setTable() {
        
    }
    
}

extension CandyListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let candies = dataModel else {
            fatalError("Row 개수 계산 중 오류 발생")
        }
        
        return candies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let candies = dataModel else {
            fatalError("셀 설정 중 오류 발생")
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "candycell", for: indexPath)
        var cellConfiguration = cell.defaultContentConfiguration()
        cellConfiguration.text = candies[indexPath.row].name
        cellConfiguration.secondaryText = candies[indexPath.row].category
        cell.contentConfiguration = cellConfiguration
        
        return cell
    }
    
}

