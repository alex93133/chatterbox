import UIKit

class LogoEmitterAnimation {

    // MARK: - Properties
    lazy var logoCell: CAEmitterCell = {
        let logoCell = CAEmitterCell()
        logoCell.contents = Images.logo.cgImage
        logoCell.scale = 0.1
        logoCell.scaleRange = 0.1
        logoCell.lifetime = 5
        logoCell.velocity = 100
        logoCell.yAcceleration = 300
        logoCell.spin = 1.5
        logoCell.spinRange = 3
        logoCell.emissionRange = .pi
        logoCell.birthRate = 3
        return logoCell
    }()

    lazy var emitter: CAEmitterLayer = {
        let emitter = CAEmitterLayer()
        emitter.emitterShape = CAEmitterLayerEmitterShape.point
        emitter.beginTime = CACurrentMediaTime()
        emitter.emitterCells = [logoCell]
        emitter.lifetime = 0
        emitter.emitterMode = .volume
        return emitter
    }()

    var target: UIView

    init(target: UIView) {
        self.target = target
    }

    // MARK: - Functions
    func addLogoEmitter() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTap))

        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleLongTap))

        target.addGestureRecognizer(longPress)
        target.addGestureRecognizer(pan)

        target.layer.addSublayer(emitter)
    }

    // MARK: - Actions
    @objc
    func handleLongTap(_ gestureRecognizer: UIGestureRecognizer) {
        let gesturePoint = gestureRecognizer.location(in: target)

        switch gestureRecognizer.state {
        case .began:
            emitter.emitterPosition = gesturePoint
            emitter.lifetime = 1

        case .changed:
            emitter.emitterPosition = gesturePoint

        case .ended:
            emitter.emitterPosition = gesturePoint
            emitter.lifetime = 0

        default:
            return
        }
    }
}
