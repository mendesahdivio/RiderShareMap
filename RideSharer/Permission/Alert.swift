//
//  AlertController.swift
//  RideSharer
//
//  Created by ahdivio mendes on 06/08/23.
//
import UIKit
import Foundation

enum AlertMessage: String{
  case failedLocation = "Kindly go to setting > Privacy & Security > Location Services > Search For RiderShare > Enable Location"
}

protocol AlertAction {
  associatedtype someTypeOfActions
  func setAlertActions(actions: [someTypeOfActions]?)
}

protocol AlertBehaviour {
  associatedtype T
  associatedtype anyController
  func showAlert(vc: anyController)
  func dismissAlert()
  func prepareAlert(title: T, message: T?)
}


class FailourAlert:  AlertBehaviour, AlertAction {
  
  typealias someTypeOfActions = UIAlertAction
  typealias anyController = UIViewController
  typealias T = String
  
  private var internalAlert: UIAlertController?
  private var actions: [UIAlertAction]?
  
  
  init(title: T, message: T, actions: [UIAlertAction]) {
    self.prepareAlert(title: title, message: message)
    self.setAlertActions(actions: actions)
    self.applyActions()
  }
  
  
  
  deinit {
    internalAlert = nil
    actions = nil
  }
  
  func showAlert(vc: anyController) {
    guard let alertVC = internalAlert else {
      print("something went wrong")
      return
    }
    DispatchQueue.main.async {
      vc.present(alertVC, animated: true)
    }
  }
  
  func dismissAlert() {
    internalAlert?.dismiss(animated: true)
  }
  
  func prepareAlert(title: String, message: String?) {
    internalAlert = UIAlertController(title: title, message: AlertMessage.failedLocation.rawValue + (message ?? ""), preferredStyle: .alert)
  }
  
  func setAlertActions(actions: [UIAlertAction]?) {
    self.actions = actions
  }
  
  
  final private func applyActions() {
    guard let actions = (self.actions != nil) ? self.actions : [UIAlertAction(title: "OK", style: .cancel)] else {
      return
    }
    for action in actions {
      self.internalAlert?.addAction(action)
    }
  }
}


struct ActionForAlert {
  func prepareAlertAction(Titile: String, actionStyle: UIAlertAction.Style?, someTask:@escaping ()->()?) -> UIAlertAction {
    UIAlertAction(title: Titile, style: actionStyle!){action in
      someTask();
    }
  }
}
