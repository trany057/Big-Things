//
//# Author:    Tran Ngoc Thien Kim
//# Email Id:   TRANY057
//# Description:  Big Things, IOS assignment 2
//# This is my own work as defined by the University's Academic Misconduct policy.

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    private let locationManager = CLLocationManager()    
    var bigthings: [BigThing]?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        checkLocationAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
    }

    private func setupMapView() {
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.delegate = self
    }
    
    private func checkLocationAuthorization() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .restricted, .denied:
            let alert = UIAlertController(title: "Access Needed", message: "Please allow location access to show your location on the map.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true)
        @unknown default:
            break
        }
    }
    
    private func getLocationOfBigthingNear() {
        guard let userLocation = locationManager.location else { return }
        let radius: Double = 500000
        
        bigthings?.forEach { bigThing in
            let bigThingLocation = CLLocation(latitude: Double(bigThing.latitude) ?? 0.0, longitude: Double(bigThing.longitude) ?? 0.0)
            let distance = bigThingLocation.distance(from: userLocation)
            if distance <= radius {
                let annotation = BigThingAnnotation()
                annotation.coordinate = bigThingLocation.coordinate
                annotation.title = bigThing.name
                annotation.bigThing = bigThing
                mapView.addAnnotation(annotation)
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }
        let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 400000, longitudinalMeters: 400000)
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = userLocation.coordinate
        getLocationOfBigthingNear()
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? BigThingAnnotation, let selectedBigThing = annotation.bigThing else { return }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let sideSheetViewController = storyboard.instantiateViewController(withIdentifier: "SideSheetViewController") as? SideSheetViewController {
            if let sheet = sideSheetViewController.sheetPresentationController {
                sheet.detents = [.medium()]
            }
            sideSheetViewController.bigThing = selectedBigThing
            present(sideSheetViewController, animated: true, completion: nil)
        }
    }
} 
class BigThingAnnotation: MKPointAnnotation {
    var bigThing: BigThing?
}
