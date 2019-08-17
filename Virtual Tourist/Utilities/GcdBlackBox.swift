//
//  GcdBlackBox.swift
//  Virtual Tourist
//
//  Created by Edward Morton on 8/1/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import Foundation

// MARK: performUiUpdatesOnMain

func performUiUpdatesOnMain(_ updates: @escaping () -> Void) {
	DispatchQueue.main.async {
		updates()
	}
}
