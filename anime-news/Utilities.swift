//
//  Utilities.swift
//  anime-news
//
//  Created by Lucy Zhang on 4/25/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import Foundation


//post request
func makeHTTPRequest(type: String, path: String, body: [String: Any]?,completion: @escaping (_ result:[String?]) -> Void) {
    print("Make POST request")
    let request = NSMutableURLRequest(url: NSURL(string: path)! as URL)
    
    // Set the method to POST
    request.httpMethod = type
    
    do {
        // Set the POST body for the request
        //let jsonBody = try NSJSONSerialization.dataWithJSONObject(body, options: .PrettyPrinted)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        if let body = body{
            request.httpBody = try! JSONSerialization.data(withJSONObject: body, options: [])
        }
        //request.HTTPBody = jsonBody
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if data != nil {
                //let json:JSON = JSON(data: jsonData)
                //onCompletion(json, nil)
                print("The Response: ")
                //print(data!)
                let articles = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as? [String]
                if ((completion) != nil) {
                    completion(articles!)
                }
            } else {
                //onCompletion(nil, error)
            }
        })
        task.resume()
    } catch {
        // Create your personal error
        //onCompletion(nil, nil)
    }
}
