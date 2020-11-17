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
    }
    
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var goButton: UIButton!
    @IBOutlet private weak var backButton: UIButton!
    
    private lazy var timer = Timer()
    private var state: State = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        goButton.layer.maskedCorners = .init(rawValue: 1)
        goButton.layer.cornerRadius = 36
        goButton.clipsToBounds = true
        backButton.layer.maskedCorners = .init(rawValue: 2)
        backButton.layer.cornerRadius = 36
        backButton.clipsToBounds = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = .init(identifier: .gregorian)
        dateFormatter.dateStyle = .full
        
        title = dateFormatter.string(from: Date())
        
        let timeFormatter = DateFormatter()
        timeFormatter.calendar = .init(identifier: .gregorian)
        timeFormatter.dateFormat = "HH:mm"
        timeLabel.text = timeFormatter.string(from: Date())
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.timeLabel.text = timeFormatter.string(from: Date())
        }
        

        #if !APPCLIP
        locationManager.delegate = self
        if locationManager.authorizationStatus == .authorizedWhenInUse ||
            locationManager.authorizationStatus == .authorizedAlways{
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
        showIndicator()
        PunchManager.shared.punch(.init(state: .start("11:23"), address: "Tokyo, Chiyoda")) {
            self.removeIndicator()
        }
    }
    
    @IBAction private func backButtonTap(_ sender: UIButton) {
        
    }
}
extension PunchViewController: IndicatorDisplayable {}

extension PunchViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !geocoder.isGeocoding, let location = locations.last else { return }
        
        geocoder.reverseGeocodeLocation(location) { placemark, error in
            self.addressLabel.text = placemark?.last?.adderss
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       print(error)
    }
}

extension CLPlacemark {
    var adderss: String? {
        "\(administrativeArea ?? "")\(locality ?? "")\(subLocality ?? "")"
    }
}

