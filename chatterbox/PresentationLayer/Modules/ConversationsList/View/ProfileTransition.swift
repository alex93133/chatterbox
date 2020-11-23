import UIKit

class ProfileTransition: NSObject, UIViewControllerAnimatedTransitioning {

    let duration = 1.0

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        guard let navigationController = transitionContext.viewController(forKey: .to) as? UINavigationController,
              let toView = transitionContext.view(forKey: .to),
              let profileViewController = navigationController.viewControllers.first as? ProfileViewController else { return }

        containerView.addSubview(toView)
        let view = profileViewController.profileView

        profileViewController.navigationController?.setNavigationBarHidden(true, animated: false)
        view.alpha = 0
        view.photoImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        view.nameTextView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        view.saveButtonGCD.transform = CGAffineTransform(translationX: -256, y: 0)
        view.saveButtonOperation.transform = CGAffineTransform(translationX: 256, y: 0)

        UIView.animateKeyframes(withDuration: duration, delay: 0, options: []) {
            profileViewController.navigationController?.setNavigationBarHidden(false, animated: true)

            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                view.alpha = 1
            }

            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.5) {
                view.photoImageView.transform = .identity
                view.saveButtonGCD.transform = .identity
                view.saveButtonOperation.transform = .identity
            }

            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25) {
                view.nameTextView.transform = .identity
            }

        } completion: { finished in
            transitionContext.completeTransition(finished)
        }
    }
}
