import UIKit

class UserDefaultsManager {
    static let shared = UserDefaultsManager()

    private let favoritesKey = "Favorites"

    var favoriteImages: [String] {
        get {
            return UserDefaults.standard.stringArray(forKey: favoritesKey) ?? []
        }
        set {
            let set = Set(newValue)
            let arr = Array(set)
            UserDefaults.standard.set(arr, forKey: favoritesKey)
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
        return favoriteImages.contains(imageIdentifier)
//        return UserDefaults.standard.bool(forKey: imageIdentifier)
    }


}
