//
//  PermissionRequester.swift
//  RideSharer
//
//  Created by ahdivio mendes on 06/08/23.
//

import Foundation
import CoreLocation
import MapKit

protocol PermissionRequester {
  func request()
}

final class LocationPermisionRequester: NSObject, PermissionRequester {
  private var clLocationManager: CLLocationManager?
  private var locationRequesthandler: LocationRequesthandler?
  private var fetchMapView: MapViewController?
  
  init(fetcher: any FetchAnyItemFromView) {
    super.init()
    clLocationManager = CLLocationManager()
    locationRequesthandler = LocationRequesthandler()
    fetchMapView = fetcher as? MapViewController;
    //sets the delegate to self therby triggering some events
    clLocationManager?.delegate = self
    trackUserLocation()
  }
  
  final func request() {
    checkLocationService()
  }
  
  
  final func trackUserLocation() {
    clLocationManager?.startUpdatingLocation()
  }
  
  
  final private func checkLocationService() {
    DispatchQueue.global().async {[weak self] in
      let mapView = self?.fetchMapView?.getAnything()
      
      let actionForAlert = ActionForAlert().prepareAlertAction(Titile: "OK", actionStyle: .default) {
        //open settings
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
          UIApplication.shared.open(settingsUrl)
        }
      }
      
      let failourHandler = FailourHandler(alertActions: [actionForAlert], vc: (self?.fetchMapView)!)
      
      
      if CLLocationManager.locationServicesEnabled()  {
        
        
        //TODO: do check on what type of location acess is there
        
       
        
        let sucessHandler  = SuccessTaskHandler(mapView: mapView as? MKMapView);
        
        let noActionTaken = RequestActionFromUser(locationManager: (self?.clLocationManager)! , mapView: mapView as? MKMapView)
        
        self?.locationRequesthandler?.actOnResponse(perfromedAction: CLLocationManager.authorizationStatus(), onSuccess: sucessHandler.handleSomeUserResponseEvent, onFailer: failourHandler.handleSomeUserResponseEvent, onNoAction: noActionTaken.request)
        
        
        return
      }
      
      
      //TODO: notify the user that the location service isnt enabled
      failourHandler.handleSomeUserResponseEvent()
      print("failed location + 1")
      
    }
  }
   
}



extension LocationPermisionRequester: CLLocationManagerDelegate {
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    request()
  }
  
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let userLocation = locations.last?.coordinate else {
      return
    }
    
    // Update the map's center to the user's location
    let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
    let mapView = self.fetchMapView?.getAnything() as? MKMapView
    mapView?.setRegion(region, animated: true)
  }
}


