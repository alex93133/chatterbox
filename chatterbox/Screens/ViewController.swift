import UIKit

class ViewController: UIViewController {

    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        printLogs(text: "View is loaded into memory.: \(#function)")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        printLogs(text: "View is about to be added to a view hierarchy: \(#function)")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        printLogs(text: "View was added to a view hierarchy: \(#function)")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        printLogs(text: "View is about to layout its subviews: \(#function)")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        printLogs(text: "View has just laid out its subviews: \(#function)")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        printLogs(text: "View is about to be removed from a view hierarchy: \(#function)")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        printLogs(text: "View was removed from a view hierarchy: \(#function)")
    }
}
