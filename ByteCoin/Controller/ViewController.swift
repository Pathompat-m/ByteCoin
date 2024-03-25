//
//  ViewController.swift
//  ByteCoin
//
// ViewController is responsible for displaying cryptocurrency prices and handling user interactions.
// It adopts the CoinManagerDelegate protocol to receive notifications from CoinManager about price updates and errors.

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CoinManagerDelegate {

    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Must set the coinManager's delegate as this current class so that we can recieve
        //the notifications when the delegate methods are called.
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }

    // MARK: - CoinManagerDelegate Methods
    //Provide the implementation for the delegate methods.
    
    //When the coinManager gets the price it will call this method and pass over the price and currency.
    func didUpdatePrice(price: String, currency: String) {
        //Remember that we need to get hold of the main thread to update the UI, otherwise our app will crash if we
        //try to do this from a background thread (URLSession works in the background).
        DispatchQueue.main.async {
            self.bitcoinLabel.text = price
            self.currencyLabel.text = currency
        }
    }
    
    // Called when there's an error during the process of retrieving the price.
    func didFailWithError(error: Error) {
        print(error)
    }
    
    // MARK: - UIPickerViewDataSource and UIPickerViewDelegate Methods
    // Implement UIPickerViewDataSource and UIPickerViewDelegate methods to handle currency selection.
    
    // Returns the number of components in the picker view.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // initializes an instance
    var coinManager = CoinManager()

    // Returns the number of rows in the specified component.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    // Returns the title for the row in the specified component.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    // Called when a row is selected in the picker view.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }

}

