import UIKit

class MainView: UIView {

    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "Fon")
       return view
        
    }()
    
    let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "ColorBack") // Set your desired background color
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()

    let stackView1: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()
    
    let stackView2: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()
    
    var breedButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        return button
    }()
    
    var gameButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        return button
    }()
    
    var favoritesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        return button
    }()
    
    var settingsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        return button
    }()
    
    //Override
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupImageView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Public
   
    func makeStyleButtons(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.backgroundColor = UIColor(named: "buttonBack")
        applyShadow(to: button)
        return button
    }
    
    func applyShadow(to button: UIButton) {
        button.layer.cornerRadius = 15
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 3
    }
    
    func setupImageView() {
        if let image = UIImage(named: "MainPhoto") {
            imageView.image = image
        }
    }

    
    //MARK: Private
    private func setupViews() {
        addSubview(containerView)
        containerView.addSubview(backgroundView)
        backgroundView.addSubview(imageView)
        containerView.addSubview(stackView1)
        containerView.addSubview(stackView2)

        breedButton = makeStyleButtons(title: "Breeds")
        gameButton = makeStyleButtons(title: "Game")
        favoritesButton = makeStyleButtons(title: "Favorites")
        settingsButton = makeStyleButtons(title: "Settings")

        applyShadow(to: breedButton)
        applyShadow(to: gameButton)
        applyShadow(to: favoritesButton)
        applyShadow(to: settingsButton)


        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 75),
            containerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),

            imageView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20), // Adjusted the top anchor
            imageView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalToConstant: 230),

            backgroundView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -10),
            backgroundView.heightAnchor.constraint(equalToConstant: 280),
            backgroundView.widthAnchor.constraint(equalToConstant: 280),
            backgroundView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            backgroundView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
        ])

        // Add corner radius to the background view
        backgroundView.layer.cornerRadius = 140

        NSLayoutConstraint.activate([
            stackView1.bottomAnchor.constraint(equalTo: stackView2.topAnchor, constant: -20),
            stackView1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView1.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView1.heightAnchor.constraint(equalToConstant: 90),

            stackView2.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            stackView2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView2.heightAnchor.constraint(equalToConstant: 90),
        ])

        stackView1.addArrangedSubview(breedButton)
        stackView1.addArrangedSubview(gameButton)

        stackView2.addArrangedSubview(favoritesButton)
        stackView2.addArrangedSubview(settingsButton)
    }
}
