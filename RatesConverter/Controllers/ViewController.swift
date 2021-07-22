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
    var currentRate: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratesManager.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        ratesManager.getRates()
        pickerView.reloadAllComponents()
        //        textFieldInput.delegate = self
    }
}


// MARK: - RatesManagerDelegate
extension ViewController: RatesManagerDelegate {
    func didUpdateRates() {
        DispatchQueue.main.async {
//            self.labelResult.text = "\(self.currentRate * Double(self.textFieldInput.text!)!)"
            self.labelResult.text = "\(self.currentRate)"
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
        currentRate = ratesManager.values[row]
        didUpdateRates()
    }
}


// MARK: - UITextFieldDelegate
//extension ViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        didUpdateRates()
//        self.view.endEditing(true)
//        return true
//    }
//}

