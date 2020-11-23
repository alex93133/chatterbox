import UIKit

class LogoEmitterAnimation {

    // MARK: - Properties
    lazy var logoCell: CAEmitterCell = {
        let logoCell = CAEmitterCell()
        logoCell.contents = Images.logo.cgImage
        logoCell.scale = 0.1
        logoCell.scaleRange = 0.1
        logoCell.lifetime = 3
        logoCell.velocity = 100
        logoCell.velocityRange = -20
        logoCell.yAcceleration = 250
        logoCell.spin = 1.5
        logoCell.spinRange = 3
        logoCell.birthRate = 5
        return logoCell
    }()

    lazy var emitter: CAEmitterLayer = {
        let emitter = CAEmitterLayer()
        emitter.emitterShape = CAEmitterLayerEmitterShape.point
        emitter.beginTime = CACurrentMediaTime()
        emitter.emitterCells = [logoCell]
        emitter.birthRate = 0
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

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.cancelsTouchesInView = false

        target.addGestureRecognizer(longPress)
        target.addGestureRecognizer(pan)
        target.addGestureRecognizer(tap)

        target.layer.addSublayer(emitter)
    }

    // MARK: - Actions
    @objc
    func handleLongTap(_ gestureRecognizer: UIGestureRecognizer) {
        let gesturePoint = gestureRecognizer.location(in: target)

        print("x: \(gesturePoint.x), y: \(gesturePoint.y)")

        switch gestureRecognizer.state {
        case .began:
            emitter.emitterPosition = gesturePoint
            emitter.beginTime = CACurrentMediaTime()
            emitter.birthRate = 1

        case .changed:
            emitter.emitterPosition = gesturePoint

        case .ended:
            emitter.emitterPosition = gesturePoint
            emitter.birthRate = 0

        default:
            return
        }
    }

    @objc
    func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        guard gestureRecognizer.state == .ended else { return }
        let gesturePoint = gestureRecognizer.location(in: target)
        emitter.emitterPosition = gesturePoint
        emitter.beginTime = CACurrentMediaTime()
        emitter.birthRate = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else { return }
            self.emitter.birthRate = 0
        }
    }
}
