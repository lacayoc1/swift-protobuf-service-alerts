//
//  ViewController.swift
//  service-alerts
//
//  Created by Rances Lacayo on 1/14/20.
//  Copyright © 2020 Rances Lacayo. All rights reserved.
//

import UIKit
import SwiftProtobuf

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Create a BookInfo object and populate it:
        var info = BookInfo()
        info.id = 1734
        info.title = "Really Interesting Book"
        info.author = "Jane Smith"

        // As above, but generating a read-only value:
        let info2 = BookInfo.with {
            $0.id = 1735
            $0.title = "Even More Interesting"
            $0.author = "Jane Q. Smith"
          }

        do {
            // Serialize to binary protobuf format:
            let binaryData: Data = try info.serializedData()
            
            // Deserialize a received Data object from `binaryData`
            let decodedInfo = try BookInfo(serializedData: binaryData)
            print(">>>>>>>>>>>")
            print(decodedInfo)
            
            // Serialize to JSON format as a Data object
            let jsonData: Data = try info2.jsonUTF8Data()
            // Deserialize from JSON format from `jsonData`
            let receivedFromJSON = try BookInfo(jsonUTF8Data: jsonData)
            print(">>>>>>>>>>>")
            print(receivedFromJSON)
        } catch {
            print(error)
        }
        
        readAlerts()
    }
    
    func readAlerts(){
        // Get your own key at: https://developer-portal.ridemetro.org/docs/services/541cd1fb84e5d412e4de5fc0/operations/541cd27484e5d412e4de5fc1
        let request = URLRequest(url: URL(string:"https://api.ridemetro.org/GtfsAlerts/Alerts?subscription-Key=*******")!)
        
        print(request)
        
        URLSession.shared.dataTask(with: request) { (data, _, _) in
            // custom type
            
            guard let response = try? TransitRealtime_FeedMessage(serializedData: data!) else {
                // error
                return
            }
            //print(response)
            
            guard let receivedFromJSON = try? TransitRealtime_FeedMessage(jsonUTF8Data: response.jsonUTF8Data()) else{
                return
            }
            print(receivedFromJSON)
        }.resume()
    }
}
