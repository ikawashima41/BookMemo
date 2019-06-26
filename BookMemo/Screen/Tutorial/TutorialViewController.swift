import UIKit
import RxSwift
import RxCocoa

class TutorialViewController: UIViewController {

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

    //==================================================
    // MARK: - Rx
    //==================================================

    private let disposeBag: DisposeBag = DisposeBag()

    //==================================================
    // MARK: - Routing
    //==================================================

    //==================================================
    // MARK: - UIViewController override
    //==================================================

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        pageControl.currentPage = 0

        setupUI()
        bindUI()
    }
}

extension TutorialViewController {

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        scrollView.addSubview(stacKView)
        stacKView.translatesAutoresizingMaskIntoConstraints = false
        stacKView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stacKView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        stacKView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        stacKView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true

        let firstView = TutorialView()
        stacKView.addArrangedSubview(firstView)
        firstView.applyUI(view: .first)
        firstView.setupUI()
        firstView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        firstView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        firstView.backgroundColor = .lightGray

        let secondView = TutorialView()
        stacKView.addArrangedSubview(secondView)
        secondView.applyUI(view: .second)
        secondView.setupUI()
        secondView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        secondView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        secondView.backgroundColor = .yellow

        let thirdView = TutorialView()
        stacKView.addArrangedSubview(thirdView)
        thirdView.applyUI(view: .third)
        thirdView.setupUI()
        thirdView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        thirdView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        thirdView.backgroundColor = .red

        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
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
                print("•\(Int(self.scrollView.contentOffset.x / self.scrollView.frame.width))")
            }
        }).disposed(by: disposeBag)
    }
}
