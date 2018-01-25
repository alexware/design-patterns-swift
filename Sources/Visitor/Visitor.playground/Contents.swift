
import Foundation

protocol ReportVisitor {
    func visit(_ contract: FixedPriceContract)
    func visit(_ contract: TimeAndMaterialsContract)
    func visit(_ contract: SupportContract)
}

protocol ReportVisitable {
    func accept(visitor: ReportVisitor)
}

final class FixedPriceContract: ReportVisitable {
    let costPerYear: Int
    
    init(costPerYear: Int) {
        self.costPerYear = costPerYear
    }
    
    func accept(visitor: ReportVisitor) {
        visitor.visit(self)
    }
}

final class TimeAndMaterialsContract: ReportVisitable {
    let costPerHour: Int
    let hours: Int
    
    init(hours: Int, costPerHour: Int) {
        self.hours = hours; self.costPerHour = costPerHour
    }

    func accept(visitor: ReportVisitor) {
         visitor.visit(self)
    }
}

final class SupportContract: ReportVisitable {
    let costPerMonth: Int
    
    init(costPerMonth: Int) {
        self.costPerMonth = costPerMonth
    }
    
    func accept(visitor: ReportVisitor) {
         visitor.visit(self)
    }
}

class MonthlyCostReportVisitor: ReportVisitor {
    private var _monthlyCost: Int = 0
    
    var monthlyCost: Int {
        return _monthlyCost
    }
    
    func visit(_ contract: FixedPriceContract) {
        _monthlyCost += contract.costPerYear / 12
    }
    
    func visit(_ contract: TimeAndMaterialsContract) {
        _monthlyCost += contract.costPerHour * contract.hours
    }
    
    func visit(_ contract: SupportContract) {
        _monthlyCost += contract.costPerMonth
    }
}

/* Usage: */

let projects: [ReportVisitable] = [
    FixedPriceContract(costPerYear: 100000),
    SupportContract(costPerMonth: 5000),
    TimeAndMaterialsContract(hours: 300, costPerHour: 10),
    TimeAndMaterialsContract(hours: 50, costPerHour: 50)
]
let monthlyCostReportVisitor = MonthlyCostReportVisitor()
projects.forEach {
    $0.accept(visitor: monthlyCostReportVisitor)
}

print("Monthly Bill: \(monthlyCostReportVisitor.monthlyCost)$")
