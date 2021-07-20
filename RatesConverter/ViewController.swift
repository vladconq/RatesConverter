//
//  ViewController.swift
//  RatesConverter
//
//  Created by Vladislav on 20.07.2021.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    var currency: [String] = []
    var values: [Double] = []
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        currency.count
    }
    
    @IBOutlet weak var labelResult: UILabel!
    @IBOutlet weak var textFieldInput: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        getRates()
    }
    
    struct Rates: Decodable {
        let rates: [String: Double]
    }

    func getRates() {
        URLSession.shared.dataTask(with: URL(string: "https://openexchangerates.org/api/latest.json?app_id=\(K.apiKey)")!) { data, response, error in
            guard error == nil else {return}
            
            do {
                let data = try JSONDecoder().decode(Rates.self, from: data!)
                self.currency.append(contentsOf: data.rates.keys)
                self.values.append(contentsOf: data.rates.values)
            } catch {
                return
            }
        }.resume()
    }

}

