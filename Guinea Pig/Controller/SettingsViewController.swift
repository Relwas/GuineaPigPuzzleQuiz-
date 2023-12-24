import UIKit

@available(iOS 13.0, *)
class SettingsViewController: UIViewController {

    private let soundSwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = UserDefaults.standard.bool(forKey: "SoundSetting")
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        return switchControl
    }()

    private let vibrationSwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        return switchControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupUserDefaults()
        title = "Settings"
    }

    private func setupUI() {
        view.backgroundColor = UIColor(named: "Fon")
        navigationController?.navigationBar.tintColor = .colorBackNav

        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.gray
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)

        let stackView = createStackView()

        stackView.addArrangedSubview(createRow(labelText: "Sound", switchControl: soundSwitch, switchAction: #selector(soundSwitchValueChanged(_:))))
        stackView.addArrangedSubview(createRow(labelText: "Vibration", switchControl: vibrationSwitch, switchAction: #selector(vibrationSwitchValueChanged(_:))))
        stackView.addArrangedSubview(createRow(buttonTitle: "About our application", buttonAction: #selector(aboutAppButtonTapped)))
        stackView.addArrangedSubview(createRow(buttonTitle: "Share", buttonAction: #selector(shareButtonTapped)))
        stackView.addArrangedSubview(createRow(buttonTitle: "Rate", buttonAction: #selector(rateButtonTapped)))

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }

    private func setupUserDefaults() {
        configureDefaultSetting(forKey: "SoundSetting", switchControl: soundSwitch)
        configureDefaultSetting(forKey: "VibrationSetting", switchControl: vibrationSwitch)
    }

    private func configureDefaultSetting(forKey key: String, switchControl: UISwitch) {
        if UserDefaults.standard.object(forKey: key) == nil {
            switchControl.isOn = true
            UserDefaults.standard.set(true, forKey: key)
        } else {
            switchControl.isOn = UserDefaults.standard.bool(forKey: key)
        }
    }

    private func createStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }

    private func createRow(labelText: String? = nil, switchControl: UISwitch? = nil, switchAction: Selector? = nil, buttonTitle: String? = nil, buttonAction: Selector? = nil) -> UIView {
        let rowView = UIView()
        rowView.translatesAutoresizingMaskIntoConstraints = false
        rowView.backgroundColor = .buttonBack
        rowView.layer.cornerRadius = 33

        rowView.layer.shadowColor = UIColor.gray.cgColor
        rowView.layer.shadowOpacity = 1.0
        rowView.layer.shadowOffset = CGSize(width: 2, height: 2)
        rowView.layer.shadowRadius = 3.0

        if let labelText = labelText {
            let label = createLabel(text: labelText)
            rowView.addSubview(label)
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: rowView.leadingAnchor, constant: 20),
                label.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),
            ])
        }

        if let switchControl = switchControl {
            configureSwitchControl(switchControl, withAction: switchAction)
            rowView.addSubview(switchControl)
            NSLayoutConstraint.activate([
                switchControl.trailingAnchor.constraint(equalTo: rowView.trailingAnchor, constant: -20),
                switchControl.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),
            ])
        } else if let buttonTitle = buttonTitle, let buttonAction = buttonAction {
            let button = createButton(title: buttonTitle, action: buttonAction)
            rowView.addSubview(button)
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: rowView.leadingAnchor, constant: 20),
                button.trailingAnchor.constraint(equalTo: rowView.trailingAnchor, constant: -20),
                button.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),
            ])
        }

        let heightConstraint = rowView.heightAnchor.constraint(equalToConstant: 65)
        heightConstraint.priority = UILayoutPriority(999)
        heightConstraint.isActive = true

        return rowView
    }

    private func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "Avenir-Roman", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }

    private func configureSwitchControl(_ switchControl: UISwitch, withAction action: Selector?) {
        switchControl.addTarget(self, action: action ?? #selector(defaultSwitchValueChanged(_:)), for: .valueChanged)
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.backgroundColor = UIColor.backg
        switchControl.onTintColor = .switchColor1
        switchControl.layer.cornerRadius = 15
    }

    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.backgroundColor = .buttonBack
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont(name: "Avenir-Roman", size: 20)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    @objc private func defaultSwitchValueChanged(_ sender: UISwitch) {
    }

    @objc private func soundSwitchValueChanged(_ sender: UISwitch) {
        let isSoundEnabled = sender.isOn
        print("Sound setting changed: \(isSoundEnabled)")
        UserDefaults.standard.set(isSoundEnabled, forKey: "SoundSetting")
        NotificationCenter.default.post(name: Notification.Name("SoundSettingChanged"), object: nil)
    }

    @objc private func vibrationSwitchValueChanged(_ sender: UISwitch) {
        let isVibrationEnabled = sender.isOn
        print("Vibration setting changed: \(isVibrationEnabled)")
        VibrationManager.shared.isVibrationEnabled = isVibrationEnabled
        if isVibrationEnabled {
            UserDefaults.standard.set(true, forKey: "VibrationSetting")
        }
    }

    @objc private func aboutAppButtonTapped() {
        let aboutOurAppVC = AboutOurAppViewController()
        navigationController?.pushViewController(aboutOurAppVC, animated: true)
    }

    //TODO: Share Rate App
    @objc private func shareButtonTapped() {
        let shareMessage = "Explore the Guinea Pig App! 🐹📱 Immerse yourself in the delightful world of guinea pigs and challenge your knowledge with the guinea pig trivia quiz. Download now and embark on a furry adventure!"
        let activityViewController = UIActivityViewController(activityItems: [shareMessage], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        present(activityViewController, animated: true, completion: nil)
    }

    @objc private func rateButtonTapped() {
        if let appStoreURL = URL(string: "https://apps.apple.com/app/ID") {
            UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
        }
    }
}

class VibrationManager {
    static let shared = VibrationManager()

    private let vibrationKey = "VibrationSetting"

    var isVibrationEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isVibrationEnabled, forKey: vibrationKey)
            UserDefaults.standard.synchronize()
        }
    }

    private init() {
        self.isVibrationEnabled = UserDefaults.standard.bool(forKey: vibrationKey)
    }

    func getCurrentVibrationSetting() -> Bool {
        return isVibrationEnabled
    }

    func updateVibrationSetting(isEnabled: Bool) {
        isVibrationEnabled = isEnabled
    }

    func vibrateSuccess() {
        if isVibrationEnabled {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }

    func vibrateError() {
        if isVibrationEnabled {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        }
    }
}
