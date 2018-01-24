
/* Interfaces */

protocol PaperBookProtocol {
    func open()     /* method to open the book */
    func turnPage() /* method to turn pages */
}

protocol EBookProtocol {
    func pressStart() /* start the book */
    func pressNext()  /* go to next page */
}

/* Concrete classes */

class Kindle: EBookProtocol {
    func pressStart() {
        print("Kindle book launched!")
    }
    
    func pressNext() {
        print("Next page! Blazing fast.")
    }
}

class PaperBook: PaperBookProtocol {
    func open() {
        print("Opened a paper book. Oh that feeling!")
    }
    
    func turnPage() {
        print("Turned page. Oh, that old book crisp!")
    }
}

/* Adapter implementation */

final class EBookAdapter: PaperBookProtocol {
    private let eBook: EBookProtocol
    
    init(eBook: EBookProtocol) {
        self.eBook = eBook
    }

    func open() {
        self.eBook.pressStart()
    }

    func turnPage() {
        self.eBook.pressNext()
    }
}

/* Calling old book methods */

let paperBook = PaperBook()
paperBook.open()              // Opened a paper book. Oh that feeling!
paperBook.turnPage()          // Turned page. Oh, that old book crisp!

let oldFeelKindleBook = EBookAdapter(eBook: Kindle())

/* Calling old book legacy interface methods on new kindle */

oldFeelKindleBook.open()      // Kindle book launched!
oldFeelKindleBook.turnPage()  // Next page! Blazing fast.


