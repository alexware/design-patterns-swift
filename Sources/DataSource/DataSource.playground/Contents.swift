
import Foundation

protocol TableDataSource: class {
    func numberOfRows() -> Int
    func titleForRow(at index: Int) -> String
}

final class TableTextSource: TableDataSource {
    private let rows = ["First Row", "Second Row", "Third Row", "Fourth Row", "Fifth Row"]
    
    func numberOfRows() -> Int {
        return rows.count
    }
    
    func titleForRow(at index: Int) -> String {
        return rows[index]
    }
}

final class SimpleTextTableGenerator {
    weak var dataSource: TableDataSource?
    
    init(with dataSource: TableDataSource) {
        self.dataSource = dataSource
    }
    
    func create() -> String {
        var table = String()
        for row in 0..<rowsCount() {
            let title = titleForTableRow(row) ?? ""
            table.append("#\(row + 1): \(title)\n")
        }
        return table
    }
    
    private func rowsCount() -> Int {
        return dataSource?.numberOfRows() ?? 0
    }
    
    private func titleForTableRow(_ row: Int) -> String? {
        return dataSource?.titleForRow(at: row)
    }
}

/* Usage: */
let tableTextSource = TableTextSource()
let tableGenerator = SimpleTextTableGenerator(with: tableTextSource)
let textTable = tableGenerator.create()
print(textTable)



