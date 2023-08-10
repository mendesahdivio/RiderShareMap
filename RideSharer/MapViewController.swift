//
//  MapViewController.swift
//  RideSharer
//
//

import UIKit
import MapKit

protocol FetchAnyItemFromView {
  associatedtype AnyItem
  func getAnything() -> AnyItem
}

class MapViewController: UIViewController, MKMapViewDelegate {
  //map view outlet
  @IBOutlet weak var mapView: MKMapView!
  var locationAccess: LocationPermisionRequester?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setDelgate()
    fetchLocation()
  }
  
}


extension MapViewController {
  func fetchLocation() {
    locationAccess = LocationPermisionRequester(fetcher: self)
  //  locationAccess?.request()
  }
  
  final func setDelgate() {
    mapView.delegate = self
  }
}





//delegate
extension MapViewController: FetchAnyItemFromView {
  
  typealias AnyItem = UIView
  
  
  func getAnything() -> UIView {
    return self.mapView;
  }
  
  
}
