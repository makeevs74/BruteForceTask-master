import UIKit
import SnapKit

class ViewController: UIViewController {

// MARK: - Outlets -

    private lazy var buttonChangeColor: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change color", for: .normal)
        button.addTarget(self, action: #selector(onBut), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 20

        return button
    }()

    var isBlack: Bool = true {
        didSet {
            if isBlack {
                self.view.backgroundColor = .orange
                self.label.textColor = .black
                self.textField.backgroundColor = .white
            } else {
                self.view.backgroundColor = .systemGreen
                self.label.textColor = .white
                self.textField.backgroundColor = .white
                self.textField.borderStyle = .roundedRect
            }
        }
    }

    private lazy var buttonGuessPassword: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Guess password", for: .normal)
        button.addTarget(self, action: #selector(buttonPressedForGenerate), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitleColor(.systemIndigo, for: .normal)
        button.backgroundColor = .systemYellow
        button.layer.cornerRadius = 20
        return button
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Create a password"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22)
        return label
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemGray5
        textField.textAlignment = .center
        textField.clearButtonMode = .whileEditing
        return textField
    }()

    // MARK: - Activity Indicator -

    let indicator = UIActivityIndicatorView(style: .large)

    func showIndicator() {
        view.addSubview(indicator)
        indicator.startAnimating()

        indicator.snp.makeConstraints { make in
            make.centerY.equalTo(label.snp.centerY)
            make.right.equalTo(label.snp.right).offset(10)
        }
    }

    func removeIndicator() {
        indicator.stopAnimating()
    }

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        setupHierarchy()
        setupLayout()
        makeShadow(outlet: buttonChangeColor)
        makeShadow(outlet: buttonGuessPassword)
        makeShadow(outlet: textField)
    }

    // MARK: - Setup and Layout -

    private func setupHierarchy() {
        view.addSubview(buttonGuessPassword)
        view.addSubview(label)
        view.addSubview(textField)
        view.addSubview(buttonChangeColor)
    }

    private func setupLayout() {

        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-100)
            make.height.equalTo(40)
            make.trailing.equalToSuperview().offset(-50)
            make.leading.equalToSuperview().offset(50)
        }

        textField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.trailing.equalToSuperview().offset(-80)
            make.leading.equalToSuperview().offset(80)
            make.height.equalTo(40)
            make.top.equalTo(label.snp.bottom).offset(10)
        }

        buttonGuessPassword.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.trailing.equalToSuperview().offset(-80)
            make.leading.equalToSuperview().offset(80)
            make.height.equalTo(40)
            make.top.equalTo(textField.snp.bottom).offset(20)
        }

        buttonChangeColor.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.trailing.equalToSuperview().offset(-80)
            make.leading.equalToSuperview().offset(80)
            make.height.equalTo(40)
            make.top.equalTo(buttonGuessPassword.snp.bottom).offset(20)
        }
    }

    // MARK: - Action -

    @objc private func buttonPressedForGenerate() {
        self.showIndicator()
        self.bruteForce(passwordToUnlock: textField.text ?? "")
    }

    @objc func onBut() {
        isBlack.toggle()
    }
    
    func bruteForce(passwordToUnlock: String) {
        let ALLOWED_CHARACTERS:   [String] = String().printable.map { String($0) }

        var password: String = ""

        DispatchQueue.global().async {
            while password != passwordToUnlock {
                password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)

                DispatchQueue.main.async { [self] in
                    self.label.text = "Your passowrd is: \(password)"
                }
                print(password)
            }
            DispatchQueue.main.async { [self] in
                self.removeIndicator()
            }
        }
        print(password)
    }

    func makeShadow(outlet: AnyObject) {
        outlet.layer.shadowColor = UIColor.black.cgColor
        outlet.layer.shadowOpacity = 0.3
        outlet.layer.shadowOffset = CGSize(width: 2, height: 5)
        outlet.layer.shadowRadius = 10
        outlet.layer.shouldRasterize = true
        outlet.layer.rasterizationScale = UIScreen.main.scale
    }
}

extension String {
    var digits:      String { return "0123456789" }
    var lowercase:   String { return "abcdefghijklmnopqrstuvwxyz" }
    var uppercase:   String { return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    var punctuation: String { return "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" }
    var letters:     String { return lowercase + uppercase }
    var printable:   String { return digits + letters + punctuation }

    mutating func replace(at index: Int, with character: Character) {
        var stringArray = Array(self)
        stringArray[index] = character
        self = String(stringArray)
    }
}

func indexOf(character: Character, _ array: [String]) -> Int {
    return array.firstIndex(of: String(character))!
}

func characterAt(index: Int, _ array: [String]) -> Character {
    return index < array.count ? Character(array[index])
                               : Character("")
}

func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
    var str: String = string

    if str.count <= 0 {
        str.append(characterAt(index: 0, array))
    }
    else {
        str.replace(at: str.count - 1,
                    with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))

        if indexOf(character: str.last!, array) == 0 {
            str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
        }
    }
    return str
}

