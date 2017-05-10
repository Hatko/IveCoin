//
//  ErrorPresenter.swift
//  IveCoin
//
//  Created by vlad on 5/9/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

import Foundation
import UIKit

protocol ErrorPresenter {}

extension ErrorPresenter where Self: UIViewController {
    func showErrorMessage(_ errorMessage: String, title: String = "", dismissHandler: (()->())? = nil) {
        let alertController = UIAlertController(title: title, message: errorMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            dismissHandler?()
        })
        
        present(alertController, animated: true, completion: nil)
    }
}
