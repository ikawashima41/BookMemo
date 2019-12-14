import UIKit
import RxSwift
import Nuke

final class BookDetailViewController: UIViewController {

    private var viewModel: BookDetailViewModel

    private let imageSubject: BehaviorSubject<UIImage> = BehaviorSubject(value: #imageLiteral(resourceName: "bookIcon"))

    private var selectedBook: BookInfomation

    init(viewModel: BookDetailViewModel, book: BookInfomation) {
        self.viewModel = viewModel
        self.selectedBook = book
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let inputDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        return datePicker
    }()

    private lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        return imagePicker
    }()

    private lazy var saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "保存", style: .plain, target: self, action: nil)
        button.isEnabled = false
        button.tintColor = UIColor(white: 0, alpha: 0)
        return button
    }()

    private let bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "bookIcon")
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = Constants.Size.imageViewBorderWidth
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    private lazy var imagePutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("画像添付ボタン", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: Constants.Size.fontSizeSmall)
        button.layer.cornerRadius = Constants.Size.buttonCornerRadius
        button.backgroundColor = .lightGray
        button.adjustsImageWhenDisabled = true
        return button
    }()

    private let bookNameLabel: UILabel = {
        let label = UILabel()
        label.text = "書籍名"
        label.font = .systemFont(ofSize: Constants.Size.fontSizeSmall)
        return label
    }()

    private lazy var bookNameTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = "テキスト入力"
        textField.keyboardType = .default
        textField.font = .systemFont(ofSize: Constants.Size.fontSizeMiddle)
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .done
        textField.clearButtonMode = .always
        textField.textAlignment = .center
        return textField
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "金額"
        label.font = .systemFont(ofSize: Constants.Size.fontSizeSmall)
        return label
    }()

    private lazy var priceTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = "テキスト入力"
        textField.keyboardType = .default
        textField.font = .systemFont(ofSize: Constants.Size.fontSizeMiddle)
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .done
        textField.clearButtonMode = .always
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        return textField
    }()

    private let purchaseDateLabel: UILabel = {
        let label = UILabel()
        label.text = "購入日"
        label.font = .systemFont(ofSize: Constants.Size.fontSizeSmall)
        return label
    }()

    private lazy var purchaseDateTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = "テキスト入力"
        textField.keyboardType = .default
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.textColor = .gray
        textField.text = Date.convertToString(from: inputDatePicker.date)
        // textFieldにdatePicker、toolBarをセット
        textField.inputView = inputDatePicker
        textField.inputAccessoryView = pickerToolBar
        return textField
    }()

    private lazy var pickerToolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.tintColor = .gray
        toolBar.backgroundColor = .white
        toolBar.sizeToFit()
        toolBar.items = [spaceBarButton, toolBarButton]
        return toolBar
    }()

    private lazy var spaceBarButton: UIBarButtonItem = {
        let spaceBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        return spaceBarButton
    }()

    private lazy var toolBarButton: UIBarButtonItem = {
        let toolBarButton = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(didToolBarButtonTapped(_:)))
        return toolBarButton
    }()

    @objc private func didCancelButtonTapped() {
        dismiss(animated: true)
    }

    @objc private func didToolBarButtonTapped(_ sender: UIBarButtonItem) {
        let pickerDate = inputDatePicker.date
        purchaseDateTextField.text = Date.convertToString(from: pickerDate as Date)
        view.endEditing(true)
    }

    private lazy var routing: BookDetailRouting = {
        let routing = BookDetailRoutingImpl()
        routing.viewController = self
        return routing
    }()

    private let disposeBag: DisposeBag = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setupObserver()
        bindUI()

        bookNameTextField.text = selectedBook.name
        priceTextField.text = String(describing: selectedBook.price)
        purchaseDateTextField.text = selectedBook.purchaseDate

        guard let url = URL(string: selectedBook.image ?? "") else { return }
        Nuke.loadImage(with: url, into: bookImageView)
    }
}

extension BookDetailViewController {
    private func setupLayout() {
        title = "書籍編集"
        navigationItem.rightBarButtonItem = saveButton

        view.add(
            bookImageView,
            imagePutButton,
            bookNameLabel,
            bookNameTextField,
            priceLabel,
            priceTextField,
            purchaseDateLabel,
            purchaseDateTextField
        )

        [
            bookImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.Constraint.bookImageTopConstraint),
            bookImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Constants.Constraint.bookImageLeftConstraint),
            bookImageView.widthAnchor.constraint(equalToConstant: Constants.Constraint.bookImageWidthConstraint),
            bookImageView.heightAnchor.constraint(equalToConstant: Constants.Constraint.bookImageHeightConstraint),

            imagePutButton.leftAnchor.constraint(equalTo: bookImageView.rightAnchor, constant: Constants.Constraint.imagePutButtonLeftConstraint),
            imagePutButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: Constants.Constraint.imagePutButtonRightConstraint),
            imagePutButton.centerYAnchor.constraint(equalTo: bookImageView.centerYAnchor),
            imagePutButton.heightAnchor.constraint(equalToConstant: Constants.Constraint.imagePutButtonHeightConstraint),

            bookNameLabel.topAnchor.constraint(equalTo: bookImageView.bottomAnchor, constant: Constants.Constraint.labelTopConstraint),
            bookNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Constants.Constraint.labelLeftConstraint),

            bookNameTextField.topAnchor.constraint(equalTo: bookNameLabel.bottomAnchor, constant: Constants.Constraint.textFieldTopConstraint),
            bookNameTextField.leftAnchor.constraint(equalTo: bookNameLabel.leftAnchor),
            bookNameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: Constants.Constraint.textFieldRightConstraint),
            bookNameTextField.heightAnchor.constraint(equalToConstant: Constants.Constraint.textFieldHeightConstraint),

            priceLabel.topAnchor.constraint(equalTo: bookNameTextField.bottomAnchor, constant: Constants.Constraint.labelTopConstraint),
            priceLabel.leftAnchor.constraint(equalTo: bookNameTextField.leftAnchor),

            priceTextField.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: Constants.Constraint.textFieldTopConstraint),
            priceTextField.leftAnchor.constraint(equalTo: bookNameTextField.leftAnchor),
            priceTextField.rightAnchor.constraint(equalTo: bookNameTextField.rightAnchor),
            priceTextField.heightAnchor.constraint(equalToConstant: Constants.Constraint.textFieldHeightConstraint),

            purchaseDateLabel.topAnchor.constraint(equalTo: priceTextField.bottomAnchor, constant: Constants.Constraint.labelTopConstraint),
            purchaseDateLabel.leftAnchor.constraint(equalTo: priceTextField.leftAnchor),

            purchaseDateTextField.topAnchor.constraint(equalTo: purchaseDateLabel.bottomAnchor, constant: Constants.Constraint.textFieldTopConstraint),
            purchaseDateTextField.leftAnchor.constraint(equalTo: priceTextField.leftAnchor),
            purchaseDateTextField.rightAnchor.constraint(equalTo: priceTextField.rightAnchor),
            purchaseDateTextField.heightAnchor.constraint(equalToConstant: Constants.Constraint.textFieldHeightConstraint)]
            .forEach {
                $0.isActive = true
        }
    }

    private func bindUI() {
        let input = BookDetailViewModel.Input(
            didSaveButtonTapped: saveButton.rx.tap.asObservable(),
            bookNameText: bookNameTextField.rx.text.orEmpty.asObservable(),
            priceText: priceTextField.rx.text.orEmpty.asObservable(),
            purchaseDateText: purchaseDateTextField.rx.text.orEmpty.asObservable(),
            selectedImage: imageSubject.asObservable(),
            id: selectedBook.id
        )

        let output = viewModel.transform(input: input)

        output.isValid.subscribe(onNext: { [weak self] bool in
            self?.saveButton.isEnabled = bool
            let systemBlueColor = UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1)
            self?.saveButton.tintColor = bool ? systemBlueColor : UIColor(white: 0, alpha: 0)
        }).disposed(by: disposeBag)

        output.result.subscribe(onNext: { [weak self] _ in
            self?.routing.showHomeVC()
        }).disposed(by: disposeBag)

        output.error.subscribe(onNext: { [weak self] error in
            self?.createAlert(message: error.localizedDescription)
        }).disposed(by: disposeBag)
    }
}

extension BookDetailViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @objc func registerImage() {
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        imageSubject.onNext(pickedImage)
        bookImageView.image = pickedImage
        picker.dismiss(animated: true)
    }
}
