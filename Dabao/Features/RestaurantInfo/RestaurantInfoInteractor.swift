import Foundation

@MainActor
final class RestaurantInfoInteractor: RestaurantInfoInteractorInputProtocol {

    weak var output: RestaurantInfoInteractorOutputProtocol?
    private let restaurant: Restaurant

    init(restaurant: Restaurant) {
        self.restaurant = restaurant
    }

    func loadFacts() {
        // TODO 2: Work out the facts about `restaurant`, put them in a `RestaurantFacts`,
        // and send them to the presenter through `output`.
        // Hint: `filter` and `count` will help with the sold-out and spicy counts.
        
        // 1. Get the menu items to calculate counts
        let menuItems = restaurant.menu
        
        let dishCount = menuItems.count
        let spicyCount = menuItems.filter { $0.isSpicy }.count
        let soldOutCount = menuItems.filter { $0.isSoldOut }.count
        
        let facts = RestaurantFacts(
            name: restaurant.name,
            cuisine: restaurant.cuisine,
            rating: restaurant.rating,
            deliveryMinutes: restaurant.deliveryMinutes,
            deliveryFee: restaurant.deliveryFee,
            isOpen: restaurant.isOpen,
            dishCount: dishCount,
            soldOutCount: soldOutCount,
            spicyCount: spicyCount
        )

        // send the facts to the presenter
        output?.didLoadFacts(facts)
    }
}
