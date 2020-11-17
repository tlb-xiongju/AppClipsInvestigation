//
//  PunchURLProtocol.swift
//  Punchor
//
//  Created by 熊 炬 on 2020/11/17.
//

import Foundation

class PunchURLProtocol: URLProtocol {
    var cancelledOrCompleted: Bool = false
    var block: DispatchWorkItem!
    
    private static let queue = OS_dispatch_queue_serial(label: "punchor.xiong.punch")
    
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool { false }
    
    override func startLoading() {
        guard let client = client else { return }
     
        block = DispatchWorkItem(block: {
            if self.cancelledOrCompleted == false {
                client.urlProtocolDidFinishLoading(self)
            }
            self.cancelledOrCompleted = true
        })
        
        PunchURLProtocol.queue.asyncAfter(deadline: .now() + 3, execute: block)
    }
    
    override func stopLoading() {
        PunchURLProtocol.queue.async {
            if self.cancelledOrCompleted == false, let cancelBlock = self.block {
                cancelBlock.cancel()
                self.cancelledOrCompleted = true
            }
        }
    }
}

extension URLSession {
    static var punchSession: URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [PunchURLProtocol.classForCoder()]
        return .init(configuration: config)
    }
}
