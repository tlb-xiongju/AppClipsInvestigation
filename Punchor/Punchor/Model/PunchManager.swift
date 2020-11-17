//
//  PunchManager.swift
//  Punchor
//
//  Created by 熊 炬 on 2020/11/17.
//

import Foundation

let endpoint = "https://punch.xiong.com/punch"

final class PunchManager {
    static let shared = PunchManager()
    
    private var session = URLSession.punchSession
    
    
    func punch(_ punch: Punch, complete: (() -> Void)? = nil) {
        do {
            let json: [String: Any] = try JSONSerialization.jsonObject(with: JSONEncoder().encode(punch), options: .allowFragments) as! [String : Any]
            
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            
            var request = URLRequest(url: URL(string: endpoint)!)
            request.httpMethod = "POST"
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            session.dataTask(with: request) { data, response, error in
                
                DispatchQueue.main.async {
                    complete?()
                }
            }
            .resume()
            
        } catch _ {}
    }
}
