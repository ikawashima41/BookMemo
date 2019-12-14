import UIKit

final class HomeDataSource: NSObject {

    weak var viewController: UIViewController?
    private var viewModel: HomeViewModel
    private var didCellTapped: (BookInfomation) -> Void

    init(viewModel: HomeViewModel, completion: @escaping (BookInfomation) -> Void) {
        self.viewModel = viewModel
        self.didCellTapped = completion
    }

    func configure(with tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension HomeDataSource: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.books.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // cellの生成
         let cell: HomeTableViewCell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.className, for: indexPath) as! HomeTableViewCell

        cell.accessoryType = .disclosureIndicator
        cell.configureWithBook(book: viewModel.books[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let book = viewModel.books[indexPath.row]
        didCellTapped(book)
    }
}
