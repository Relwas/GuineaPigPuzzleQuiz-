
import Foundation

class GuineoPigModel {
    let breedsFolder = "Breeds"

    var breedsData: [String: [String]] = [:]

    init() {
        loadBreedsData()
    }

    func loadBreedsData() {
        let bundle = Bundle.main

        guard let breedsFolderURL = bundle.url(forResource: breedsFolder, withExtension: nil),
              let breedFolderPaths = try? FileManager.default.contentsOfDirectory(atPath: breedsFolderURL.path) else {
            return
        }

        for breedFolder in breedFolderPaths {
            let breedName = breedFolder
            let breedPath = breedsFolderURL.appendingPathComponent(breedFolder)

            if let images = try? FileManager.default.contentsOfDirectory(atPath: breedPath.path) {
                breedsData[breedName] = images
            }
        }
    }

    func getAllBreeds() -> [String] {
        return Array(breedsData.keys)
    }

    func getImagesForBreed(breedName: String) -> [String] {
        return breedsData[breedName] ?? []
    }

    func getRandomImageForBreed(breedName: String) -> String? {
        guard let images = breedsData[breedName], !images.isEmpty else {
            return nil
        }

        let randomIndex = Int(arc4random_uniform(UInt32(images.count)))
        return images[randomIndex]
    }
}
