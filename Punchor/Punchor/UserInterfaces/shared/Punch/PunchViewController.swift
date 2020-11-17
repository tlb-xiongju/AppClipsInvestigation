//
//  ViewController.swift
//  Punchor
//
//  Created by 熊 炬 on 2020/11/10.
//

import UIKit
import CoreLocation

class PunchViewController: UIViewController {
    struct State {
        var isLoading: Bool = false
        var didStart: Bool = false
        var didEnd: Bool = false
        var address: String = ""
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
            backButton.isEnabled = !state.didEnd
            addressLabel.text = state.address
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = DateFormatter.fullDate.string(from: Date())
        
        timeLabel.text = DateFormatter.shortTime.string(from: Date())
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.timeLabel.text = DateFormatter.shortTime.string(from: Date())
        }
        
        #if !APPCLIP
        locationManager.delegate = self
        if locationManager.authorizationStatus == .authorizedWhenInUse ||
            locationManager.authorizationStatus == .authorizedAlways {
            state = State(isLoading: true, didStart: state.didStart, didEnd: state.didEnd, address: state.address)
            locationManager.requestLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        #else
        #endif
    }
    
    #if APPCLIP
    #else
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    #endif
    
    @IBAction private func goButtonTap(_ sender: UIButton) {
        state = State(isLoading: true, didStart: state.didStart, didEnd: state.didEnd, address: state.address)
        PunchManager.shared.punch(.init(state: .start("11:23"), address: state.address)) {
            self.state = State(isLoading: false,
                               didStart: true,
                               didEnd: self.state.didEnd,
                               address: self.state.address)
        }
    }
    
    @IBAction private func backButtonTap(_ sender: UIButton) {
        state = State(isLoading: true, didStart: state.didStart, didEnd: state.didEnd, address: state.address)
        PunchManager.shared.punch(.init(state: .start("11:23"), address: state.address)) {
            self.state = State(isLoading: false,
                               didStart: self.state.didStart,
                               didEnd: true,
                               address: self.state.address)
        }
    }
}

extension PunchViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            state = State(isLoading: true,
                          didStart: state.didStart,
                          didEnd: state.didEnd,
                          address: state.address)
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !geocoder.isGeocoding, let location = locations.last else { return }
        
        geocoder.reverseGeocodeLocation(location) { placemark, error in
            self.state = State(isLoading: false,
                               didStart: self.state.didStart,
                               didEnd: self.state.didEnd,
                               address: placemark?.last?.adderss ?? "")
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        state = State(isLoading: true,
                      didStart: state.didStart,
                      didEnd: state.didEnd,
                      address: state.address)
    }
}

extension PunchViewController: IndicatorDisplayable {}
