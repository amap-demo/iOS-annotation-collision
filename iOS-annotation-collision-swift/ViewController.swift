//
//  ViewController.swift
//  iOS-annotation-collision-swift
//
//  Created by hanxiaoming on 2017/5/10.
//  Copyright © 2017年 Amap. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MAMapViewDelegate {
    
    var mapView : MAMapView!
    var collisionAnnotations : Array<MyTextAnnotation> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView = MAMapView.init(frame: self.view.bounds)
        self.mapView.delegate = self
        self.mapView.allowsAnnotationViewSorting = false
        self.view.addSubview(self.mapView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initAnnotations() {
        let coordinates : [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 39.992520, longitude: 116.336170),
            CLLocationCoordinate2D(latitude: 39.998293, longitude: 116.352343),
            CLLocationCoordinate2D(latitude: 40.004087, longitude: 116.348904),
            CLLocationCoordinate2D(latitude: 40.001442, longitude: 116.353915),
            CLLocationCoordinate2D(latitude: 39.989098, longitude: 116.360200),
            CLLocationCoordinate2D(latitude: 39.998439, longitude: 116.360201),
            CLLocationCoordinate2D(latitude: 39.979590, longitude: 116.324219),
            CLLocationCoordinate2D(latitude: 39.992520, longitude: 116.352792),
            CLLocationCoordinate2D(latitude: 39.978234, longitude: 116.336170)]
        
        var arr: Array<MyTextAnnotation> = []
        var idx = 0
        for coor in coordinates {
            let a = MyTextAnnotation()
            a.coordinate = coor
            a.title = String(format: "hellohellohello anno :%d", arguments: [idx])
            a.rank = Int(arc4random()) % 6;
            arr.append(a)
            
            idx = idx + 1
        }
        
        arr[0].title = "爱上打算的爱上打算的爱上打算的爱上打算的爱上打算的爱上打算的"
        arr[1].title = "卡卡"
        
        
        self.collisionAnnotations = arr.sorted(by: { (obj1, obj2) -> Bool in
            return obj1.rank < obj2.rank
        })
        
        self.mapView.addAnnotations(self.collisionAnnotations)
        self.mapView.showAnnotations(self.collisionAnnotations, edgePadding: UIEdgeInsetsMake(50, 100, 100, 100), animated: true)
    }
    
    //MARK: - MAMapViewDelegate
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if (annotation.isKind(of: MAPointAnnotation.self))
        {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: MyTextAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as? MyTextAnnotationView
            if (annotationView == nil)
            {
                annotationView =  MyTextAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
                annotationView?.image =  UIImage(named: "marker_blue")
            }
            
            annotationView?.canShowCallout = true
            
            return annotationView;
        }
        
        return nil;
    }
    
    func mapInitComplete(_ mapView: MAMapView!) {
        initAnnotations()
    }
    
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        print("onClick-\(String(describing: view.annotation.title))")
    }
    
    func mapView(_ mapView: MAMapView!, regionDidChangeAnimated animated: Bool) {
        processingCollisionDetection()
    }
    
    //MARK: - 碰撞检测
    func processingCollisionDetection() {
        var showedAnnos: [MyTextAnnotation] = []
        
        for myAnno1 in self.collisionAnnotations {
            let myView1: MyTextAnnotationView? = self.mapView.view(for: myAnno1) as? MyTextAnnotationView
            
            if myView1 == nil {
                continue
            }
            
            var isRightCollision = false
            var isLeftCollision = false
            
            for myAnno2 in showedAnnos {
                if isRightCollision && isLeftCollision {
                    break
                }
                
                let myView2: MyTextAnnotationView? = self.mapView.view(for: myAnno2) as? MyTextAnnotationView
                
                assert(myView2 != nil)
                
                if !isRightCollision {
                    if myView1!.rightRect().intersects(myView2!.showedRect()) {
                        isRightCollision = true
                    }
                }
                
                if !isLeftCollision {
                    if myView1!.leftRect().intersects(myView2!.showedRect()) {
                        isLeftCollision = true
                    }
                }
            } //end for showedAnnos
            
            if !isRightCollision {
                myView1!.direction = MyTextAnnotationViewDirection.right
                showedAnnos.append(myAnno1)
            }
            else if !isLeftCollision {
                myView1!.direction = MyTextAnnotationViewDirection.left
                showedAnnos.append(myAnno1)
            }
            else {
                myView1!.direction = .none
            }
        }
        
    }

}


