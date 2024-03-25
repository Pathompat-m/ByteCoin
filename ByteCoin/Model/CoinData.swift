//
//  CoinData.swift
//  ByteCoin
//
// CoinData is a structure representing the JSON response received from the server.
// It conforms to the Decodable protocol to allow for decoding JSON data into a Swift object.

import Foundation

struct CoinData: Codable {
    
    // There's only 1 property we're interested in the JSON data, that's the last price of Bitcoin
    // Because it's a decimal number, we'll give it a Double data type.
    let rate: Double
}
