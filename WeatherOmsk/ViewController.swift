//
//  ViewController.swift
//  WeatherOmsk
//
//  Created by Dmitry Valov on 25.01.2018.
//  Copyright © 2018 Dmitry Valov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var updateLabel: UILabel!
    
    
    @IBAction func updateAction(_ sender: Any) {
        getTemperature() { str in
            DispatchQueue.main.async {
                self.tempLabel.text = str + " °C"
                
                let currentDateTime = Date()
                let formatter = DateFormatter()
                formatter.timeStyle = .medium
                formatter.dateStyle = .none
                self.updateLabel.text = "обновлено: " + formatter.string(from: currentDateTime)
            }
        }
        getTemperatureImage()
    }
    
    @IBOutlet weak var temperatureImage1: UIImageView!
    @IBOutlet weak var temperatureImage2: UIImageView!
    @IBOutlet weak var temperatureImage3: UIImageView!
    @IBOutlet weak var temperatureImage4: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tempLabel.text = ""
        self.updateLabel.text = "обновляется..."

        getTemperature() { str in
            DispatchQueue.main.async {
                self.tempLabel.text = str + " °C"
                
                let currentDateTime = Date()
                let formatter = DateFormatter()
                formatter.timeStyle = .medium
                formatter.dateStyle = .none
                self.updateLabel.text = "обновлено: " + formatter.string(from: currentDateTime)
            }
        }
        getTemperatureImage()
    }
    
    func getTemperatureImage() {
        var errorsCount = 0
        
        if let url1 = URL(string: "http://myxa.opsb.ru/pics/daily.png") {
            do {
                let data1 = try Data(contentsOf: url1)
                self.temperatureImage1.image = UIImage(data: data1)
            }
            catch{
                errorsCount += 1
                print(error)
            }
        }
        if let url2 = URL(string: "http://myxa.opsb.ru/pics/weekly.png") {
            do {
                let data2 = try Data(contentsOf: url2)
                self.temperatureImage2.image = UIImage(data: data2)
            }
            catch{
                errorsCount += 1
                print(error)
            }
        }
        if let url3 = URL(string: "http://myxa.opsb.ru/pics/monthly.png") {
            do {
                let data3 = try Data(contentsOf: url3)
                self.temperatureImage3.image = UIImage(data: data3)
            }
            catch{
                errorsCount += 1
                print(error)
            }
        }
        if let url4 = URL(string: "http://myxa.opsb.ru/pics/annual.png") {
            do {
                let data4 = try Data(contentsOf: url4)
                self.temperatureImage4.image = UIImage(data: data4)
            }
            catch{
                errorsCount += 1
                print(error)
            }
        }
        
        if errorsCount > 0 {
            
            
        }
    }
    
    func getTemperature(completion: @escaping (String) -> ()) {
        if let url = URL(string: "http://myxa.opsb.ru/graphs.html") {
            var request = URLRequest(url: url)
            request.setValue("text/html", forHTTPHeaderField: "Content-type")
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request) {
                data, response, error in
                
                let strData:String =  String(data: data!, encoding: String.Encoding.windowsCP1251)!
                
                let endTextRange = strData.range(of: "\n&deg")
                let end_index = strData.distance(from:strData.startIndex, to: (endTextRange?.lowerBound)!)
                let string = strData.prefix(end_index)
                
                let start_index = string.reversed().index(of: " ")
                let finalLength = string.reversed().distance(from:string.reversed().startIndex, to:start_index!)
                
                let result:String = String(string.suffix(finalLength))
                
                completion(result)
            }
            task.resume()
        }
        else {
            //todo implement alert here            
        }
    }
}
