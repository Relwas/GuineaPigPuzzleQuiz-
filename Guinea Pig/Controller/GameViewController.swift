
import UIKit

@available(iOS 13.0, *)
class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .fon
        navigationController?.navigationBar.tintColor = .colorBackNav
        title = "Games"
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 10
        verticalStackView.distribution = .fillEqually
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false

        let button1 = createButton(title: "Puzzle", backgroundColor: .buttonBack, target: self, action: #selector(puzzleButtonTapped))
        let button2 = createButton(title: "Quiz", backgroundColor: .buttonBack, target: self, action: #selector(quizButtonTapped))

        verticalStackView.addArrangedSubview(button1)
        verticalStackView.addArrangedSubview(button2)

        view.addSubview(verticalStackView)

        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            verticalStackView.heightAnchor.constraint(equalToConstant: 350)
        ])
    }

    @objc func puzzleButtonTapped() {
        let puzzleVC = PuzzleViewController()
        navigationController?.pushViewController(puzzleVC, animated: true)
        print("Puzzle button tapped!")
    }

    @objc func quizButtonTapped() {
        let quizVC = QuizViewController()
        quizVC.modalPresentationStyle = .fullScreen
        present(quizVC, animated: true)
        print("Quiz button tapped!")
    }

    func createButton(title: String, backgroundColor: UIColor, target: Any?, action: Selector?) -> UIView {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 28)
        button.setTitle(title, for: .normal)
        button.backgroundColor = backgroundColor

        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true

        button.addTarget(target, action: action!, for: .touchUpInside)

        let backgroundView = UIView()
        backgroundView.backgroundColor = .backg
        backgroundView.layer.cornerRadius = 10
        backgroundView.layer.masksToBounds = true
        backgroundView.addSubview(button)

        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10),
            button.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            button.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -10)
        ])

        return backgroundView
    }
}
