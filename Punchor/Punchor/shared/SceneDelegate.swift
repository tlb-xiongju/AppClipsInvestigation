//
//  SceneDelegate.swift
//  Punchor
//
//  Created by 熊 炬 on 2020/11/10.
//

import UIKit
#if APPCLIP
import AppClip
import CoreLocation
#endif

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
#if APPCLIP
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let incomingURL = userActivity.webpageURL,
              let region = location(from: incomingURL) else { return }

        
        guard let payload = userActivity.appClipActivationPayload else { return }
        payload.confirmAcquired(in: region) { inRegion, error in
            guard let confirmError = error as? APActivationPayloadError else {
                if inRegion {
                    
                } else {
                    
                }
                return
            }
            
            if confirmError.code == .doesNotMatch {
                
            } else {
                
            }
        }
    }
    
    func location(from url: URL) -> CLRegion? {
        let coordinates = CLLocationCoordinate2D(latitude: 37.334722,
                                                 longitude: 122.008889)
        return CLCircularRegion(center: coordinates,
                                radius: 100,
                                identifier: "teamLab.inc")
    }
#endif
}

