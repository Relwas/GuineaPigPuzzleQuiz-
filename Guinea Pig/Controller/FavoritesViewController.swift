import UIKit

@available(iOS 13.0, *)
class FavoriteViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ImagesImageCellDelegate {

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 24
        layout.minimumInteritemSpacing = 24
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    let emptyFavoritesLabel: UILabel = {
        let label = UILabel()
        label.text = "No favorites yet!"
        label.textAlignment = .center
        label.textColor = .labelAbout
        label.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var arr = UserDefaultsManager.shared.favoriteImages

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .colorBackNav
        collectionView.reloadData()
        updateEmptyFavoritesLabel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Fon")
        title = "Favorites"
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(named: "Fon")
        view.addSubview(collectionView)
        
        collectionView.register(BreedDetailImageCell.self, forCellWithReuseIdentifier: "imageCell")

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])

        view.addSubview(emptyFavoritesLabel)
        NSLayoutConstraint.activate([
            emptyFavoritesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyFavoritesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        updateEmptyFavoritesLabel()
    }

    // MARK: - UICollectionViewDataSource
    private func updateEmptyFavoritesLabel() {
        emptyFavoritesLabel.isHidden = !UserDefaultsManager.shared.favoriteImages.isEmpty
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserDefaultsManager.shared.favoriteImages.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.width + 10)
        let cellHeight: CGFloat = 300
        
        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! BreedDetailImageCell
        
        let imageName = arr[indexPath.row]
        
        if let image = UIImage(named: imageName) {
            cell.imageView.image = image
        } else {
            print("Image not found: \(imageName)")
            cell.imageView.image = UIImage(named: "MainPhoto")
        }
        cell.imageName = imageName
        cell.delegate = self
        cell.isFavorite = true
        
        let tintedHeartImage = UIImage(systemName: "heart.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)).withTintColor(UIColor(named: "HeartC")!, renderingMode: .alwaysOriginal)
        cell.heartButton.setImage(tintedHeartImage, for: .normal)

        return cell
    }
    
    func handleImageTap(_ cell: BreedDetailImageCell) {
    }

    func handleFavoriteTap(_ cell: BreedDetailImageCell, isFavorite: Bool, imageIdentifier: String) {
        arr = arr.filter{ $0 != imageIdentifier }
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
