import UIKit

@available(iOS 13.0, *)
class BreedsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private let breedsManager = BreedsManager.shared
    private var breeds: [Breed] = []
    var breedNames: [String] {
        guard let breedsPath = Bundle.main.path(forResource: "Breeds", ofType: nil) else {
            return []
        }
        do {
            return try FileManager.default.contentsOfDirectory(atPath: breedsPath)
        } catch {
            return []
        }
    }

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.width - 60) / 2
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 100, right: 10)
        layout.itemSize = CGSize(width: width, height: width - 15)
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 80
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentMode = .scaleAspectFill
        collectionView.backgroundColor = UIColor(named: "Fon")
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .colorBackNav

        title = "Breeds"
        view.backgroundColor = UIColor(named: "Fon")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        breeds = breedsManager.getBreeds()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return breeds.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)

        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }

        let blackBackgroundView = UIView(frame: CGRect(x: 0, y: indexPath.item % 2 == 0 ? 38 : -5, width: UIScreen.main.bounds.width / 2 - 25, height: UIScreen.main.bounds.width / 2 + 10))
        blackBackgroundView.backgroundColor = UIColor(named: "buttonBack")
        blackBackgroundView.layer.cornerRadius = 15
        blackBackgroundView.clipsToBounds = false

        let imageView = UIImageView(frame: CGRect(x: 15, y: 0, width: UIScreen.main.bounds.width / 2 - 40, height: UIScreen.main.bounds.width / 2 - 20))

        let breed = breeds[indexPath.item]

        if let image = UIImage(named: breed.imageName) {
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.layer.shadowColor = UIColor.black.cgColor
            imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
            imageView.layer.shadowOpacity = 0.3
            imageView.layer.shadowRadius = 4
        } else {
            print("Failed to load image for breed: \(breed.name)")
        }

        blackBackgroundView.addSubview(imageView)

        let nameLabel = UILabel(frame: CGRect(x: 0, y: UIScreen.main.bounds.width / 2 - 20, width: UIScreen.main.bounds.width / 2 - 20, height: 30))
        nameLabel.text = breed.name
        nameLabel.textColor = UIColor(named: "LabelColor1")
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        blackBackgroundView.addSubview(nameLabel)

        cell.contentView.addSubview(blackBackgroundView)

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedBreed = breeds[indexPath.item].name
        let breedDetailVC = ImagesViewController(breedName: selectedBreed)
        breedDetailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(breedDetailVC, animated: true)
    }
}
