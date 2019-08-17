//
//  MapViewController+FRCDelegate.swift
//  Virtual Tourist
//
//  Created by Edward Morton on 8/1/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import CoreData

// MARK: MapViewController - NSFetchedResultsControllerDelegate

extension MapViewController: NSFetchedResultsControllerDelegate {

	// MARK: - Methods

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		switch type {
		case .insert:
			if let p = anObject as? Pin {
				displayPin(p.lat, p.lng)
			}
		default:
			return
		}
	}
}
