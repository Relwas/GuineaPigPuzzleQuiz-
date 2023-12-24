//
//  BreedsManager.swift
//  Guinea Pig
//
//  Created by relwas on 21/12/23.
//

import Foundation

class BreedsManager {
    static let shared = BreedsManager()

    private let breedNames: [String] = [
        "Abyssinian guinea pig",
        "Alpaca guinea pig",
        "American Guinea Pig",
        "Coronet guinea pig",
        "Crested guinea pig",
        "Lunkarya guinea pig",
        "Peruvian guinea pig",
        "Sheba guinea pig",
        "Silkie guinea pig",
        "Teddy guinea pig",
        "Funny guinea pig",
        "Satin guinea pig"
    ]

    func getBreeds() -> [Breed] {
        return breedNames.map { Breed(name: $0, imageName: getFirstImageForBreed($0) ?? "") }
    }

    private func getFirstImageForBreed(_ breedName: String) -> String? {
        guard let breedPath = Bundle.main.path(forResource: "Breeds/\(breedName)", ofType: nil),
              let imageFileName = try? FileManager.default.contentsOfDirectory(atPath: breedPath).first else {
            return nil
        }
        return "Breeds/\(breedName)/\(imageFileName)"
    }
}
