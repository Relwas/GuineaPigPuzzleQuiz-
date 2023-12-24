import UIKit
import AVFoundation

struct Question {
    let imageURL: String
    let correctAnswer: String
    let incorrectAnswers: [String]
}

@available(iOS 13.0, *)
class QuizViewController: UIViewController {
    private var correctSoundPlayer: AVAudioPlayer?
    private var incorrectSoundPlayer: AVAudioPlayer?
    private var correctAnswers = 0
    private var questions: [Question] = []
    private var currentQuestionIndex = 0
    private var musicPlayer: AVAudioPlayer?

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        return imageView
    }()

    private let questionLabel: UILabel = {
        let label = UILabel()
        label.text = "What kind of breed is this?"
        label.textColor = .colorLabel1
        label.font = UIFont(name: "DevanagariSangamMN-Bold", size: 21.0)
        label.textAlignment = .center
        return label
    }()

    private let answerButton1 = UIButton()
    private let answerButton2 = UIButton()
    private let answerButton3 = UIButton()
    private let answerButton4 = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Fon")
        setupViews()
        loadQuestions()
        showCurrentQuestion()

        loadSound(named: "correctSound", into: &correctSoundPlayer)
        loadSound(named: "incorrectSound", into: &incorrectSoundPlayer)

        NotificationCenter.default.addObserver(self, selector: #selector(updateVibrationSetting), name: Notification.Name("VibrationSettingChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateSoundSetting), name: Notification.Name("SoundSettingChanged"), object: nil)
    }

    private func setupViews() {
        let blackBackgroundView1 = createBlackBackgroundView()
        let blackBackgroundView2 = createBlackBackgroundView()
        let blackBackgroundView3 = createBlackBackgroundView()
        let blackBackgroundView4 = createBlackBackgroundView()

        view.addSubview(blackBackgroundView1)
        view.addSubview(blackBackgroundView2)
        view.addSubview(blackBackgroundView3)
        view.addSubview(blackBackgroundView4)
        view.addSubview(imageView)
        view.addSubview(questionLabel)
        view.addSubview(answerButton1)
        view.addSubview(answerButton2)
        view.addSubview(answerButton3)
        view.addSubview(answerButton4)
        navigationController?.navigationBar.tintColor = .colorBackNav

        let buttonFont = UIFont(name: "Avenir-Medium", size: 17.0)
        let buttonTitleColor = UIColor.white

        for button in [answerButton1, answerButton2, answerButton3, answerButton4] {
            button.titleLabel?.font = buttonFont
            button.tintColor = buttonTitleColor
            button.translatesAutoresizingMaskIntoConstraints = false
            button.layer.cornerRadius = 20
            button.backgroundColor = .buttonBack
            button.addTarget(self, action: #selector(answerButtonTapped(_:)), for: .touchUpInside)
        }

        imageView.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        answerButton2.translatesAutoresizingMaskIntoConstraints = false
        answerButton3.translatesAutoresizingMaskIntoConstraints = false
        answerButton4.translatesAutoresizingMaskIntoConstraints = false

        let buttonHeightConstant: CGFloat = view.bounds.height * 0.1 - 20

        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.2 - 30),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 250),
            imageView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 30),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            answerButton1.bottomAnchor.constraint(equalTo: answerButton2.topAnchor, constant: -10),
            answerButton1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            answerButton1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            answerButton1.heightAnchor.constraint(equalToConstant: buttonHeightConstant),
            answerButton2.bottomAnchor.constraint(equalTo: answerButton3.topAnchor, constant: -10),
            answerButton2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            answerButton2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            answerButton2.heightAnchor.constraint(equalToConstant: buttonHeightConstant),
            answerButton3.bottomAnchor.constraint(equalTo: answerButton4.topAnchor, constant: -10),
            answerButton3.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            answerButton3.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            answerButton3.heightAnchor.constraint(equalToConstant: buttonHeightConstant),
            answerButton4.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            answerButton4.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            answerButton4.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            answerButton4.heightAnchor.constraint(equalToConstant: buttonHeightConstant),
            blackBackgroundView1.topAnchor.constraint(equalTo: answerButton1.topAnchor, constant: 2),
            blackBackgroundView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            blackBackgroundView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -17),
            blackBackgroundView1.heightAnchor.constraint(equalTo: answerButton1.heightAnchor),
            blackBackgroundView2.topAnchor.constraint(equalTo: answerButton2.topAnchor, constant: 2),
            blackBackgroundView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            blackBackgroundView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -17),
            blackBackgroundView2.heightAnchor.constraint(equalTo: answerButton2.heightAnchor),
            blackBackgroundView3.topAnchor.constraint(equalTo: answerButton3.topAnchor, constant: 2),
            blackBackgroundView3.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            blackBackgroundView3.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -17),
            blackBackgroundView3.heightAnchor.constraint(equalTo: answerButton3.heightAnchor),
            blackBackgroundView4.topAnchor.constraint(equalTo: answerButton4.topAnchor, constant: 2),
            blackBackgroundView4.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            blackBackgroundView4.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -17),
            blackBackgroundView4.heightAnchor.constraint(equalTo: answerButton4.heightAnchor),
        ])
    }
    func createBlackBackgroundView() -> UIView {
        let blackView = UIView()
        blackView.translatesAutoresizingMaskIntoConstraints = false
        blackView.backgroundColor = .black
        blackView.layer.cornerRadius = 20
        blackView.layer.masksToBounds = true
        return blackView
    }

    private func loadSound(named fileName: String, into player: inout AVAudioPlayer?) {
        if let soundURL = Bundle.main.url(forResource: fileName, withExtension: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: soundURL)
                player?.prepareToPlay()
            } catch let error {
                print("Error loading \(fileName) sound: \(error.localizedDescription)")
            }
        } else {
            print("Could not find \(fileName) sound file.")
        }
    }

    private func loadQuestions() {
        if let breedsURL = Bundle.main.url(forResource: "Breeds", withExtension: nil),
           let breedNames = try? FileManager.default.contentsOfDirectory(atPath: breedsURL.path) {

            var questionCount = 0

            for breedName in breedNames {
                let correctAnswer = breedName
                let incorrectAnswers = breedNames.filter { $0 != correctAnswer }

                let shuffledIncorrectAnswers = incorrectAnswers.shuffled().prefix(3)

                if let imageNames = try? FileManager.default.contentsOfDirectory(atPath: "\(breedsURL.path)/\(breedName)") {
                    if let randomImageName = imageNames.shuffled().first {
                        let question = Question(
                            imageURL: "\(breedsURL.path)/\(breedName)/\(randomImageName)",
                            correctAnswer: correctAnswer,
                            incorrectAnswers: Array(shuffledIncorrectAnswers)
                        )

                        questions.append(question)
                        questionCount += 1

                        if questionCount >= 15 {
                            break
                        }
                    }
                }
            }
        }
    }

    private func showCurrentQuestion() {
        guard currentQuestionIndex < questions.count else {
            return
        }

        let currentQuestion = questions[currentQuestionIndex]

        imageView.image = UIImage(named: currentQuestion.imageURL)
        questionLabel.text = "What kind of breed is this?"

        let shuffledAnswers = (currentQuestion.incorrectAnswers + [currentQuestion.correctAnswer]).shuffled()

        for (button, title) in zip([answerButton1, answerButton2, answerButton3, answerButton4], shuffledAnswers) {
            button.setTitle(title, for: .normal)
        }
    }

    private func moveToNextQuestion() {
        guard currentQuestionIndex < questions.count else {
            endQuiz()
            return
        }

        currentQuestionIndex += 1
        if currentQuestionIndex < questions.count {
            showCurrentQuestion()
        } else {
            endQuiz()
        }
    }

    private func endQuiz() {
        showResultController(correctAnswers: correctAnswers)
    }

    private func showResultController(correctAnswers: Int) {
        let resultController = ResultViewController(correctAnswers: correctAnswers)
        resultController.tryAgainCallback = { [weak self] in
            self?.startNewQuiz()
        }
        resultController.modalPresentationStyle = .fullScreen
        present(resultController, animated: true)
    }

    private func playMusic(musicName: String) {
        if UserDefaults.standard.bool(forKey: "SoundSetting"), let musicURL = Bundle.main.url(forResource: musicName, withExtension: "mp3") {
            do {
                musicPlayer = try AVAudioPlayer(contentsOf: musicURL)
                musicPlayer?.prepareToPlay()
                musicPlayer?.play()
            } catch let error {
                print("Error playing music: \(error.localizedDescription)")
            }
        }
    }

    @objc func updateSoundSetting() {
        if let isSoundEnabled = UserDefaults.standard.value(forKey: "SoundSetting") as? Bool {
            if isSoundEnabled {
                playMusic(musicName: "your_music_file_name")
            } else {
                stopMusic()
            }
        }
    }

    private func stopMusic() {
        musicPlayer?.stop()
        musicPlayer = nil
    }

    internal func startNewQuiz() {
        correctAnswers = 0
        currentQuestionIndex = 0
        questions.removeAll()
        loadQuestions()
        showCurrentQuestion()
    }

    @objc func updateVibrationSetting(_ notification: Notification) {
        if let isVibrationEnabled = notification.userInfo?["isVibrationEnabled"] as? Bool {
            VibrationManager.shared.isVibrationEnabled = isVibrationEnabled
        }
    }

    @objc private func answerButtonTapped(_ sender: UIButton) {
        guard currentQuestionIndex < questions.count else {
            return
        }

        let isCorrectAnswer = sender.title(for: .normal) == questions[currentQuestionIndex].correctAnswer
        if isCorrectAnswer {
            correctAnswers += 1
            if UserDefaults.standard.bool(forKey: "SoundSetting") {
                correctSoundPlayer?.play()
            }
            sender.backgroundColor = .correct1
        } else {
            if UserDefaults.standard.bool(forKey: "SoundSetting") {
                incorrectSoundPlayer?.play()
            }
            sender.backgroundColor = .incorrect1
        }
        if VibrationManager.shared.isVibrationEnabled {
            isCorrectAnswer ? VibrationManager.shared.vibrateSuccess() : VibrationManager.shared.vibrateError()
        }
        for button in [answerButton1, answerButton2, answerButton3, answerButton4] {
            button.isUserInteractionEnabled = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.moveToNextQuestion()
            self.resetButtonColors()
            for button in [self.answerButton1, self.answerButton2, self.answerButton3, self.answerButton4] {
                button.isUserInteractionEnabled = true
            }
        }
    }

    private func resetButtonColors() {
        for button in [answerButton1, answerButton2, answerButton3, answerButton4] {
            button.backgroundColor = .buttonBack
        }
    }
}
