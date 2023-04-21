//
//  WeatherExtensions.swift
//  MGWeather
//
//  Created by Michael Ghevondyan on 19.04.23.
//

import MapKit

extension WeatherVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let routePolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routePolyline)
            renderer.strokeColor = #colorLiteral(red: 0.07058823529, green: 0.137254902, blue: 0.168627451, alpha: 1)
            renderer.lineWidth = 7
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    func mapDur(lat: Double, lng: Double) {
        let restaurantLocation = CLLocationCoordinate2D(latitude: lat, longitude: lng)

              //Center the map on the place location
              mapView.setCenter(restaurantLocation, animated: true)
//        let userCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
//        let mapCamera = MKMapCamera(lookingAtCenter: userCoordinate, fromEyeCoordinate: eyeCoordinate, eyeAltitude: 200.0)
//        let mapCamera1 = MKMapCamera(lookingAtCenter: eyeCoordinate, fromEyeCoordinate: userCoordinate, eyeAltitude: 200.0)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = userCoordinate
//           // self.mapView.addAnnotation(annotation)
//            self.mapView.setCamera(mapCamera, animated: false)
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = userCoordinate
//            self.mapView.addAnnotation(annotation)
//            self.mapView.setCamera(mapCamera, animated: true)
//        }
    }
}


