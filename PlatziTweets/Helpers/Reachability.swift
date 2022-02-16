//
//  Reachability.swift
//  PlatziTweets
//
//  Created by mac1 on 14/04/21.
//  Copyright © 2021 mac1. All rights reserved.
//


import Foundation
public class Reachability {

    class func isConnectedToNetwork(completion:@escaping (_ response: Bool?)->()){

   var Status:Bool = false

    
    let session = URLSession.shared
    let url = URL(string: "http://google.com/")!
    
    let task = session.dataTask(with: url, completionHandler: { data, response, error in
        DispatchQueue.main.async {
        if error != nil {
            print("respuesta de google wito no hubo señal")
            Status = false
            completion(Status)
        }
        
        guard let response = response as? HTTPURLResponse else{
            Status = false
            completion(Status)
            return
        }
            if response.statusCode == 200, let data = data{
            print("respuesta de google wito exitoso", data)
            Status = true
            completion(Status)
        }
        }
    })
    task.resume()


        completion(Status)
 }
}
