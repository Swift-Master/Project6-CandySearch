
import UIKit

class CandyListViewController: UIViewController {
    
    var dataModel : [Candy]?
    
    var searchResult : [Candy]?
    
    var isSearched : Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false

        return isActive
    }
    
    var candySearchBar = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var candyTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchBar()
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
        self.navigationItem.searchController = candySearchBar
        
        // MARK: - 스크롤 시 서치 바를 숨깁니다(기본적으로 숨김)
        self.navigationItem.hidesSearchBarWhenScrolling = false
        title = "Candy Search"
    }
    
    func getDataModel() {
        dataModel = Candy.getData()
    }
    
    func setTable() {
        
    }
    
    func setSearchBar() {
        candySearchBar.searchBar.scopeButtonTitles = ["All","Chocolate","Hard","Other"]
        
        // MARK: - UISearchResultsUpdating의 delegate 설정
        candySearchBar.searchBar.delegate = self
        candySearchBar.searchResultsUpdater = self
        // MARK: - 검색 중에 서치 바 영역 제외 백그라운드 어둡게 변경(기본적으로 활성화)
        candySearchBar.obscuresBackgroundDuringPresentation = false
        // MARK: - 자동으로 cancel 버튼 활성화(기본적으로 활성화)
//        candySearchBar.automaticallyShowsCancelButton = false
        // MARK: - 서치 바 활성화 시 네비게이션 타이틀 숨기기(기본적으로 활성화되어있음)
//        candySearchBar.hidesNavigationBarDuringPresentation = false
        // MARK: - 항상 스코프 바가 표시되도록함
//        candySearchBar.searchBar.showsScopeBar = true
    }
    
}

extension CandyListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let datas = isSearched ? searchResult : dataModel
        guard let candies = datas else {
            fatalError("Row 개수 계산 중 오류 발생")
        }
        
        return candies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let datas = isSearched ? searchResult : dataModel
        guard let candies = datas else {
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

extension CandyListViewController : UISearchResultsUpdating {
    
    // MARK: - 서치바에 변화가 발생할 때마다 호출됩니다.
    func updateSearchResults(for searchController: UISearchController) {
        let selectedScope = searchController.searchBar.selectedScopeButtonIndex
        let typedText = searchController.searchBar.text?.lowercased() ?? ""
        if typedText == "" {searchResult = dataModel}
        else{
            searchResult = dataModel?.filter{
                $0.name?.lowercased().contains(typedText) ?? false
            }
        }
        if selectedScope != 0 {
            searchResult = searchResult?.filter{
                $0.category! == searchController.searchBar.scopeButtonTitles![selectedScope]
            }
        }
        self.candyTableView.performBatchUpdates {
            candyTableView.reloadSections(IndexSet.init(integer: .zero), with: .automatic)
        }
    }
    
    
}

extension CandyListViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {

        let typedText = searchBar.text?.lowercased() ?? ""
        if typedText == "" {searchResult = dataModel}
        else{
            searchResult = dataModel?.filter{
                $0.name?.lowercased().contains(typedText) ?? false
            }
        }
        if selectedScope != 0 {
            searchResult = searchResult?.filter{
                $0.category! == searchBar.scopeButtonTitles![selectedScope]
            }
        }
        self.candyTableView.performBatchUpdates {
            candyTableView.reloadSections(IndexSet.init(integer: .zero), with: .automatic)
        }
    }
}

