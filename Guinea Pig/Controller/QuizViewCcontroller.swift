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
        label.textColor = UIColor(named: "LabelColor1")
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 22.0)
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
        view.addSubview(imageView)
        view.addSubview(questionLabel)
        view.addSubview(answerButton1)
        view.addSubview(answerButton2)
        view.addSubview(answerButton3)
        view.addSubview(answerButton4)

        let buttonFont = UIFont(name: "AvenirNext-DemiBold", size: 16.0)
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

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 250),

            questionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            answerButton1.bottomAnchor.constraint(equalTo: answerButton2.topAnchor, constant: -10),
            answerButton1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            answerButton1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            answerButton1.heightAnchor.constraint(equalToConstant: 45),

            answerButton2.bottomAnchor.constraint(equalTo: answerButton3.topAnchor, constant: -10),
            answerButton2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            answerButton2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            answerButton2.heightAnchor.constraint(equalToConstant: 45),

            answerButton3.bottomAnchor.constraint(equalTo: answerButton4.topAnchor, constant: -10),
            answerButton3.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            answerButton3.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            answerButton3.heightAnchor.constraint(equalToConstant: 45),

            answerButton4.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            answerButton4.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            answerButton4.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            answerButton4.heightAnchor.constraint(equalToConstant: 45),
        ])
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
                    } else {
                        print("No images found in the folder: \(breedName)")
                    }
                }
            }
        } else {
            print("Failed to load breed names.")
        }
    }

    private func showCurrentQuestion() {
        guard currentQuestionIndex < questions.count else {
            print("Quiz already ended.")
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
            print("Quiz already ended.")
            endQuiz()
            return
        }

        currentQuestionIndex += 1
        if currentQuestionIndex < questions.count {
            showCurrentQuestion()
        } else {
            print("Quiz already ended.")
            endQuiz()
        }
    }

    private func resetTimer() {
        // Timer is removed
    }

    private func startTimer() {
        // Timer is removed
    }

    private func endQuiz() {
        // Timer is removed
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
        } else {
            print("Sound is disabled or could not find music file.")
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
        // Timer is removed
    }

    @objc private func timerTick() {
        // Timer is removed
    }

    @objc func updateVibrationSetting(_ notification: Notification) {
        // Vibration code is removed
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
            sender.backgroundColor = .green  // Change color for correct answer
        } else {
            if UserDefaults.standard.bool(forKey: "SoundSetting") {
                incorrectSoundPlayer?.play()
            }
            sender.backgroundColor = .red
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
