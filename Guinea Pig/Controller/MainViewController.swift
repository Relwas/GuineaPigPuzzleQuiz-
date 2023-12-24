//
//  ViewController.swift
//  Guinea Pig
//
//  Created by relwas on 20/12/23.
//

import UIKit
import FLAnimatedImage

@available(iOS 13.0, *)
class MainViewController: UIViewController {
    
    let mainView = MainView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Fon")
        targetButtons()
    }
   
    //MARK: Public
    func targetButtons() {
        mainView.breedButton
            .addTarget(self, action: #selector(breedsButtonTapped), for: .touchUpInside)
        mainView.gameButton.addTarget(self, action: #selector(gameButtonTapped), for: .touchUpInside)
        mainView.favoritesButton.addTarget(self, action: #selector(favoritesButtonTapped), for: .touchUpInside)
        mainView.settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)

    }
    
    //MARK: Private
    @objc private func breedsButtonTapped() {
        let breedVC = BreedsViewController()
        navigationController?.pushViewController(breedVC, animated: true)
    }

    
    @objc private func gameButtonTapped() {
        let gameVC = GameViewController()
        navigationController?.pushViewController(gameVC, animated: true)
    }
    
    @objc private func favoritesButtonTapped() {
        let favVC = FavoriteViewController()
        navigationController?.pushViewController(favVC, animated: true)

    }
    
    @objc private func settingsButtonTapped() {
        let setVC = SettingsViewController()
        navigationController?.pushViewController(setVC, animated: true)
    }
}
