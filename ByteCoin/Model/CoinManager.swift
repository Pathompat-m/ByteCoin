//
//  CoinManager.swift
//  ByteCoin
//
// CoinManager is a structure responsible for managing the retrieval of cryptocurrency prices from a web service.
// It defines a protocol named CoinManagerDelegate for handling delegate methods related to price updates and errors.
// CoinManager contains methods for fetching cryptocurrency prices and parsing JSON data received from the server.


import Foundation


// Define a protocol named CoinManagerDelegate.
// This protocol declares two methods that will be implemented by the delegate:
// - didUpdatePrice(price:currency:): Called when the price is successfully retrieved.
// - didFailWithError(error:): Called when there's an error during the process.
protocol CoinManagerDelegate {
    //Create the method stubs without implementation in the protocol.
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    // Base URL for fetching cryptocurrency prices.
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    // API key for accessing the cryptocurrency price API.
    let apiKey = "0228D4EC-88A5-4DDC-9CEF-16A85AFE05C1#"
    
    // Array containing supported currencies.
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    //Create an optional delegate that will have to implement the delegate methods.
    //Which we can notify when we have updated the price.
    var delegate: CoinManagerDelegate?
    
    // Fetches the current price of Bitcoin for a specified currency.
    func getCoinPrice(for currency: String) {
        
        //Construct the URL for fetching the price of Bitcoin in the specified currency.
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        //Use optional binding to unwrap the URL that's created from the urlString
        if let url = URL(string: urlString) {
            
            //Create a new URLSession object with default configuration.
            let session = URLSession(configuration: .default)
            
            //Create a new data task for the URLSession.
            let task = session.dataTask(with: url) { (data,response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                //Format the data we got back as a string to be able to print it.
                if let safeData = data {
                    if let bitcoinPrice = parseJSON(safeData) {
                        //Round the price down to 2 decimal places.
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        
                        //Call the delegate method in the delegate (ViewController) and
                        //pass along the necessary data.
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
            }
            //Start task to fetch data from bitcoin average's servers.
            task.resume()
        }
    }
    
    // Parses the JSON data received from the server to extract the Bitcoin price.
    func parseJSON(_ data: Data) -> Double? {
        
        //Create a JSONDecoder
        let decoder = JSONDecoder()
        do {
            
            //try to decode the data using the CoinData structure
            let decodedData = try decoder.decode(CoinData.self, from: data)
            
            //Get the last property from the decoded data.
            let lastPrice = decodedData.rate
            print(lastPrice)
            return lastPrice

        } catch {
            //Notify the delegate about the error if it exists.
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
