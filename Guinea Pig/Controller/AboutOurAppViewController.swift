

import UIKit

class AboutOurAppViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "Fon")

        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        
        let aboutImageView = UIImageView(image: UIImage(named: "aboutImage"))
        aboutImageView.contentMode = .scaleAspectFill
        aboutImageView.layer.cornerRadius = 30
        aboutImageView.clipsToBounds = true
        aboutImageView.translatesAutoresizingMaskIntoConstraints = false

        
        let titleLabel = UILabel()
        titleLabel.text = "Guinea Pig Quiz"
        titleLabel.font = UIFont(name: "AvenirNext-Medium", size: 22)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .labelAbout
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        let largeerTextLabel = UILabel()
        largeerTextLabel.text = "Delve into the delightful realm of guinea pigs with our dedicated app, where we celebrate these charming creatures. Immerse yourself in a world filled with valuable insights into different guinea pig breeds, captivating images, an extensive guide, engaging quizzes, and a delightful puzzle feature. 🐹📱 \nExplore a diverse array of guinea pig breeds, each uniquely portrayed with visuals showcasing their individual characteristics. ✨"
        largeerTextLabel.font = UIFont(name: "AvenirNext-Medium", size: 15)
        largeerTextLabel.numberOfLines = 0
        largeerTextLabel.textAlignment = .center
        largeerTextLabel.textColor = .labelAbout
        largeerTextLabel.translatesAutoresizingMaskIntoConstraints = false
        largeerTextLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        contentView.addSubview(largeerTextLabel)
        contentView.addSubview(aboutImageView)
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            aboutImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
            aboutImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            aboutImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            aboutImageView.heightAnchor.constraint(equalToConstant: 280),

            titleLabel.topAnchor.constraint(equalTo: aboutImageView.bottomAnchor, constant: 25),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            largeerTextLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 40),
            largeerTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            largeerTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            largeerTextLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20),
        ])
    }
}
