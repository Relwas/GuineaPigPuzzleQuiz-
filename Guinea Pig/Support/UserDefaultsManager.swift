import UIKit

class UserDefaultsManager {
    static let shared = UserDefaultsManager()

    private let favoritesKey = "Favorites"

    var favoriteImages: [String] {
        get {
            return UserDefaults.standard.stringArray(forKey: favoritesKey) ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: favoritesKey)
        }
    }

    func addFavoriteImage(imageName: String) {
        var favorites = favoriteImages
        favorites.append(imageName)
        favoriteImages = favorites
    }

    func removeFavoriteImage(imageName: String) {
        var favorites = favoriteImages
        if let index = favorites.firstIndex(of: imageName) {
            favorites.remove(at: index)
            favoriteImages = favorites
        }
    }

    func getFavoriteImages() -> [String] {
        return favoriteImages
    }

    func isFavoriteImage(imageIdentifier: String) -> Bool {
        return UserDefaults.standard.bool(forKey: imageIdentifier)
    }


}
