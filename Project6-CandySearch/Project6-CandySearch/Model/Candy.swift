
import Foundation

struct Candy : Codable {
    var category : String?
    var name : String?
    
    // MARK: - 번들의 JSON파일에서 데이터를 로드합니다.
    static func loadData() -> [Candy]? {
        var candies : [Candy]?
        do {
            if let bundlePath = Bundle.main.path(forResource: "candies", ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                candies = try JSONDecoder().decode([Candy].self, from: jsonData)
            }
        } catch {
            print(error)
        }
        return candies
    }
}
