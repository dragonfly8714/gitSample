//
//  BaseUIViewController.swift
//  gitSample
//
//  Created by admin on 2021/08/07.
//

import UIKit
class BaseUIViewController: UIViewController {
    var mBaseScrollView: UIScrollView?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setKeyboardNotification(scrollView: UIScrollView) {
        mBaseScrollView = scrollView
        scrollView.keyboardDismissMode = .onDrag

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchesBeganScrollView))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        scrollView .addGestureRecognizer(tapGesture)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func touchesBeganScrollView(_ gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    @objc private func keyboardWillShowNotification(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        mBaseScrollView?.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
    }

    @objc private func keyboardWillHideNotification(notification: NSNotification) {
        mBaseScrollView?.contentInset.bottom = 0
    }
}

extension BaseUIViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer is UITapGestureRecognizer {
            if touch.view is UITextField || touch.view is UIButton || touch.view is UIControl || touch.view is UISearchBar {
                return false
            }
        }

        return true
    }
}
