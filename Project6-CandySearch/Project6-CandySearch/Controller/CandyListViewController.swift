
import UIKit

class CandyListViewController: UIViewController {
    
    var dataModel : [Candy]?
    var searchResult : [Candy]?
    var candySearchBar = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var candyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    // MARK: - 간접 세그웨이를 통해 다음 화면으로 데이터 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "candySelected" {
                
                let datas = candySearchBar.isActive ? searchResult : dataModel
                guard let candies = datas, let nextVC =  segue.destination as? CandyDetailViewController, let currentRow = sender as? Int else{
                    return
                }
                nextVC.currentCandy = candies[currentRow]
            }
        }
    
    func setUI() {
        getDataModel()
        setSearchBar()
        setNavigationBar()
    }
    
    func setNavigationBar() {
        // MARK: - 네비게이션 바 배경색 설정
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.backgroundColor = .systemGreen
        navigationController?.navigationBar.standardAppearance = navigationAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationAppearance
        navigationController?.navigationBar.compactAppearance = navigationAppearance
        navigationController?.navigationBar.compactScrollEdgeAppearance = navigationAppearance
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        
        // MARK: - 네비게이션 바 타이틀 이미지로 설정
        let titleImageVIew = {
            let imageView = UIImageView(image: UIImage(named: "Inline-Logo"))
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        self.navigationItem.titleView = titleImageVIew
        
        // MARK: - 네비게이션 바 서치 바 설정 및 스크롤 중에도 보이도록 합니다.(기본적으로 숨김)
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = candySearchBar
    }
    
    func getDataModel() {
        dataModel = Candy.loadData()
    }

    
    func setSearchBar() {
        candySearchBar.searchBar.scopeButtonTitles = ["All","Chocolate","Hard","Other"]
        
        // MARK: - UISearchResultsUpdating의 delegate 설정
        candySearchBar.searchResultsUpdater = self
        
        // MARK: - 검색 중에 서치 바 영역 제외 백그라운드 어둡게 변경(default : true)
        candySearchBar.obscuresBackgroundDuringPresentation = false
        
        /*
         자동으로 cancel 버튼 활성화(default : true)
         candySearchBar.automaticallyShowsCancelButton
         
         서치 바 활성화 시 네비게이션 타이틀 숨기기(default : true)
         candySearchBar.hidesNavigationBarDuringPresentation
         
         항상 스코프 바가 표시되도록함(default : false)
         candySearchBar.searchBar.showsScopeBar
         */
    }
    
    // MARK: - 현재 서치바의 텍스트 입력상태 및 스코프를 검사하여 참조 데이터 모델을 업데이트합니다.
    func checkSearchBar(_ typedText : String, _ scope : Int) {
        if typedText.isEmpty {
            searchResult = dataModel
        }else {
            searchResult = dataModel?.filter{
                $0.name?.lowercased().contains(typedText) ?? false
            }
        }
        if scope != 0 {
            searchResult = searchResult?.filter{
                $0.category! == candySearchBar.searchBar.scopeButtonTitles![scope]
            }
        }
    }
    
}

extension CandyListViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let datas = candySearchBar.isActive ? searchResult : dataModel
        guard let candies = datas else {
            fatalError("Row 개수 계산 중 오류 발생")
        }
        return candies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let datas = candySearchBar.isActive ? searchResult : dataModel
        guard let candies = datas else {
            fatalError("셀 설정 중 오류 발생")
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "candycell", for: indexPath)
        
        // MARK: - 셀 UI 설정
        var cellConfiguration = cell.defaultContentConfiguration()
        cellConfiguration.text = candies[indexPath.row].name
        cellConfiguration.secondaryText = candies[indexPath.row].category
        cell.contentConfiguration = cellConfiguration
        
        return cell
    }
    
}

extension CandyListViewController : UITableViewDelegate {
    
    // MARK: - 셀 선택 시 간접 세그웨이를 통해 prepare 메서드가 호출되도록 함
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "candySelected", sender: indexPath.row)
    }
}

extension CandyListViewController : UISearchResultsUpdating {
    
    // MARK: - 서치바(스코프 바 포함)에 변화가 발생할 때마다 호출됩니다.
    func updateSearchResults(for searchController: UISearchController) {
        //현재 선택된 스코프 인덱스
        let selectedScope = searchController.searchBar.selectedScopeButtonIndex
        //현재 서치바의 입력된 텍스트
        let typedText = searchController.searchBar.text?.lowercased() ?? ""
        
        checkSearchBar(typedText, selectedScope)
        
        // MARK: - 데이터 모델의 변경사항을 테이블에 반영합니다
        self.candyTableView.performBatchUpdates {
            candyTableView.reloadSections(IndexSet.init(integer: .zero), with: .automatic)
        }
    }
    
}
