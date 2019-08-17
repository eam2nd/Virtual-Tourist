//
//  FlickrPhoto.swift
//  Virtual Tourist
//
//  Created by Edward Morton on 8/1/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

// MARK: FlickrPhoto - Codable

struct FlickrPhoto: Codable {

	// MARK: - Properties

	let id: String
	let owner: String
	let secret: String
	let server: String
	let farm: Int
	let title: String
	let ispublic: Int
	let isfriend: Int
	let isfamily: Int
	let url_m: String
	let height_m: String
	let width_m: String

	// MARK: - CodingKeys - String, CodingKey

	enum CodingKeys: String, CodingKey {
		case id
		case owner
		case secret
		case server
		case farm
		case title
		case ispublic
		case isfriend
		case isfamily
		case url_m
		case height_m
		case width_m
	}
}
