
import UIKit

private var indicatorView: UIActivityIndicatorView?

class HUDIndicator {
    
    static func show(_ view: UIView) {
        indicatorView = UIActivityIndicatorView(style: .medium)
        guard let indicatorView = indicatorView else {return}
        view.addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                indicatorView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                indicatorView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
            ]
        )
        indicatorView.hidesWhenStopped = true
        indicatorView.startAnimating()
    }
    
    static func dismiss() {
        DispatchQueue.main.async {
            indicatorView?.stopAnimating()
            indicatorView?.removeFromSuperview()
        }
    }
}
