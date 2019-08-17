//
//  ViewController+Alert.swift
//  Virtual Tourist
//
//  Created by Edward Morton on 8/1/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import UIKit

// MARK: UIViewController - Extension

extension UIViewController {

	// MARK: - Methods

	func alert(_ title: String, _ message: String, _ actions: [String]? = nil, completion: ((_ action: UIAlertAction?) -> Void)? = nil) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

		if let actions = actions {
			for action in actions {
				alert.addAction(UIAlertAction(title: action, style: .default, handler: { (action) in
					completion?(action)
				}))
			}
		} else {
			alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
				completion?(action)
			}))
		}

		self.present(alert, animated: true, completion: nil)
	}
}
