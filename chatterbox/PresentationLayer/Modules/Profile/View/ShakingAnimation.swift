import UIKit

class ShakingAnimation {

    // MARK: - Properties
    private let duration = 0.3
    private let shakingIdentifier = "Shaking"
    private let startIdentifier = "Start"
    var target: UIView

    init(target: UIView) {
        self.target = target
    }

    // MARK: - Functions
    func start(angle: Double, offset: CGFloat) {
        CATransaction.begin()
        let moveToStartPosition = CABasicAnimation(keyPath: #keyPath(CALayer.position))
        moveToStartPosition.duration = duration / 4
        moveToStartPosition.fromValue = CGPoint(x: 0, y: 0)
        moveToStartPosition.toValue = CGPoint(x: offset, y: offset)
        moveToStartPosition.isAdditive = true
        moveToStartPosition.fillMode = .both
        moveToStartPosition.isRemovedOnCompletion = false

        CATransaction.setCompletionBlock {
            self.shakingAnimation(angle: angle, offset: offset)
        }

        target.layer.add(moveToStartPosition, forKey: startIdentifier)
        CATransaction.commit()
    }

    private func shakingAnimation(angle: Double, offset: CGFloat) {
        let moveAnimation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        let range = 2 * (-offset)
        let position1 = CGPoint(x: 0, y: 0)
        let position2 = CGPoint(x: 0, y: range)
        let position3 = CGPoint(x: range, y: range)
        let position4 = CGPoint(x: range, y: 0)

        moveAnimation.values = [position1, position2, position3, position4, position1]
        moveAnimation.isAdditive = true

        let rotateAnimation = CAKeyframeAnimation(keyPath: "transform.rotation")

        rotateAnimation.values = [0.degreesToRadians,
                                  (angle).degreesToRadians,
                                  0.degreesToRadians,
                                  (-angle.degreesToRadians),
                                  0.degreesToRadians]

        let group = CAAnimationGroup()
        group.duration = duration
        group.repeatCount = .infinity
        group.animations = [moveAnimation, rotateAnimation]

        target.layer.add(group, forKey: shakingIdentifier)
    }

    func cancel() {
        guard let currentPosition = target.layer.presentation()?.value(forKeyPath: #keyPath(CALayer.position)),
              let currentAngle = target.layer.presentation()?.value(forKeyPath: "transform.rotation") else { return }

        target.layer.removeAnimation(forKey: startIdentifier)
        target.layer.removeAnimation(forKey: shakingIdentifier)

        let moveAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.position))

        moveAnimation.fromValue = currentPosition
        let size = target.frame.size
        moveAnimation.toValue = CGPoint(x: size.width / 2, y: size.height / 2)

        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")

        rotateAnimation.fromValue = currentAngle
        rotateAnimation.toValue = 0.degreesToRadians

        let group = CAAnimationGroup()
        group.duration = duration / 4
        group.animations = [moveAnimation, rotateAnimation]
        group.fillMode = .forwards

        target.layer.add(group, forKey: nil)
    }
}
