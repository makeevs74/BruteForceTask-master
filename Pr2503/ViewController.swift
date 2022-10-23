import UIKit
import SnapKit

class ViewController: UIViewController {

// MARK: - Outlets -

    private lazy var buttonChangeColor: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change color", for: .normal)
        button.addTarget(self, action: #selector(onBut), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()

    var isBlack: Bool = true {
        didSet {
            if isBlack {
                self.view.backgroundColor = .white
                self.label.textColor = .black
                self.textField.backgroundColor = .white
            } else {
                self.view.backgroundColor = .black
                self.label.textColor = .white
                self.textField.backgroundColor = .black
                self.textField.borderStyle = .line
            }
        }
    }
    
    @objc func onBut() {
        isBlack.toggle()
    }

    private lazy var buttonGeneratePassowrd: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Generate password", for: .normal)
        button.addTarget(self, action: #selector(buttonPressedForGenerate), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Привет!"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        return textField
    }()

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHierarchy()
        setupLayout()


        // Do any additional setup after loading the view.
    }

    // MARK: - Setup and Layout -

    private func setupHierarchy() {
        view.addSubview(buttonGeneratePassowrd)
        view.addSubview(label)
        view.addSubview(textField)
        view.addSubview(buttonChangeColor)
    }

    private func setupLayout() {

        label.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(150)
//            make.top.equalTo(view).offset(200)
        }

        textField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.trailing.equalToSuperview().offset(-40)
            make.leading.equalToSuperview().offset(40)
            make.height.equalTo(40)
            make.top.equalTo(label.snp.bottom).offset(10)
        }
//
        buttonGeneratePassowrd.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.trailing.equalToSuperview().offset(-80)
            make.leading.equalToSuperview().offset(80)
            make.height.equalTo(40)
            make.top.equalTo(textField.snp.bottom).offset(10)
        }

        buttonChangeColor.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.trailing.equalToSuperview().offset(-80)
            make.leading.equalToSuperview().offset(80)
            make.height.equalTo(40)
            make.top.equalTo(buttonGeneratePassowrd.snp.bottom).offset(30)
        }
    }

    // MARK: - Action -

    @objc private func buttonPressedForGenerate() {
        self.bruteForce(passwordToUnlock: textField.text ?? "")
    }
    
    func bruteForce(passwordToUnlock: String) {
        let ALLOWED_CHARACTERS:   [String] = String().printable.map { String($0) }

        var password: String = ""

        // Will strangely ends at 0000 instead of ~~~
        DispatchQueue.global().async {
            while password != passwordToUnlock { // Increase MAXIMUM_PASSWORD_SIZE value for more
                password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
    //             Your stuff here
                DispatchQueue.main.async {
                    self.label.text = "Ваш пароль: \(password)"
                }
                print(password)
                // Your stuff here
            }
        }

        print(password)
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

