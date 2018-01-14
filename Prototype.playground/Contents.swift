
import UIKit

class Person: NSObject {
    enum Status {
        case initital, onTheWay, arrived, canceled
    }
    
    let name: String
    let photo: UIImage?
    var status: Status = .initital
    
    init(name: String, photo: UIImage?, status: Status = .initital) {
        self.name = name; self.photo = photo;
        super.init()
    }
}

extension Person: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return Person(name: name, photo: photo?.copy() as? UIImage, status: status)
    }
}

class Appointment: NSObject {
    let place: String
    let time: Date
    let people: [Person]
    
    init(place: String, time: Date, people: [Person]) {
        self.place = place; self.time = time; self.people = people
        super.init()
    }
}

extension Appointment: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let copiedPeople = people.flatMap { return $0.copy() as? Person }
        return Appointment(place: place, time: time, people: copiedPeople)
    }
}

/* Usage: */

let people = [ Person(name: "Petro", photo: nil),
               Person(name: "Maria", photo: nil),
               Person(name: "Stepan", photo: nil, status: .canceled) ]

/* Prototype */
let appointment = Appointment(place: "Lviv, Stepana Bandery str.", time: Date.distantFuture, people: people)

/* Cloned object */
let clone = appointment.copy() as? Appointment
