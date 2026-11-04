import Foundation

@MainActor
final class RestaurantInfoPresenter: RestaurantInfoPresenterProtocol, RestaurantInfoInteractorOutputProtocol {

    weak var view: RestaurantInfoViewProtocol?
    private let interactor: RestaurantInfoInteractorInputProtocol
    private let router: RestaurantInfoRouterProtocol

    init(view: RestaurantInfoViewProtocol,
         interactor: RestaurantInfoInteractorInputProtocol,
         router: RestaurantInfoRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    nonisolated deinit {}

    func viewDidLoad() {
        interactor.loadFacts()
    }

    func didTapDone() {
        router.close()
    }

    func didLoadFacts(_ facts: RestaurantFacts) {
        // TODO 3: Tell the view the title, and the rows to show.
        view?.showTitle(facts.name)
                
        let rows = makeRows(from: facts)
        view?.showRows(rows)
    }


    func makeRows(from facts: RestaurantFacts) -> [InfoRowViewModel] {
        // TODO 4: Turn the facts into rows of text. The tests in
        // RestaurantInfoPresenterTests show some of the rows we expect, e.g.
        // "Status" / "Closed", and "Menu" / "6 dishes (1 sold out today)".
        
        
        var rows: [InfoRowViewModel] = []
                
        // status row
        let statusValue = facts.isOpen ? "Open now" : "Closed"
        rows.append(InfoRowViewModel(title: "Status", value: statusValue))
        
        // cuisine row
        rows.append(InfoRowViewModel(title: "Cuisine", value: facts.cuisine))
        
        // rating row (e.g., "★ 4.6")
        rows.append(InfoRowViewModel(title: "Rating", value: "★ \(facts.rating)"))
        
        // delivery time row
        rows.append(InfoRowViewModel(title: "Delivery Time", value: "\(facts.deliveryMinutes) mins"))
        
        // delivery fee row (formatted to 2 decimal places)
        let formattedFee = String(format: "$%.2f", NSDecimalNumber(decimal: facts.deliveryFee).doubleValue)
        rows.append(InfoRowViewModel(title: "Delivery Fee", value: formattedFee))
        
        // menu row (e.g., "8 dishes" or "8 dishes (1 sold out today)")
        let dishText = facts.dishCount == 1 ? "dish" : "dishes"
        var menuValue = "\(facts.dishCount) \(dishText)"

        if facts.soldOutCount > 0 {
            menuValue += " (\(facts.soldOutCount) sold out today)"
        }
        rows.append(InfoRowViewModel(title: "Menu", value: menuValue))

        // spicy row
        if facts.spicyCount > 0 {
            rows.append(InfoRowViewModel(title: "Spicy", value: "\(facts.spicyCount)"))
        }
        
        return rows
        
    }
}
