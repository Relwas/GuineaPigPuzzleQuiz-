import UIKit

@available(iOS 13.0, *)
class ImagesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ImagesImageCellDelegate {
    
    
    func handleFavoriteTap(_ cell: BreedDetailImageCell, isFavorite: Bool, imageIdentifier: String) {
        print("handleFavoriteTap")
        UserDefaults.standard.set(isFavorite, forKey: imageIdentifier)
    }
    

    let breedName: String
    var collectionView: UICollectionView!
    var breedImages: [UIImage] = []
    var arr: [String] = []

    init(breedName: String) {
        self.breedName = breedName
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .colorBackNav
        view.backgroundColor = UIColor(named: "Fon")
        title = breedName

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 35
        layout.minimumInteritemSpacing = 35

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BreedDetailImageCell.self, forCellWithReuseIdentifier: "imageCell")
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)

        breedImages = getImagesForBreed(breedName)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return breedImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! BreedDetailImageCell
        cell.imageView.image = breedImages[indexPath.item]
        cell.delegate = self
        cell.imageName = "Breeds/\(breedName)/\(arr[indexPath.row])"

        let isFavorite = UserDefaultsManager.shared.isFavoriteImage(imageIdentifier: cell.imageName!)
        cell.isFavorite = isFavorite
        let heartImageName = isFavorite ? "heart.fill" : "heart"
        let tintedHeartImage = UIImage(systemName: heartImageName)?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)).withTintColor(UIColor(named: "HeartC")!, renderingMode: .alwaysOriginal)
        cell.heartButton.setImage(tintedHeartImage, for: .normal)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.frame.width
        let cellWidth = collectionViewWidth - 20
        let cellHeight: CGFloat = 300
        
        return CGSize(width: cellWidth, height: cellHeight)
    }


    func getImagesForBreed(_ breedName: String) -> [UIImage] {
        var images: [UIImage] = []

        guard let breedPath = Bundle.main.path(forResource: "Breeds/\(breedName)", ofType: nil),
              let imageFileNames = try? FileManager.default.contentsOfDirectory(atPath: breedPath) else {
            print("Error: Could not find images for breed \(breedName)")
            return images
        }
        for imageName in imageFileNames {
            if let imagePath = Bundle.main.path(forResource: "Breeds/\(breedName)/\(imageName)", ofType: nil),
               let image = UIImage(contentsOfFile: imagePath) {
                images.append(image)
                let str = URL(string: imagePath)?.lastPathComponent ?? ""
                arr.append(str)
            } else {
                print("Error: Could not load image \(imageName) for breed \(breedName)")
            }
        }
        return images
    }
    func handleImageTap(_ cell: BreedDetailImageCell) {
        print("hello")
    }
}

@available(iOS 13.0, *)
class BreedDetailImageCell: UICollectionViewCell {
    let imageView = UIImageView()
    let shadowView = UIView()
    var imageIdentifier: String?
    let heartButton = UIButton(type: .system)
    let backgroundView2 = UIView()
    var imageName: String?

    var isFavorite = false
    weak var delegate: ImagesImageCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        shadowView.clipsToBounds = false
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowColor = UIColor.gray.cgColor
        shadowView.layer.shadowOpacity = 0.2
        shadowView.layer.shadowRadius = 3
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        
        backgroundView2.backgroundColor = UIColor(named: "buttonBack")
        backgroundView2.layer.cornerRadius = 10
        backgroundView2.layer.masksToBounds = true
        
        let heartImage = UIImage(systemName: "heart")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)).withTintColor(UIColor.heartC, renderingMode: .alwaysOriginal)
        heartButton.setImage(heartImage, for: .normal)
        heartButton.backgroundColor = UIColor(named: "buttonBack")?.withAlphaComponent(0.5)
        heartButton.layer.cornerRadius = 10
        heartButton.addTarget(self, action: #selector(handleHeartTap), for: .touchUpInside)
        
        contentView.addSubview(shadowView)
        contentView.addSubview(backgroundView2)
        
        backgroundView2.addSubview(imageView)
        backgroundView2.addSubview(heartButton)

        shadowView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView2.translatesAutoresizingMaskIntoConstraints = false
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: contentView.topAnchor),
            shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            shadowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: shadowView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor, constant: 3),
            imageView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: -3),
            imageView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            
            backgroundView2.topAnchor.constraint(equalTo: imageView.topAnchor, constant: -5),
            backgroundView2.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -5),
            backgroundView2.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 0),
            backgroundView2.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0),
            
            heartButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0),
            heartButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 0),
            heartButton.widthAnchor.constraint(equalToConstant: 50),
            heartButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleImageTap))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
    }
    
    @objc private func handleImageTap() {
        delegate?.handleImageTap(self)
    }
    
    @objc private func handleHeartTap() {
        isFavorite.toggle()
        print("isFavorite: \(isFavorite)")

        guard let imageName = self.imageName else {
            return
        }

        let heartImageName = isFavorite ? "heart.fill" : "heart"
        let tintedHeartImage = UIImage(systemName: heartImageName)?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)).withTintColor(UIColor(named: "HeartC")!, renderingMode: .alwaysOriginal)

        heartButton.setImage(tintedHeartImage, for: .normal)

        if isFavorite {
            UserDefaultsManager.shared.addFavoriteImage(imageName: imageName)
        } else {
            UserDefaultsManager.shared.removeFavoriteImage(imageName: imageName)
        }

        delegate?.handleFavoriteTap(self, isFavorite: isFavorite, imageIdentifier: imageName)
    }

}

@available(iOS 13.0, *)
protocol ImagesImageCellDelegate: AnyObject {
    func handleImageTap(_ cell: BreedDetailImageCell)
    func handleFavoriteTap(_ cell: BreedDetailImageCell, isFavorite: Bool, imageIdentifier: String)
}
