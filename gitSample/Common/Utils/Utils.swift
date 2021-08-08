//
//  Utils.swift
//  gitSample
//
//  Created by admin on 2021/08/07.
//

import UIKit
public class Utils {
    internal static func presentAlert(title: String?, message: String?, handler: (() -> Void)?) {
        DispatchQueue.main.async {
            if let navi = APP_DELEGATE?.window?.rootViewController as? UINavigationController {
                let vc = navi.topPresentedViewController

                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                if let popoverController = alert.popoverPresentationController {
                    popoverController.sourceView = vc.view
                    popoverController.sourceRect = CGRect(x: vc.view.bounds.midX, y: vc.view.bounds.midY, width: 0, height: 0)
                    popoverController.permittedArrowDirections = []
                }

                let action = UIAlertAction(title: "확인", style: .cancel) { _ in
                    handler?()
                }

                alert.addAction(action)
                vc.present(alert, animated: true, completion: nil)
            }
        }
    }
}

func LOG(_ msg: Any?, file: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
    let fileName = file.split(separator: "/").last ?? ""
    let funcName = function.split(separator: "(").first ?? ""
    print("[\(fileName)] \(funcName)(\(line)): \(msg ?? "")")
    #endif
}
