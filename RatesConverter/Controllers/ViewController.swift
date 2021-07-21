//
//  ViewController.swift
//  RatesConverter
//
//  Created by Vladislav on 20.07.2021.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var labelResult: UILabel!
    @IBOutlet weak var textFieldInput: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    // MARK: - Properties
    var currency: [String] = []
    var values: [Double] = []
    var currentRate: Double = 0.0
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        textFieldInput.delegate = self
        getRates()
    }
    
    func getRates() {
        guard let url = URL(string: "https://openexchangerates.org/api/latest.json?app_id=\(K.apiKey)") else {return}
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            
            guard let safeData = data else {return}
            
            do {
                let results = try JSONDecoder().decode(Rates.self, from: safeData)
                self.currency.append(contentsOf: results.rates.keys)
                self.values.append(contentsOf: results.rates.values)
                
                DispatchQueue.main.async {
                    self.pickerView.reloadAllComponents()
                }
            } catch {
                print(error)
                return
            }
        }.resume()
    }
    
    func calculate() {
        if textFieldInput.text != "" {
            labelResult.text = "\(currentRate * Double(textFieldInput.text!)!)"
        }
    }
}

// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        calculate()
        self.view.endEditing(true)
        return true
    }
}

// MARK: - UIPickerViewDelegate
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        currency.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currency[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentRate = values[row]
        calculate()
    }
}

