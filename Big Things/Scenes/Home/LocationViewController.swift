//
//# Author:    Tran Ngoc Thien Kim
//# Email Id:   TRANY057
//# Description:  Big Things, IOS assignment 2
//# This is my own work as defined by the University's Academic Misconduct policy.

import UIKit
import MapKit

class LocationViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var bigThing: BigThing?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
    }
    
    // get location of bigthing and show it on map
    private func setupMapView() {
        mapView.mapType = .standard
        
        guard let bigThing = bigThing else { return }
        
        let initialLocation = CLLocationCoordinate2D(latitude: Double(bigThing.latitude) ?? 0.0, longitude: Double(bigThing.longitude) ?? 0.0)
        let region = MKCoordinateRegion(center: initialLocation, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = initialLocation
        annotation.title = bigThing.name
        annotation.subtitle = bigThing.location
        mapView.addAnnotation(annotation)
        
        mapView.showsUserLocation = true
    }
}
