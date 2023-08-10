//
//  Permissionhandler.swift
//  RideSharer
//
//  Created by ahdivio mendes on 06/08/23.
//

import Foundation
import CoreLocation
protocol handlePermission {
  associatedtype response
  associatedtype actionTobeTaken
  func actOnResponse(perfromedAction: response, onSuccess: actionTobeTaken, onFailer: actionTobeTaken, onNoAction: actionTobeTaken)
}



class LocationRequesthandler: handlePermission {
  typealias actionTobeTaken = () -> ()
  
  typealias response = CLAuthorizationStatus
  
  func actOnResponse(perfromedAction: response, onSuccess: actionTobeTaken, onFailer: actionTobeTaken, onNoAction: actionTobeTaken) {
    switch perfromedAction {
    case .notDetermined:
      onNoAction()
    case .restricted:
      onFailer()
    case .denied:
      onFailer()
      print("failed event")
    case .authorizedAlways:
      onSuccess()
      break;
    case .authorizedWhenInUse:
      onSuccess()
      break;
    case .authorized:
      onSuccess()
      break;
    @unknown default:
      print("undefined case")
    }
  }
  
  
}
