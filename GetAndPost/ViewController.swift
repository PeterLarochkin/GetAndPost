//
//  ViewController.swift
//  GetAndPost
//
//  Created by Петр Ларочкин on 31.03.2020.
//  Copyright © 2020 Петр Ларочкин. All rights reserved.
//

import UIKit
import SwiftyJSON
import MapKit
import CoreLocation



class ViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    
    private var json = JSON()
    private var wheatherCondition: String = ""
    private var locationManager = CLLocationManager()
    private var cityName: String = ""
    private var date: String = ""
    private var temp: String = ""
    private var lat: CLLocationDegrees = 0
    private var lon: CLLocationDegrees = 0
    
    private var mapView: MKMapView = {
        let map = MKMapView()
        //map.translatesAutoresizingMaskIntoConstraints = false
        
        return map
    }()
    private func configureMap(){
        //        NSLayoutConstraint.activate([
        //            mapView.widthAnchor.constraint(equalTo: wheatherConditionLabel.widthAnchor),
        //            mapView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        //            mapView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        //            mapView.heightAnchor.constraint(equalToConstant: 2 / 3 * UIScreen.main.bounds.height)
        //        ])
        mapView.frame = CGRect(x: 0, y: 1 / 7 * UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 5 / 7 * UIScreen.main.bounds.height)
    }
    
    private var wheatherConditionLabel: UILabel = {
        let label = UILabel()
        //        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .italicSystemFont(ofSize: 17)
        label.numberOfLines = 11
        label.text = "Узнать погоду в любой точке планеты :)"
        return label
    }()
    
    private func configureLabel(){
        //        NSLayoutConstraint.activate([
        //            wheatherConditionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
        //            wheatherConditionLabel.bottomAnchor.constraint(equalTo: mapView.topAnchor, constant: -16.0),
        //            wheatherConditionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
        //            wheatherConditionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0)
        //        ])
        wheatherConditionLabel.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1 / 7 * UIScreen.main.bounds.height)
    }
    
    private var buttonGet: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.addTarget(self, action: #selector(tappedGetFullInformation), for: .touchUpInside)
        button.setTitle("Развернуть", for: .normal)
        //        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        return button
    }()
    
    private func configureButtonGet(){
        //        NSLayoutConstraint.activate([
        //            buttonGet.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant:  -16.0),
        //            buttonGet.widthAnchor.constraint(equalTo: wheatherConditionLabel.widthAnchor),
        //            buttonGet.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant:  0.0),
        //            //buttonGet.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 16.0)
        //            buttonGet.heightAnchor.constraint(equalToConstant: 31.0)
        //        ])
        buttonGet.frame = CGRect(x: UIScreen.main.bounds.width / 2, y: 6 / 7 * UIScreen.main.bounds.height, width: UIScreen.main.bounds.width / 2, height: 1 / 7 * UIScreen.main.bounds.height)
    }
    
    
    private var buttonWhereI: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(tappedWhereI), for: .touchUpInside)
        button.setTitle("Где Я?", for: .normal)
        //        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func configureButtonWhereI(){
        //        NSLayoutConstraint.activate([
        //            buttonGet.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant:  -16.0),
        //            buttonGet.widthAnchor.constraint(equalTo: wheatherConditionLabel.widthAnchor),
        //            buttonGet.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant:  0.0),
        //            //buttonGet.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 16.0)
        //            buttonGet.heightAnchor.constraint(equalToConstant: 31.0)
        //        ])
        buttonWhereI.frame = CGRect(x: 0, y: 6 / 7 * UIScreen.main.bounds.height, width: UIScreen.main.bounds.width / 2, height: 1 / 7 * UIScreen.main.bounds.height)
    }
    
    private func addButton(){
        //view.addSubview(buttonPost)
        view.addSubview(buttonGet)
        view.addSubview(buttonWhereI)
    }
    
    private func addLabel(){
        view.addSubview(wheatherConditionLabel)
    }
    
    private func addMap(){
        view.addSubview(mapView)
    }
    
    
    func setDataOnLabel(coordinates: (CLLocationDegrees, CLLocationDegrees)){
        // Create URL
        let url = URL(string: "https://api.weather.yandex.ru/v1/forecast?lat="+"\(coordinates.0)&lon="+"\(coordinates.1)&extra=false")
        guard let requestUrl = url else { fatalError() }
        
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        // Set HTTP Request Header
        request.setValue(" ccdf8270-ce4b-4c80-822c-95eca10a2a6e", forHTTPHeaderField: "X-Yandex-API-Key")
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            
            // Convert HTTP Response Data to a simple String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                //print("Response data string:\n \(dataString)")
                self.wheatherCondition = dataString
                self.json = JSON(data)
                print("_______")
                print(self.json["now"].intValue)
                //print(data.self)
                print("_______")
                print("Где?")
                //self.cityName = json["info"]["tzinfo"]["name"].stringValue
                print(self.cityName)
                print("Когда?")
                self.date = self.json["now_dt"].stringValue
                print(self.date)
                print("Сколько градусов?")
                self.temp = self.json["fact"]["temp"].stringValue
                print(self.temp)
            }
            DispatchQueue.main.async {
                
                self.wheatherConditionLabel.text  = "Город: \(self.cityName)" + "\nВремя: \(self.date)" + "\nТемпература: \(self.temp)"
                //                print(self.wheatherCondition)
            }
        }
        task.resume()
        
    }
    
    var status = true
    
    
    @objc func tappedGetFullInformation() {
        
        status = !status
        if status {
            UIView.animate(withDuration: 0.3, animations: {
                
                self.mapView.frame = CGRect(x: UIScreen.main.bounds.width, y: 1 / 7 * UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 5 / 7 * UIScreen.main.bounds.height)
                self.wheatherConditionLabel.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 6 / 7 * UIScreen.main.bounds.height)
                self.buttonWhereI.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width / 2, height: 1 / 7 * UIScreen.main.bounds.height)
                self.buttonGet.frame = CGRect(x: 0, y: 6 / 7 * UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 1 / 7 * UIScreen.main.bounds.height)
                
                
                
                let condition = self.json["fact"]["condition"].stringValue
                let windSpeed = self.json["fact"]["wind_speed"].stringValue
                let pressure = self.json["fact"]["pressure_mm"].stringValue
                let nightTemp = self.json["forecasts"].arrayValue[0]["parts"]["night"]["temp_avg"].stringValue
                let morningTemp = self.json["forecasts"].arrayValue[0]["parts"]["morning"]["temp_avg"].stringValue
                let dayTemp = self.json["forecasts"].arrayValue[0]["parts"]["day"]["temp_avg"].stringValue
                let eveningTemp = self.json["forecasts"].arrayValue[0]["parts"]["evening"]["temp_avg"].stringValue
                
                self.wheatherConditionLabel.text = self.wheatherConditionLabel.text! + "\n Состояние: " + condition +
                    "\n Скорость ветра(в м/с):  " + windSpeed + "\n Давление(в мм):  " + pressure + "\n Прогноз:" + "\n Ночью: " + nightTemp + "\n Утром: " + morningTemp +
                    "\n Днем: " + dayTemp + "\n Вечером: " + eveningTemp
                print(self.wheatherConditionLabel.text!)
                self.buttonGet.setTitle("Свернуть", for: .normal)
                self.view.layoutIfNeeded()
            })
            
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.mapView.frame = CGRect(x: 0, y: 1 / 7 * UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 5 / 7 * UIScreen.main.bounds.height)
                self.wheatherConditionLabel.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width , height: 1 / 7 * UIScreen.main.bounds.height)
                self.buttonWhereI.frame = CGRect(x: 0, y: 6 / 7 * UIScreen.main.bounds.height, width: UIScreen.main.bounds.width / 2, height: 1 / 7 * UIScreen.main.bounds.height)
                self.buttonGet.frame = CGRect(x: UIScreen.main.bounds.width / 2, y: 6 / 7 * UIScreen.main.bounds.height, width: UIScreen.main.bounds.width / 2, height: 1 / 7 * UIScreen.main.bounds.height)
                self.wheatherConditionLabel.text = "Город : \(self.cityName)" + "\n Время : \(self.date)" + "\n Температура : \(self.temp)"
                self.buttonGet.setTitle("Развернуть", for: .normal)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    
    
    
    private func getLocale(coord: (CLLocationDegrees,CLLocationDegrees)){
        print("______")
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: coord.0, longitude: coord.1)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, _) -> Void in
            
            placemarks?.forEach { (placemark) in
                
                if let city = placemark.locality {
                    print(city)
                    self.cityName = "\(city)"
                    
                }else{
                    self.cityName = "?"
                } // Prints "New York"
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton()
        addLabel()
        addMap()
        
        configureButtonGet()
        configureLabel()
        configureMap()
        configureButtonWhereI()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    @objc func tappedWhereI(){
        if locationManager.accessibilityActivate(){
        let center = CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
        getLocale(coord: (locationManager.location!.coordinate.latitude, locationManager.location!.coordinate.longitude))
        setDataOnLabel(coordinates: (locationManager.location!.coordinate.latitude, locationManager.location!.coordinate.longitude))
            self.buttonGet.isEnabled = true}
    }
    
    
    @objc
    func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
        
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        // Add annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        lat = coordinate.latitude
        lon = coordinate.longitude
        getLocale(coord: (lat, lon))
        setDataOnLabel(coordinates: (lat, lon))
        buttonGet.isEnabled = true
        
        
    }
}

