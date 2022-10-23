import UIKit
import SnapKit

class ViewController: UIViewController {

// MARK: - Outlets -

    @IBOutlet weak var button: UIButton!

    var isBlack: Bool = true {
        didSet {
            if isBlack {
                self.view.backgroundColor = .white
            } else {
                self.view.backgroundColor = .black
            }
        }
    }
    
    @IBAction func onBut(_ sender: Any) {
        isBlack.toggle()
    }

    private lazy var buttonGeneratePassowrd: UIButton = {
        let button = UIButton()
        button.titleLabel?.text = "Generate password"
        button.addTarget(self, action: #selector(buttonPressedForGenerate), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        return button
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        return textField
    }()

    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        return stack
    }()

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupHierarchy()
        setupLayout()
        
//        self.bruteForce(passwordToUnlock: "1!gr")
        
        // Do any additional setup after loading the view.
    }

    // MARK: - Setup and Layout -

    private func setupHierarchy() {
        stack.addSubview(buttonGeneratePassowrd)
        stack.addSubview(label)
        stack.addSubview(textField)
        view.addSubview(stack)
    }

    private func setupLayout() {
        stack.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.top.equalTo(view.snp.top).offset(-50)
        }

        label.snp.makeConstraints { make in
            make.centerY.equalTo(stack)
        }

        textField.snp.makeConstraints { make in
            make.centerY.equalTo(stack)
            make.top.equalTo(label.snp.bottom).offset(-10)
        }

        buttonGeneratePassowrd.snp.makeConstraints { make in
            make.centerY.equalTo(stack)
            make.top.equalTo(textField.snp.bottom).offset(-10)
        }
    }

    // MARK: - Action -

    @objc private func buttonPressedForGenerate() {

    }
    
    func bruteForce(passwordToUnlock: String) {
        let ALLOWED_CHARACTERS:   [String] = String().printable.map { String($0) }

        var password: String = ""

        // Will strangely ends at 0000 instead of ~~~
        while password != passwordToUnlock { // Increase MAXIMUM_PASSWORD_SIZE value for more
            password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
//             Your stuff here
            print(password)
            // Your stuff here
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

