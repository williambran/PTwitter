//
//  MapViewViewController.swift
//  PlatziTweets
//
//  Created by mac1 on 30/10/20.
//  Copyright © 2020 mac1. All rights reserved.
//

import UIKit
import MapKit

class MapViewViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var mapContainer: UIView!
    
    // MARK: -  Properties
     var post =  [Post]()     //todos los post que tiene que representar en el mapa
    private var map: MKMapView?       //  el mero map
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("cantidad de post wito: ", post )
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupMap()
    }
    
    private func setupMap(){
        map = MKMapView(frame: mapContainer.bounds)    // se inicializa el mapa
        mapContainer.addSubview(map ?? UIView())
        setupMarkers()
    }
    
    private func setupMarkers() {
        post.forEach { item in
            let marker = MKPointAnnotation()
            marker.coordinate = CLLocationCoordinate2D(latitude: item.location.latitude,
                                                       longitude: item.location.longitude)
            
            marker.title = item.text
            marker.subtitle =  item.author.names
            
            map?.addAnnotation(marker)    // le ponemos las anotaciones al mapa
        }
        //Buscamos el ultimo posts del arreglo
        guard let lastPost = post.last else {
            return
        }
        
        let lastPostLocation = CLLocationCoordinate2D(latitude: lastPost.location.latitude,
                                                      longitude: lastPost.location.longitude)
        guard let heading = CLLocationDirection(exactly: 12) else {
            return
        }
        map?.camera = MKMapCamera(lookingAtCenter: lastPostLocation, fromDistance: 800000, pitch: .zero, heading: heading)
    }

}
