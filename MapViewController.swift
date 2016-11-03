//
//  MapViewController.swift
//  FinalFiftyFeetProject
//
//  Created by Haena Kim on 10/16/16.
//  Copyright © 2016 Haena Kim. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol MapViewControllerDelegate {
    
    func didFinishViewController(
        viewController:MapViewController, didSave:Bool)
    
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate,SecondViewControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!

    let locationManager = CLLocationManager()
    var updatelocation :Location?
    
      var delegate:MapViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updatelocation = Location()

        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true
        // Do any additional setup after loading the view.
    }

    @IBAction func cancelAction(sender: AnyObject) {
//        delegate?.didFinishViewController(self, didSave: false)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    @IBAction func saveAction(sender: AnyObject) {
        
        WorkList.sharedInstance.currentlocationWorkList = updatelocation
        dismissViewControllerAnimated(true, completion: nil)
    }


//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//            if segue.identifier == "mapSaveAction"{
//                
//                let workEntry = fetchedResultController.objectAtIndexPath(indexPath!) as! Work
//                
//                //3
//                let navigationController = segue.destinationViewController as! UINavigationController
//                let detailViewController = navigationController.topViewController as! SecondViewController
//                
//                //4
//                detailViewController.workEntry = workEntry
//                detailViewController.context = workEntry.managedObjectContext!
//                detailViewController.delegate = self
//                
//
//        
//        let secondViewController2: SecondViewController = segue.destinationViewController as! SecondViewController
//       
//        secondViewController2.delegate = self
//        
//        let tempLong = secondViewController2.currentLocation!.longitude
//        let tempLat = secondViewController2.currentLocation!.latitude
//        secondViewController2.longLabel.text = "\(tempLong!)"
//        secondViewController2.latLabel.text = "\(tempLat!)"
//        
//        secondViewController2
//        
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude:location!.coordinate.longitude)
        
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        
        self.mapView.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
        
        self.updatelocation!.longitude = location!.coordinate.longitude
        self.updatelocation!.latitude = location!.coordinate.latitude
    
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors: " + error.localizedDescription)
    }
    
    func didFinishViewController(viewController:SecondViewController, didSave:Bool){
    
    }

}
