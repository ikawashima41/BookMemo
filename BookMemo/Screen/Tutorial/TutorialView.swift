import UIKit

extension TutorialView {
    enum LayoutStyle {
        case first
        case second
        case third

        var title: String {
            switch self {
            case .first:
                return "hogehoge"
            case .second:
                return "fugafuga"
            case .third:
                return "hogefuga"
            }
        }

        var description: String {
            switch self {
            case .first:
                return "hogehogehogehogehogehogehogehogehogehoge"
            case .second:
                return "hogehogehogehogehogehogehogehogehogehoge"
            case .third:
                return "hogehogehogehogehogehogehogehogehogehoge"
            }
        }
    }
}

final class TutorialView: UIView {

    let descriptionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "fugafuga"
        return label
    }()

    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.text = "hogehogehogehogehogehogehogehogehogehogehogehogehogehogehogehogehogehogehogehogehogehogehogehogehogehogehogehogehogehogehogehogehogehogehogehogehogehogehogehogehogehogehogehogehogehoge"
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func applyView(from view: TutorialView.LayoutStyle) {
        titleLabel.text = view.title
        descriptionTextView.text = view.description
    }

    private func setupUI() {
        self.backgroundColor = .lightGray
        self.add(descriptionImageView, titleLabel, descriptionTextView)

        descriptionImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        descriptionImageView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        descriptionImageView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        descriptionImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 80).isActive = true

        titleLabel.topAnchor.constraint(equalTo: descriptionImageView.bottomAnchor, constant: 30).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

        descriptionTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
        descriptionTextView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        descriptionTextView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        descriptionTextView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
}
