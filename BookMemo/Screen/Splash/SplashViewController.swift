import UIKit
import Lottie

final class SplashViewController: UIViewController {

    struct SplashAnimation {
        static let foxAnimation = "splash"
    }

    private lazy var routing: SplashRouting = {
        let routing = SplashRoutingImpl()
        routing.viewController = self
        return routing
    }()

    private var animationView: AnimationView = {
        let animationView = AnimationView()
        let animation = Animation.named(SplashAnimation.foxAnimation)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFill
        animationView.backgroundColor = .clear
        animationView.animationSpeed = 5
        animationView.contentMode = .scaleAspectFit
        return animationView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Splash"
        view.backgroundColor = .lightGray
        view.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80).isActive = true
        animationView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 50).isActive = true
        animationView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -50).isActive = true
        animationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80).isActive = true
    }

    func showAnimation() {
        animationView.play { [weak self] _ in
            self?.animationView.removeFromSuperview()
            //if 2回目の起動時はログイン {
            //    self?.routing.showSignIn()
            //}
            self?.routing.showSignIn()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAnimation()
    }
}
