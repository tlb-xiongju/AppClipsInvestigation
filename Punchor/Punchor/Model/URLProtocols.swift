//
//  PunchURLProtocol.swift
//  Punchor
//
//  Created by 熊 炬 on 2020/11/17.
//

import Foundation

class FetchURLProtocol: URLProtocol {
    var cancelledOrCompleted: Bool = false
    var block: DispatchWorkItem!
    
    private static let queue = OS_dispatch_queue_serial(label: "punchor.xiong.fetch")
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        false
    }
    
    override func startLoading() {
        guard let requestURL = request.url, let urlClient = client else {
            return
        }
        
        block = DispatchWorkItem(block: {
            if self.cancelledOrCompleted == false {
                let fileURL = URL(fileURLWithPath: requestURL.path)
                if let data = try? Data(contentsOf: fileURL) {
                    urlClient.urlProtocol(self, didLoad: data)
                    urlClient.urlProtocolDidFinishLoading(self)
                }
            }
            self.cancelledOrCompleted = true
        })
        
        FetchURLProtocol.queue.asyncAfter(deadline: .init(uptimeNanoseconds: 500 * NSEC_PER_MSEC), execute: block)
    }
    
    override func stopLoading() {
        FetchURLProtocol.queue.async {
            if self.cancelledOrCompleted == false, let cancelBlock = self.block {
                cancelBlock.cancel()
                
                self.cancelledOrCompleted = true
            }
        }
    }
}

class PunchURLProtocol: URLProtocol {
    var cancelledOrCompleted: Bool = false
    var block: DispatchWorkItem!
    
    private static let queue = OS_dispatch_queue_serial(label: "punchor.xiong.punch")
    
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool { false }
    
    override func startLoading() {
        guard let url = request.url, let client = client else {
            return
        }
     
        block = DispatchWorkItem(block: {
            if self.cancelledOrCompleted == false {
                // TODO: write url query to file
            }
            self.cancelledOrCompleted = true
        })
        
        PunchURLProtocol.queue.asyncAfter(deadline: .init(uptimeNanoseconds: 500 * NSEC_PER_MSEC), execute: block)
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
    static var featchRecordsSesson: URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [FetchURLProtocol.classForCoder()]
        return .init(configuration: config)
    }
    
    static var punchSession: URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [PunchURLProtocol.classForCoder()]
        return .init(configuration: config)
    }
}
