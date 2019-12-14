import UIKit

extension UIView {
    func add(_ subView: UIView...) {
        subView.forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}

/// Using Builder pattern
extension UILabel {
    final class Builder {
        private var text: String?
        private var font: UIFont?

        func font(with value: UIFont) -> Builder {
            self.font = value
            return self
        }

        func text(with value: String) -> Builder {
            self.text = value
            return self
        }

        func build() -> UILabel {
            let label = UILabel()
            label.text = text
            label.font = font
            return label
        }
    }
}

extension UITextField {
    final class Builder {

        private var text: String?
        private var placeHolder: String?
        private var textAlignment: NSTextAlignment?
        private var borderstyle: UITextField.BorderStyle?
        private var delegate: UIViewController?

        func text(with value: String) -> Builder {
            self.text = value
            return self
        }

        func placeHolder(with value: String) -> Builder {
            self.placeHolder = value
            return self
        }

        func textAlignment(with value: NSTextAlignment) -> Builder {
            self.textAlignment = value
            return self
        }

        func borderstyle(with value: UITextField.BorderStyle) -> Builder {
            self.borderstyle = value
            return self
        }

        func delegate(with value: UIViewController?) -> Builder {
            self.delegate = value
            return self
        }
        
        func build() -> UITextField {
            let textField = UITextField()
            textField.text = text
            textField.placeholder = placeHolder
            textField.textAlignment = textAlignment ?? .center
            textField.borderStyle = borderstyle ?? .roundedRect
            textField.delegate = delegate
            return textField
        }
    }
}

extension UIButton {
    final class Builder {
        private var type: UIButton.ButtonType = .system
        private var text: String?
        private var placeHolder: String?
        private var textAlignment: NSTextAlignment?
        private var borderstyle: UITextField.BorderStyle?

        func text(with value: String) -> Builder {
            self.text = value
            return self
        }

        func placeHolder(with value: String) -> Builder {
            self.placeHolder = value
            return self
        }

        func textAlignment(with value: NSTextAlignment) -> Builder {
            self.textAlignment = value
            return self
        }

        func borderstyle(with value: UITextField.BorderStyle) -> Builder {
            self.borderstyle = value
            return self
        }

        func build() -> UIButton {
            let button = UIButton()
            button.setTitle(text, for: .normal)
            return button
        }
    }
}
