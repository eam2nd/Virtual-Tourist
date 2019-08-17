//
//  MapViewController.swift
//  Virtual Tourist
//
//  Created by Edward Morton on 8/1/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import UIKit
import MapKit
import CoreData

// MARK: MapViewController - UIViewController, UIGestureRecognizerDelegate

class MapViewController: UIViewController, UIGestureRecognizerDelegate {

	// MARK: - Properties

	var dataController: DataController!
	var fetchedResultsController: NSFetchedResultsController<Pin>!

	// MARK: - Outlets

	@IBOutlet weak var mapView: MKMapView!

	// MARK: - Actions

	@IBAction func longPressGesture(_ sender: UILongPressGestureRecognizer) {
		if sender.state == .began {
			let location = sender.location(in: mapView)

			addPin(location)
		}
	}

	// MARK: - Methods

	fileprivate func setupFetchedResultsController() {
		let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
		let sortDescriptor = NSSortDescriptor(key: "lat", ascending: true)

		fetchRequest.sortDescriptors = [sortDescriptor]
		fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
		fetchedResultsController.delegate = self

		do {
			try fetchedResultsController.performFetch()
		} catch {
			fatalError("The fetch could not be performed: \(error.localizedDescription)")
		}
	}

	func addPin(_ fromPoint: CGPoint) {
		let viewContext = dataController.viewContext
		let coord = mapView.convert(fromPoint, toCoordinateFrom: mapView)

		viewContext.perform {
			let p = Pin(context: viewContext)

			p.lat = coord.latitude
			p.lng = coord.longitude

			try? viewContext.save()
		}
	}

	func displayPin(_ latitude: Double, _ longitude: Double ) {
		let lat = CLLocationDegrees(latitude)
		let lng = CLLocationDegrees(longitude)
		let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
		let annotation = MKPointAnnotation()

		annotation.coordinate = coordinate
		mapView.addAnnotation(annotation)
	}

	func displayPins() {
		if let fetchedObjects = fetchedResultsController.fetchedObjects {
			for object in fetchedObjects {
				displayPin(object.lat, object.lng)
			}
		}
	}

	func findPin(_ coordinate: CLLocationCoordinate2D) -> Pin? {
		if let pins = fetchedResultsController.fetchedObjects {
			for pin in pins {

				if pin.lat == coordinate.latitude && pin.lng == coordinate.longitude {
					return pin
				}
			}
		}

		return nil
	}

	// MARK: Prepare For Segue

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showPhotos" {
			let vc = segue.destination as! PhotoViewController
			let coord = sender as! CLLocationCoordinate2D

			if let pin = findPin(coord) {
				vc.dataController = dataController
				vc.pin = pin
			}
		}
	}

	// MARK: - View Life Cycle

	override func viewDidLoad() {
		super.viewDidLoad()

		mapView.delegate = self
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		setupFetchedResultsController()
		displayPins()
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)

		fetchedResultsController = nil
	}
}
