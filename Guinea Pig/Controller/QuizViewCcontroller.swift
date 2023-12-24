//
//  QuizViewCcontroller.swift
//  Guinea Pig
//
//  Created by relwas on 24/12/23.
//

import UIKit

class QuizViewController: UIViewController {

    // Array to store all available breeds
    var allBreeds: [String] = []

    // Array to store questions
    var questions: [Question] = []

    // Create your UI elements
    let questionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let breedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let firstStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    let secondStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .fon

        // Load all available breeds
        loadAllBreeds()

        // Generate quiz questions
        generateQuizQuestions()

        // Display the first question
        displayQuestion(index: 0)

        // Add your UI elements to the view
        view.addSubview(questionImageView)
        view.addSubview(breedLabel)
        view.addSubview(firstStackView)
        view.addSubview(secondStackView)

        // Set up constraints
        setupConstraints()

        // Add answer buttons to the stack views
        addAnswerButtons()
    }

    private func loadAllBreeds() {
        // Load all breed names from your file structure
        // Assuming you have a folder structure like "Breeds/BreedName/Image1.png"
        if let breedsFolderURL = Bundle.main.resourceURL?.appendingPathComponent("Breeds") {
            do {
                let breedFolders = try FileManager.default.contentsOfDirectory(at: breedsFolderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)

                allBreeds = breedFolders.map { $0.lastPathComponent }
            } catch {
                print("Error loading breed names: \(error)")
            }
        }
    }

    private func generateQuizQuestions() {
        // Generate quiz questions with random breeds
        for _ in 1...15 {
            let randomIndex = Int(arc4random_uniform(UInt32(allBreeds.count)))
            let breed = allBreeds[randomIndex]

            // Create a question with the breed name and answer options
            let question = Question(breedName: breed, answerOptions: generateAnswerOptions(correctBreed: breed))
            questions.append(question)
        }
    }

    private func generateAnswerOptions(correctBreed: String) -> [String] {
        // Generate three incorrect answers and shuffle the array
        var answerOptions = allBreeds.filter { $0 != correctBreed }
        answerOptions.shuffle()

        // Take the first three breeds as incorrect answers
        return Array(answerOptions.prefix(3))
    }

    private func displayQuestion(index: Int) {
        // Display the question at the specified index
        let question = questions[index]
        breedLabel.text = "What breed is it?"
        questionImageView.image = UIImage(named: question.imageName)
        setAnswerButtons(question.answerOptions)
    }

    private func setAnswerButtons(_ answerOptions: [String]) {
        // Set the titles of the answer buttons
        for (index, button) in [firstStackView, secondStackView].flatMap({ $0.arrangedSubviews }).enumerated() {
            if let button = button as? UIButton {
                button.setTitle(answerOptions[index], for: .normal)
            }
        }
    }

    
    private func setupConstraints() {
        // Add your constraints here, for example:
        NSLayoutConstraint.activate([
            questionImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            questionImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            questionImageView.heightAnchor.constraint(equalToConstant: 200),
            
            breedLabel.topAnchor.constraint(equalTo: questionImageView.bottomAnchor, constant: 20),
            breedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            
            firstStackView.bottomAnchor.constraint(equalTo: secondStackView.topAnchor, constant: -20),
            firstStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            firstStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            firstStackView.heightAnchor.constraint(equalToConstant: 45),
            
            secondStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            secondStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            secondStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            secondStackView.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
    
    private func addAnswerButtons() {
        // Create and add your answer buttons to the stack views
        for i in 1...4 {
            let button = UIButton(type: .system)
            button.setTitle("Answer \(i)", for: .normal)
            button.addTarget(self, action: #selector(answerButtonTapped(_:)), for: .touchUpInside)
            
            if i <= 2 {
                firstStackView.addArrangedSubview(button)
            } else {
                secondStackView.addArrangedSubview(button)
            }
        }
    }
    
    @objc private func answerButtonTapped(_ sender: UIButton) {
        // Handle button tap
        if let buttonText = sender.titleLabel?.text {
            print("Selected answer: \(buttonText)")
            // Add your logic for handling the selected answer

            // Move to the next question
            if let currentIndex = questions.firstIndex(where: { $0.breedName == breedLabel.text }) {
                let nextIndex = currentIndex + 1
                if nextIndex < questions.count {
                    displayQuestion(index: nextIndex)
                } else {
                    // Quiz finished, move to the result controller
                    moveToResultController()
                }
            }
        }
    }

    private func moveToResultController() {
        // Add your logic to move to the result controller
        // For example, use a segue or present the result controller
        // ...

    }
}

struct Question {
    let breedName: String
    let answerOptions: [String]
    var imageName: String {
        // Assuming you have image files named "Image1.png", "Image2.png", etc.
        return "\(breedName)/Image1.png"
    }
}
