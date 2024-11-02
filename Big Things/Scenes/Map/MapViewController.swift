//
//# Author:    Tran Ngoc Thien Kim
//# Email Id:   TRANY057
//# Description:  Big Things, IOS assignment 2
//# This is my own work as defined by the University's Academic Misconduct policy.

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
    }

    private func setupMapView() {
        mapView.mapType = .standard
        
        let initialLocation = CLLocationCoordinate2D(latitude: -34.94376663282724, longitude: 138.59041355664925)
        let region = MKCoordinateRegion(center: initialLocation, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(region, animated: true)

        // Add a marker at the initial location
        let annotation = MKPointAnnotation()
        annotation.coordinate = initialLocation
        annotation.title = "Your location"
        mapView.addAnnotation(annotation)
        
        mapView.showsUserLocation = true
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }
}
