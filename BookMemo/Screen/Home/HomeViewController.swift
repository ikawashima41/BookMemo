import Foundation
import UIKit
import RxSwift

final class HomeViewController: UIViewController {

    private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var addButton: UIBarButtonItem = {
        let addButton = UIBarButtonItem(title: "追加", style: .plain, target: self, action: #selector(showBookRegistrationVC))
        return addButton
    }()

    private lazy var dataSource: HomeDataSource = {
        let dataSource = HomeDataSource(viewModel: viewModel) { [unowned self] (book) in
            self.routing.showBookDetailVC(book: book)
        }
        dataSource.configure(with: tableView)
        return dataSource
    }()

    private lazy var routing: HomeRouting = {
        let routing = HomeRoutingImpl()
        routing.viewController = self
        return routing
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = Constants.Size.tableViewRowHeight
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.className)
        return tableView
    }()

    private lazy var addLoadingPageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("更新", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .lightGray
        button.adjustsImageWhenDisabled = true
        return button
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = view.center
        activityIndicator.style = .whiteLarge
        activityIndicator.color = .black
        return activityIndicator
    }()

    @objc private func showBookRegistrationVC() {
        routing.showBookRegistrationVC()
    }

    private let disposeBag: DisposeBag = .init()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindUI()
    }
}

extension HomeViewController {
    private func setupUI() {
        title = "書籍一覧"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = addButton
        view.add(tableView, addLoadingPageButton, activityIndicator)

        [tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
         tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
         tableView.widthAnchor.constraint(equalToConstant: view.frame.width),

         addLoadingPageButton.topAnchor.constraint(equalTo: tableView.bottomAnchor),
         addLoadingPageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
         addLoadingPageButton.leftAnchor.constraint(equalTo: view.leftAnchor),
         addLoadingPageButton.widthAnchor.constraint(equalToConstant: view.frame.width),
         addLoadingPageButton.heightAnchor.constraint(equalToConstant: Constants.Constraint.addLoadPageButtonHeightConstraint)]
            .forEach {
                $0.isActive = true
        }
    }

    private func bindUI() {

        let input = HomeViewModel.Input(
            didReloadButtonTapped: addLoadingPageButton.rx.tap.asObservable(),
            viewWillAppear: self.rx.viewWillAppear.asObservable()
        )

        let output = viewModel.transform(input: input)

        output.result.subscribe(onNext: { [weak self] result in
            self?.viewModel.books += result.result.map {
                BookInfomation(
                    id: $0.id,
                    name: $0.name,
                    image: $0.image,
                    price: $0.price,
                    purchaseDate: $0.purchaseDate
                )
            }
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)

        output.error.subscribe(onNext: { [weak self] error in
            self?.createAlert(message: error.localizedDescription)
        }).disposed(by: disposeBag)

        output.pagingResult.subscribe(onNext: { [weak self] result in
            self?.viewModel.books += result.result.map {
                BookInfomation(
                    id: $0.id,
                    name: $0.name,
                    image: $0.image,
                    price: $0.price,
                    purchaseDate: $0.purchaseDate
                )
            }
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)

        output.pagingError.subscribe(onNext: { [weak self] error in
            self?.createAlert(message: error.localizedDescription)
        }).disposed(by: disposeBag)
    }
}
