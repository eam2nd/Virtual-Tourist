//
//  DataController.swift
//  Virtual Tourist
//
//  Created by Edward Morton on 8/1/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import CoreData

// MARK: DataController

class DataController {

	// MARK: - Properties

	let container: NSPersistentContainer

	var viewContext: NSManagedObjectContext {
		return container.viewContext
	}

	// MARK: - Intializer

	init(modelName: String) {
		container = NSPersistentContainer(name: modelName)
	}

	// MARK: - Methods

	func load(completion: ( () -> Void)? = nil ) {
		container.loadPersistentStores { storeDescription, error in
			guard error == nil else {
				fatalError(error!.localizedDescription)
			}

			completion?()
		}
	}
}
