//
//  ViewController.swift
//  Punchor
//
//  Created by 熊 炬 on 2020/11/10.
//

import UIKit
import CoreLocation
import StoreKit

class PunchViewController: UIViewController {
    struct State: Then {
        var isLoading: Bool = false
        var didStart: Bool = false
        var didEnd: Bool = false
        var address: String = ""
        var now: Date = Date()
    }
    
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var goButton: UIButton!
    @IBOutlet private weak var backButton: UIButton!
    
    private lazy var timer = Timer()
    private var state = State() {
        didSet {
            if state.isLoading != oldValue.isLoading {
                state.isLoading ? showIndicator() : removeIndicator()
            }
            
            goButton.isEnabled = !state.didStart
            backButton.isEnabled = (state.didStart && !state.didEnd)
            addressLabel.text = state.address
            timeLabel.text = DateFormatter.shortTime.string(from: state.now)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = DateFormatter.fullDate.string(from: Date())
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.state = self.state.with { $0.now = Date() }
        }
        
        #if !APPCLIP
        locationManager.delegate = self
        if locationManager.authorizationStatus == .authorizedWhenInUse ||
            locationManager.authorizationStatus == .authorizedAlways {
            state = state.with { $0.isLoading = true }
            locationManager.requestLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        #else
        
        guard let scene = view.window?.windowScene else { return }
        let config = SKOverlay.AppClipConfiguration(position: .bottom)
        let overlay = SKOverlay(configuration: config)
        overlay.present(in: scene)
        
        #endif
    }
    
    #if APPCLIP
    #else
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    #endif
    
    @IBAction private func goButtonTap(_ sender: UIButton) {
        state = state.with { $0.isLoading = true }
        PunchManager.shared.punch(.init(state: .start(DateFormatter.shortTime.string(from: state.now)), address: state.address)) {
            self.state = self.state.with {
                $0.isLoading = false
                $0.didStart = true
            }
        }
    }
    
    @IBAction private func backButtonTap(_ sender: UIButton) {
        state = state.with { $0.isLoading = true }
        PunchManager.shared.punch(.init(state: .end(DateFormatter.shortTime.string(from: state.now)), address: state.address)) {
            self.state = self.state.with {
                $0.isLoading = false
                $0.didEnd = true
            }
        }
    }
}

#if APPCLIP
#else
extension PunchViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            state = state.with { $0.isLoading = true }
            
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !geocoder.isGeocoding, let location = locations.last else { return }
        
        geocoder.reverseGeocodeLocation(location) { placemark, error in
            self.state = self.state.with {
                $0.isLoading = false
                $0.address = placemark?.last?.adderss ?? ""
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        state = state.with { $0.isLoading = false }
    }
}
#endif

extension PunchViewController: IndicatorDisplayable {}
