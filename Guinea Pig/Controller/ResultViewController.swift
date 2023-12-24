import UIKit
import AVFoundation
import SPConfetti

@available(iOS 13.0, *)
class ResultViewController: UIViewController {
    private var audioPlayer: AVAudioPlayer?

    private let correctAnswers: Int
    var completion: (() -> Void)?
    var tryAgainCallback: (() -> Void)?

    init(correctAnswers: Int) {
        self.correctAnswers = correctAnswers
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startConfettiAnimation()
        playResultSound()
    }

    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "Fon")
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        configureUI()
        setupAudioPlayer()
    }

    private func configureUI() {
        // Image
        let congratsImageView = UIImageView(image: UIImage(named: "congratsImage"))
        congratsImageView.contentMode = .scaleAspectFill
        congratsImageView.layer.cornerRadius = 12
        congratsImageView.clipsToBounds = true
        congratsImageView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(congratsImageView)

        // Congratulations label
        let congratulationsLabel = UILabel()
        congratulationsLabel.text = "Congratulations on your impressive score!"
        congratulationsLabel.textAlignment = .center
        congratulationsLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        congratulationsLabel.textColor = .colorLabel1
        congratulationsLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(congratulationsLabel)

        // Result label
        let resultLabel = UILabel()
        resultLabel.text = "Correct answers: \(correctAnswers)\nWell done"
        resultLabel.textAlignment = .center
        resultLabel.font = UIFont(name: "AvenirNext-Regular", size: 18)
        resultLabel.textColor = .colorLabel1
        resultLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(resultLabel)

        // Black background view behind the button
        let blackBackgroundView = UIView()
        blackBackgroundView.layer.cornerRadius = 20
        blackBackgroundView.backgroundColor = .backg
        blackBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blackBackgroundView)

        // Button
        let homeButton = UIButton(type: .custom)
        homeButton.setTitle("Go back", for: .normal)
        homeButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        homeButton.setTitleColor(UIColor(named: "LabelColor1"), for: .normal)
        homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
        homeButton.contentMode = .scaleAspectFit
        homeButton.backgroundColor = .buttonBack
        homeButton.layer.cornerRadius = 20
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(homeButton)

        // Constraints
        NSLayoutConstraint.activate([
            congratsImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            congratsImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            congratsImageView.widthAnchor.constraint(equalToConstant: 300),
            congratsImageView.heightAnchor.constraint(equalToConstant: 270),

            congratulationsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            congratulationsLabel.topAnchor.constraint(equalTo: congratsImageView.bottomAnchor, constant: 20),

            resultLabel.topAnchor.constraint(equalTo: congratulationsLabel.bottomAnchor, constant: 20),
            resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            homeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            homeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            homeButton.widthAnchor.constraint(equalToConstant: 290),
            homeButton.heightAnchor.constraint(equalToConstant: 68),

            blackBackgroundView.leadingAnchor.constraint(equalTo: homeButton.leadingAnchor),
            blackBackgroundView.trailingAnchor.constraint(equalTo: homeButton.trailingAnchor, constant: 3),
            blackBackgroundView.topAnchor.constraint(equalTo: homeButton.topAnchor),
            blackBackgroundView.bottomAnchor.constraint(equalTo: homeButton.bottomAnchor, constant: 3),
        ])
    }

    //MARK: Private
    private func playResultSound() {
        if UserDefaults.standard.bool(forKey: "SoundSetting") {
            audioPlayer?.play()
        }
    }

    private func setupAudioPlayer() {
        if let soundURL = Bundle.main.url(forResource: "resultSound", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.prepareToPlay()
            } catch {
                print("Error loading result sound file: \(error.localizedDescription)")
            }
        } else {
            print("Result Sound file not found.")
        }
    }

    private func startConfettiAnimation() {
        SPConfetti.startAnimating(.fullWidthToDown, particles: [.star, .arc, .heart, .polygon])
    }
    private func stopConfettiAnimation() {
        SPConfetti.stopAnimating()
    }
    @objc private func homeButtonTapped() {
        stopConfettiAnimation()
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        navigationController?.popToRootViewController(animated: true)
    }
}
