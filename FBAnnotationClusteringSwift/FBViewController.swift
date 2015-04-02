//
//  ViewController.swift
//  FBAnnotationClusteringSwift
//
//  Created by Robert Chen on 4/2/15.
//  Copyright (c) 2015 Robert Chen. All rights reserved.
//

import UIKit
import MapKit

class FBViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let numberOfLocations = 1000
    
    let clusteringManager = FBClusteringManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var array:[MKAnnotation] = randomLocationsWithCount(numberOfLocations)
        
        clusteringManager.addAnnotations(array)
        clusteringManager.delegate = self;

        mapView.centerCoordinate = CLLocationCoordinate2DMake(0, 0);
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Utility
    
    func randomLocationsWithCount(count:Int) -> [FBAnnotation] {
        var array:[FBAnnotation] = []
        for i in 0...count {
            let a:FBAnnotation = FBAnnotation()
            a.coordinate = CLLocationCoordinate2D(latitude: drand48() * 40 - 20, longitude: drand48() * 80 - 40 )
            array.append(a)
        }
        return array
    }

}

extension FBViewController : FBClusteringManagerDelegate {
 
    func cellSizeFactorForCoordinator(coordinator:FBClusteringManager) -> CGFloat{
        return 1.0
    }
    
}


extension FBViewController : MKMapViewDelegate {
    
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool){
        
        dispatch_async(dispatch_get_main_queue()) {
        
            let annotationArray = self.clusteringManager.clusteredAnnotationsWithinMapRect(self.mapView.visibleMapRect, withZoomScale:1.0)
            
            self.clusteringManager.displayAnnotations(annotationArray, onMapView:self.mapView)

        }

    }
    
}
