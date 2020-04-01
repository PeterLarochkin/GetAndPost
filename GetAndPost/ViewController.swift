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



class ViewController: UIViewController, CLLocationManagerDelegate {
    
    private var wheatherConditionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .italicSystemFont(ofSize: 17)
        
        label.numberOfLines = 3
        return label
    }()
    
    
    private var wheatherCondition: String = ""
    private var locationManager = CLLocationManager()
    private var cityName: String = ""
    private var date: String = ""
    private var temp: String = ""
    private var lat: String = ""
    private var lon: String = ""
    
    
    private var buttonGet: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.addTarget(self, action: #selector(tappedGet), for: .touchUpInside)
        button.setTitle("Get", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
    
        return button
    }()
    
    
    private var buttonPost: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(tappedPost), for: .touchUpInside)
        button.setTitle("Post", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func configureButtons(){
        NSLayoutConstraint.activate([
            buttonGet.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant:  -16.0),
            buttonGet.widthAnchor.constraint(equalTo: wheatherConditionLabel.widthAnchor),
            buttonGet.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant:  0.0),
            
            
//            buttonPost.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -UIScreen.main.bounds.width / 5),
//            buttonPost.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 4),
//            buttonPost.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor,constant:  0.0)
            
        ])
    }
    
    private func configureLabel(){
        NSLayoutConstraint.activate([
            wheatherConditionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            wheatherConditionLabel.bottomAnchor.constraint(equalTo: buttonGet.topAnchor, constant: -16.0),
            wheatherConditionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            wheatherConditionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0)
        ])
        
    }
    
    private func addButtons(){
        //view.addSubview(buttonPost)
        view.addSubview(buttonGet)
    }
    
    private func addLabel(){
        view.addSubview(wheatherConditionLabel)
    }
    
    
    func getData(coordinates: (String,String)){
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
                print("Response data string:\n \(dataString)")
                self.wheatherCondition = dataString
                let json = JSON(data)
                print("_______")
                print(json["now"].intValue)
                print(data.self)
                print("_______")
                print("Где?")
                //self.cityName = json["info"]["tzinfo"]["name"].stringValue
                print(self.cityName)
                print("Когда?")
                self.date = json["now_dt"].stringValue
                print(self.date)
                print("Сколько градусов?")
                self.temp = json["fact"]["temp"].stringValue
                print(self.temp)
            }
            DispatchQueue.main.async {
                
                self.wheatherConditionLabel.text  = "ГДЕ? : \(self.cityName)" + "\n КОГДА? : \(self.date)" + "\n СКОЛЬКО ГРАДУСОВ? : \(self.temp)"
            }
        }
        task.resume()
        
    }
    
    
    @objc func tappedGet() {
        
        getData(coordinates: self.getLocale())
        
        
    }
    
    private func getLocale()->(String,String){
        print("______")
        return (lat, lon)
        
    }
    
    // MARK: didn't use
    @objc func tappedPost() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {return}
        let parametres = ["username": "ivan", "message": "Hello, Steve!"]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parametres, options: []) else { return }
        request.httpBody = httpBody
        
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            print(url)
            if let response = response {
                print(response)
            }
            guard let data = data else { return }
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            }catch{
                print(error)
            }
        }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButtons()
        addLabel()
        configureButtons()
        configureLabel()
        
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        wheatherConditionLabel.text = "hello, friend!"
        
        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        lat = "\(locValue.latitude)"
        lon = "\(locValue.longitude)"
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: locValue.latitude, longitude:  locValue.longitude) // <- New York

        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, _) -> Void in

            placemarks?.forEach { (placemark) in

                if let city = placemark.locality {
                    print(city)
                    self.cityName = city
                    
                } // Prints "New York"
            }
        })
    }
}

