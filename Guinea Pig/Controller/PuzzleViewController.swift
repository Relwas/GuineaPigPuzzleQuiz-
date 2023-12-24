import UIKit

@available(iOS 13.0, *)
class PuzzleViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    //MARK: Public Properties
    let gridSize = 4
    var puzzlePieces: [UIImage] = []
    var collectionView: UICollectionView!
    var selectedPieceIndex: IndexPath?
    var emptyPieceIndex: IndexPath?

    //MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .fon
        navigationController?.navigationBar.tintColor = .colorBackNav

        for i in 1...(gridSize * gridSize) {
            let imageName = "image\(i)"
            if let image = UIImage(named: imageName, in: Bundle.main, with: nil) {
                puzzlePieces.append(image)
            }
        }

//        for i in 1...4 {
//            let additionalImageName = "additionalImage\(i)"
//            if let additionalImage = UIImage(named: additionalImageName, in: Bundle.main, with: nil) {
//                puzzlePieces.append(additionalImage)
//            }
//        }
        
        shufflePuzzlePieces()

        let cellSize = (view.bounds.width - 30 - CGFloat(gridSize - 1) * 5) / CGFloat(gridSize)

        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .buttonBack
        backgroundView.layer.cornerRadius = 15
        backgroundView.clipsToBounds = true
        view.addSubview(backgroundView)

        // Create a collection view
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(PuzzleCell.self, forCellWithReuseIdentifier: PuzzleCell.identifier)
        collectionView.backgroundColor = .clear
        backgroundView.addSubview(collectionView)

        let totalGridHeight = CGFloat(gridSize) * cellSize + CGFloat(gridSize - 1) * 5

        let backgroundHeight = totalGridHeight + 15

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: backgroundHeight)
        ])
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            collectionView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, constant: -15),
            collectionView.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, constant: -15)
        ])
        collectionView.layer.cornerRadius = 10
        collectionView.layer.masksToBounds = true
    }

    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gridSize * gridSize
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PuzzleCell.identifier, for: indexPath) as! PuzzleCell

        cell.imageView.image = puzzlePieces[indexPath.item]

        return cell
    }
    
    //MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        handlePuzzlePieceTap(at: indexPath)
    }
    
    //MARK: Public Methods
    func resetVisualChanges() {
        collectionView.visibleCells.forEach { cell in
            if let puzzleCell = cell as? PuzzleCell {
                UIView.animate(withDuration: 0.3) {
                    puzzleCell.imageView.alpha = 1.0
                }
            }
        }

        collectionView.visibleCells.forEach { cell in
            if let puzzleCell = cell as? PuzzleCell {
                UIView.animate(withDuration: 0.3) {
                    puzzleCell.imageView.alpha = 1.0
                    puzzleCell.imageView.transform = CGAffineTransform.identity
                }
            }
        }
    }

    func handlePuzzlePieceTap(at indexPath: IndexPath) {
        if let selectedPieceIndex = selectedPieceIndex {
            swapPuzzlePieces(from: selectedPieceIndex, to: indexPath)
            self.selectedPieceIndex = nil

            if isPuzzleSolved() {
                showRestartAlert()
            }
        } else {
            selectedPieceIndex = indexPath

            if let cell = collectionView.cellForItem(at: indexPath) as? PuzzleCell {
                UIView.animate(withDuration: 0.3, animations: {
                    cell.imageView.alpha = 1
                    cell.imageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                })
            }
        }
    }

    func shufflePuzzlePieces() {
        var shuffledPieces = puzzlePieces
        for i in stride(from: shuffledPieces.count - 1, to: 0, by: -1) {
            let j = Int(arc4random_uniform(UInt32(i + 1)))
            shuffledPieces.swapAt(i, j)
        }
        
        puzzlePieces = shuffledPieces
    }

    func isPuzzleSolved() -> Bool {
        let correctOrder = (1...(gridSize * gridSize)).map { UIImage(named: "image\($0)")! }
        return puzzlePieces.elementsEqual(correctOrder, by: { $0.isEqual($1) })
    }

    func showRestartAlert() {
        let alert = UIAlertController(title: "Congratulations!", message: "You've solved the puzzle!", preferredStyle: .alert)
        
        let restartAction = UIAlertAction(title: "Start again", style: .default) { [self] _ in
            self.shufflePuzzlePieces()
            self.collectionView.reloadData()
            
            self.resetVisualChanges()
        }
        
        alert.addAction(restartAction)
        present(alert, animated: true, completion: nil)
    }
    
    func swapPuzzlePieces(from index1: IndexPath, to index2: IndexPath) {
        puzzlePieces.swapAt(index1.item, index2.item)
        resetVisualChanges()
        collectionView.reloadItems(at: [index1, index2])
    }

}


class PuzzleCell: UICollectionViewCell {
    static let identifier = "PuzzleCell"
    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupImageView()
    }

    private func setupImageView() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
