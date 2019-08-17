//
//  FlickrClient.swift
//  Virtual Tourist
//
//  Created by Edward Morton on 8/1/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import Foundation

// MARK: FlickrClient - NSObject

class FlickrClient: NSObject {

	// MARK: - Properties

	private static let endpoint: String = "https://api.flickr.com/services/rest/?method=flickr.photos.search&extras=url_m"
	private static let radius: Int = 10 // in kilometers

	// MARK: - Initializer

	override init() {
		super.init()
	}

	// MARK: - Methods

	func getPhotoUrl(_ farm: Int, _ server: String, _ id: String, _ secret: String) -> String {
		return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
	}

	func getSearchUrl( _ lat: Double, _ lng: Double, _ page: Int) -> String {
		return "\(FlickrClient.endpoint)&api_key=\(FlickrClient.apiKey)&format=json&lat=\(lat)&lon=\(lng)&page=\(page)&radius=\(FlickrClient.radius)"
	}

	func search(_ url: URL, completion: @escaping (FlickrResponse?, Error?) -> Void) -> URLSessionDataTask {
		let request = URLRequest(url: url)
		let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
			func sendError(_ error: String) {
				let userInfo = [NSLocalizedDescriptionKey : error]
				completion(nil, NSError(domain: "search", code: 1, userInfo: userInfo))
			}

			guard error == nil else {
				sendError("There was an error with your request: \(error!)")
				return
			}

			guard let data = data else {
				sendError("No data was returned by the request!")
				return
			}

			let range = 14..<(data.count - 1)
			let subdata = data.subdata(in: range)
			let decoder = JSONDecoder()
			let response = try? decoder.decode(FlickrResponse.self, from: subdata)

			completion(response, nil)
		}

		dataTask.resume()

		return dataTask
	}

	// MARK: - Shared Instance

	class func sharedInstance() -> FlickrClient {
		struct Singleton {
			static var sharedInstance = FlickrClient()
		}

		return Singleton.sharedInstance
	}
}
