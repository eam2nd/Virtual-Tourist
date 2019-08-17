//
//  MapViewController+MapDelegate.swift
//  Virtual Tourist
//
//  Created by Edward Morton on 8/1/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import MapKit

// MARK: MapViewController - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {

	// MARK: - Methods

	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		performSegue(withIdentifier: "showPhotos", sender: view.annotation?.coordinate)
		mapView.deselectAnnotation(view.annotation, animated: false)
	}

	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		let reuseId = "pin"
		var pin = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

		if pin == nil {
			pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
			pin?.canShowCallout = false
			pin?.animatesDrop = false
		} else {
			pin?.annotation = annotation
		}

		return pin
	}
}
