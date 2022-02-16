//
//  NetworkConnectionHelper.swift
//  PlatziTweets
//
//  Created by mac1 on 12/04/21.
//  Copyright © 2021 mac1. All rights reserved.
//

import Foundation
import SystemConfiguration
import CoreTelephony
import Network



@available(iOS 12.0, *)
class NetworkConnectionHelper {
    
    func checkNetwork(completion: @escaping (_ coneccion: Bool?)->() ) {
        DispatchQueue.main.async {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            completion(false)
            return
        }
        //aqui se van a leer las bandera
        var flags: SCNetworkReachabilityFlags = []//(rawValue: 0)
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags)  {
            completion(false)
        }
        
        if flags.isEmpty {
            completion(false)
        }
        
        
         Reachability.isConnectedToNetwork(){(result) in
            guard let resultado = result else {
                return
            }
            let isReachable = flags.contains(.reachable)
            let needsConnection = flags.contains(.connectionRequired)
            
            
            completion(isReachable && !needsConnection && resultado)
            
         }
        
        }

        // Working for Cellular and WIFI
     //   let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
     //   let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
     //   let ret = (isReachable && !needsConnection)
        
        
        
     /*   guard let reachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, "www.google.com") else {
            return false
        }*/

        


        
        
    }
    
    /*let networkMonitor = NWPathMonitor()
    
    func checkNetwork() -> Bool {
        var net = false
        networkMonitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                net = true
            } else {
                net = false
            }
        }
        
        let queue = DispatchQueue(label: "Network connectivity")
        networkMonitor.start(queue: queue)
        return net
    }*/
    
}
