//
//  CurrentLocationManager.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 2/24/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit
import CoreLocation

protocol CurrentLocationManagerProtocol: NSObjectProtocol {
    func locationDidUpdate(coordinate: CLLocationCoordinate2D)
    func locationDidFailRequest()
}

extension CurrentLocationManagerProtocol {
    func locationDidFailRequest() {}
}

class CurrentLocationManager: NSObject {
    
    static let shared = CurrentLocationManager()

    private var locationManager: CLLocationManager!
    
    @objc dynamic private(set) var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    private(set) var isDetermined: Bool = false
    
    @objc dynamic private(set) var canGetLocation: Bool = false
    
    private var didUpdateLocation: Bool = false

    weak var delegate: CurrentLocationManagerProtocol?
    
    override private init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.delegate = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationWillResignActive),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
        
        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    @objc private func applicationWillResignActive() {
        print(#function)
        print(locationManager.allowsBackgroundLocationUpdates)
    }
    
    @objc private func applicationDidBecomeActive() {
        requestLocation()
    }

    func requestWhenInUseAuthorization() {
        //        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
    }

    func requestLocation() {
        if canGetLocation {
            didUpdateLocation = false
            locationManager.startUpdatingLocation()
        } else {
            delegate?.locationDidFailRequest()
        }
    }

    func stopRequestingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

extension CurrentLocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("Location Permission Not Determined")
            self.isDetermined = false
            self.canGetLocation = false
            self.delegate?.locationDidFailRequest()
        case .denied:
            print("Location Permission Denied")
            self.isDetermined = true
            self.canGetLocation = false
            self.delegate?.locationDidFailRequest()
        case .restricted:
            print("Location Permission Restricted")
            self.isDetermined = true
            self.canGetLocation = false
            self.delegate?.locationDidFailRequest()
        case .authorizedAlways:
            print("Location Permission Authorized Always")
            self.isDetermined = true
            self.canGetLocation = true
            self.requestLocation()
        case .authorizedWhenInUse:
            print("Location Permission Authorized When In Use")
            self.isDetermined = true
            self.canGetLocation = true
            self.requestLocation()
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !didUpdateLocation, locations.count > 0 else { return }

        let lat = locations[0].coordinate.latitude
        let lng = locations[0].coordinate.longitude
        print("location count: \(locations.count)")
        print("lat: \(lat)\nlng: \(lng)")
        
        self.coordinate = locations[0].coordinate
        
        locationManager.stopUpdatingLocation()
        if !didUpdateLocation {
            didUpdateLocation = true
            delegate?.locationDidUpdate(coordinate: locations[0].coordinate)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
        print(error)
        print("Error- didFailWithError ")
        delegate?.locationDidUpdate(coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
        //        coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    }
}
