// 参考: https://medium.com/@kmlong1183/extension-approach-to-keeping-uitextfields-in-sight-9fe8695c2ac6
import UIKit
import ObjectiveC
import MBProgressHUD
import RxSwift

//==================================================
// MARK: - キーボードイベント
//==================================================

struct AssociatedKeys {
    static var activeTextField: UInt8 = 0
    static var keyboardHeight: UInt8 = 1
}

extension UIViewController: UITextFieldDelegate {

    private(set) var keyboardHeight: CGFloat {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.keyboardHeight) as? CGFloat else {
                return 0.0
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.keyboardHeight, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }

    private(set) var activeTextField: UITextField? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.activeTextField) as? UITextField
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.activeTextField, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }

    // キーボードを監視する
    func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    // MARK: - キーボードイベント
    @objc func keyboardWillChangeFrame(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        self.keyboardHeight = keyboardFrame.height
    }

    @objc func keyboardWillShow(notification: Notification) {
        arrangeViewOffsetFromKeyboard()
    }

    @objc func keyboardWillHide(notification: Notification) {
        if self.view.frame.origin.y != 0.0 {
            self.view.frame.origin.y = 0.0
        }
        self.keyboardHeight = 0.0
    }

    private func arrangeViewOffsetFromKeyboard() {
        guard let activeTextField = activeTextField else { return }
        let bottomOfTextField = self.view.convert(CGPoint(x: 0, y: activeTextField.frame.height), from: activeTextField).y
        let topofKeyboard = self.view.frame.height - self.keyboardHeight

        if bottomOfTextField > topofKeyboard {
            var offset = bottomOfTextField - topofKeyboard
            if self.view.frame.origin.y < 0 {
                offset += 20.0
            }
            // viewのy軸をマイナス方向に移動させる
            self.view.frame.origin.y = -1 * (offset + 30.0)
        } else {
            self.view.frame.origin.y = 0
        }
    }

    // MARK: - テキストフィールドイベント
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }

    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        self.activeTextField = nil
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

//==================================================
// MARK: - ローディング
//==================================================

extension UIViewController {
    func setIndicator(show: Bool) {
        if show {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        } else {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}

extension UIViewController {
    func createAlert(message: String) {
        UIAlertController
            .showDialog(from: self,
                        title: "",
                        message: message,
                        cancelAction: AlertAction.okay)
        .subscribe()
        .disposed(by: DisposeBag())
    }
}
