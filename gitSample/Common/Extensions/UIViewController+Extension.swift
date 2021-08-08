//
//  UIViewController+Extension.swift
//  gitSample
//
//  Created by admin on 2021/08/07.
//

import UIKit
extension UIViewController {
    var topPresentedViewController: UIViewController {
        if let modal = self.presentedViewController {
            return modal.topPresentedViewController
        } else {
            return self
        }
    }
}
