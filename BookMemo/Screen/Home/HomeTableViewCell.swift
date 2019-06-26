import UIKit
import Foundation
import Nuke

class HomeTableViewCell: UITableViewCell {

    private let bookImage: UIImageView = {
        let bookImage = UIImageView()
        bookImage.clipsToBounds = true
        bookImage.layer.borderWidth = Constants.Size.imageViewBorderWidth
        bookImage.layer.borderColor = UIColor.gray.cgColor
        return bookImage
    }()

    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: Constants.Size.fontSizeSmall)
        return titleLabel
    }()

    private let priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.font = .systemFont(ofSize: Constants.Size.fontSizeSmall)
        return priceLabel
    }()

    private let purchaseDateLabel: UILabel = {
        let purchaseDateLabel = UILabel()
        purchaseDateLabel.font = .systemFont(ofSize: Constants.Size.fontSizeSmall)
        return purchaseDateLabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("セルを初期化できません")
    }

    func configureWithBook(book: BookInfomation) {
        titleLabel.text = book.name
        if let image = book.image {
            Nuke.loadImage(with: URL(string: image)!, into: bookImage)
        } else {
            bookImage.image = #imageLiteral(resourceName: "bookIcon")
        }

        if let price = book.price {
            priceLabel.text = "\(String(price))円"
        }
        if let purchaseDate = book.purchaseDate {
            purchaseDateLabel.text = purchaseDate.replacingOccurrences(of: "-", with: "/")
        }
    }
}

extension HomeTableViewCell {
    private func setupUI() {
        [bookImage, titleLabel, priceLabel, purchaseDateLabel]
            .forEach {
                contentView.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [bookImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.Constraint.bookImageTopConstraintInCell),
         bookImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constants.Constraint.bookImageleftConstraintInCell),
         bookImage.widthAnchor.constraint(equalToConstant: Constants.Constraint.bookImageWidthConstraintInCell),
         bookImage.heightAnchor.constraint(equalToConstant: Constants.Constraint.bookImageHeightConstraintInCell),

         titleLabel.topAnchor.constraint(equalTo: bookImage.topAnchor),
         titleLabel.leftAnchor.constraint(equalTo: bookImage.rightAnchor, constant: Constants.Constraint.titleLeftConstraintInCell),

         priceLabel.bottomAnchor.constraint(equalTo: bookImage.bottomAnchor),
         priceLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),

         purchaseDateLabel.bottomAnchor.constraint(equalTo: priceLabel.bottomAnchor),
         purchaseDateLabel.leftAnchor.constraint(equalTo: priceLabel.rightAnchor, constant: Constants.Constraint.purchaseDateLeftConstraintInCell)]
            .forEach {
                $0.isActive = true
        }
    }
}
