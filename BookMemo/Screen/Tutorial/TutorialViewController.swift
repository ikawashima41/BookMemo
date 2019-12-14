import UIKit
import RxSwift
import RxCocoa

final class TutorialViewController: UIViewController {

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        let width = self.view.frame.width
        scrollView.frame = self.view.frame
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: 3 * width , height: 0)
        return scrollView
    }()

    private let stacKView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()

    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .darkGray
        pageControl.numberOfPages = 3
        pageControl.pageIndicatorTintColor = .white
        return pageControl
    }()

    private let disposeBag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        pageControl.currentPage = 0

        setupUI()
        bindUI()
    }
}

private extension TutorialViewController {

    func setupUI() {
        view.add(scrollView, pageControl)

        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        scrollView.add(stacKView)
        stacKView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stacKView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        stacKView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        stacKView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true

        let firstView = TutorialView()
        firstView.applyView(from: .first)
        let secondView = TutorialView()
        secondView.applyView(from: .second)
        let thirdView = TutorialView()
        thirdView.applyView(from: .third)
        stacKView.add(firstView, secondView, thirdView)

        firstView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        firstView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        firstView.backgroundColor = .lightGray

        secondView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        secondView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        secondView.backgroundColor = .yellow

        thirdView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        thirdView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        thirdView.backgroundColor = .red

        pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    func bindUI() {
        scrollView.rx.didScroll.subscribe(onNext: { [unowned self] _ in
            self.scrollView.contentOffset.y = 0
        }).disposed(by: disposeBag)

        scrollView.rx.didEndDecelerating.subscribe(onNext: { [unowned self] _ in
            if fmod(self.scrollView.contentOffset.x, self.scrollView.frame.width) == 0 {
                self.pageControl.currentPage = Int(self.scrollView.contentOffset.x / self.scrollView.frame.width)
            }
        }).disposed(by: disposeBag)
    }
}
