//
//  Utilities.swift
//  anime-news
//
//  Created by Lucy Zhang on 4/25/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import Foundation

struct Article{
    var Id : Int = 0
    var title = ""
    var article = ""
    var date = ""
}

//post request
func makeHTTPRequest(type: String, path: String, body: [String: Any]?,completion: @escaping (_ result:String?) -> Void) {
    //print("Make POST request")
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
                let arr2 = data?.withUnsafeBytes {
                    Array(UnsafeBufferPointer<UInt32>(start: $0, count: (data?.count)!/MemoryLayout<UInt32>.size))
                }
                print(arr2!)
                
                let articles = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as String?
 
                //if (completion) {
                completion(articles!)
                //}
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
func parseJson(anyObj:AnyObject) -> Array<Article>{
    
    var list:Array<Article> = []
    
    if  anyObj is Array<AnyObject> {
        
        var b:Article = Article()
        
        for json in anyObj as! Array<AnyObject>{
            b.title = (json["title"] as AnyObject? as? String) ?? "" // to get rid of null
            b.article  =  (json["article"]  as AnyObject? as? String) ?? ""
            
            list.append(b)
        }// for
        
    } // if
    
    return list
    
}//func
