//
//  TodayViewController.swift
//  OmskWeatherToday
//
//  Created by Dmitry Valov on 25.01.2018.
//  Copyright © 2018 Dmitry Valov. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    @IBAction func updateTemperature(_ sender: Any) {
        getTemperature() { str in
            DispatchQueue.main.async {
                self.temperatureLabel.text = str + " °C"

                let currentDateTime = Date()
                let formatter = DateFormatter()
                formatter.timeStyle = .medium
                formatter.dateStyle = .none
                self.timeLabel.text = "обновлено: " + formatter.string(from: currentDateTime)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.temperatureLabel.text = ""
        self.timeLabel.text = "обновляется..."
        
        getTemperature() { str in
            DispatchQueue.main.async {
                self.temperatureLabel.text = str + " °C"
                let currentDateTime = Date()
                
                // initialize the date formatter and set the style
                let formatter = DateFormatter()
                formatter.timeStyle = .medium
                formatter.dateStyle = .none
                self.timeLabel.text = "обновлено: " + formatter.string(from: currentDateTime)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
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
    }    
}
