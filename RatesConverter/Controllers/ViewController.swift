//
//  ViewController.swift
//  RatesConverter
//
//  Created by Vladislav on 20.07.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var labelResult: UILabel!
    @IBOutlet weak var textFieldInput: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var ratesManager = RatesManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ratesManager.delegate = self
        textFieldInput.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        
        ratesManager.getRates()
        
        textFieldInput.text = "0"
    }
}

// MARK: - RatesManagerDelegate
extension ViewController: RatesManagerDelegate {
    func didUpdateRates() {
        DispatchQueue.main.async {
            if self.textFieldInput.text == "" {
                self.labelResult.text = "Enter the value"
                return
            }
            
            let inputNumber = Double(self.textFieldInput.text!)!
            let resultNumber = inputNumber / self.ratesManager.currentRate
            let resultNumberStr = String(format: "%0.2f", resultNumber)
            self.labelResult.text = "\(resultNumberStr) $"
            self.pickerView.reloadAllComponents()
        }
    }
}

// MARK: - UIPickerViewDelegate
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ratesManager.currencyCode.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ratesManager.currencyCode[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ratesManager.currentRate = ratesManager.values[row]
        didUpdateRates()
    }
}

// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didUpdateRates()
        self.view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = "1234567890"
        let allowedCharactersSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharactersSet = CharacterSet(charactersIn: string)
        return allowedCharactersSet.isSuperset(of: typedCharactersSet)
    }
}
