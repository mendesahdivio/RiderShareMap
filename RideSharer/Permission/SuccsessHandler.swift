//
//  SuccsessHandler.swift
//  RideSharer
//
//  Created by ahdivio mendes on 06/08/23.
//

import Foundation
import MapKit


protocol HandleEvent  {
  func handleSomeUserResponseEvent()
}


struct mapViewAccessuserLocation {
  private var mapView: MKMapView?
  
  init(mapView: MKMapView? = nil) {
    self.mapView = mapView
  }
  
  func enableUserLocation() {
    DispatchQueue.main.async {
      mapView?.showsUserLocation = true
    }
  }
}


//MARK: - ON suceess we set the map view to show user location
struct SuccessTaskHandler: HandleEvent {
  private var mapView: MKMapView?
  
  init(mapView: MKMapView? = nil) {
    self.mapView = mapView
  }
  
  func handleSomeUserResponseEvent() {
    mapViewAccessuserLocation(mapView: mapView).enableUserLocation()
    
  }
  
}



struct RequestActionFromUser: PermissionRequester  {
 private var locationManager: CLLocationManager?
 private var mapView: MKMapView?
  
  init(locationManager: CLLocationManager? = nil, mapView: MKMapView? = nil) {
    self.locationManager = locationManager
    self.mapView = mapView
  }
  
  func request() {
    locationManager?.requestWhenInUseAuthorization()
    mapViewAccessuserLocation(mapView: mapView).enableUserLocation()
  }
}








//--------------------------------------------------------------------------------------------------------------------------------

//MARK: - failour handler

//--------------------------------------------------------------------------------------------------------------------------------


struct FailourHandler: HandleEvent {
  
  private var alertActions: [UIAlertAction]
  private var presentingViewController: UIViewController?
  
  
  init(alertActions: [UIAlertAction]? = nil, vc: UIViewController) {
    self.alertActions = alertActions ?? [];
    self.presentingViewController = vc;
  }
  
  
  
  func handleSomeUserResponseEvent() {
    let alert = FailourAlert(title: "Location Access Failed", message: "", actions: alertActions)
    guard presentingViewController != nil else {
      
      return
    }
    alert.showAlert(vc: presentingViewController!)
  }
}
