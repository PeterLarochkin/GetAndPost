//
//  ViewController.swift
//  GetAndPost
//
//  Created by Петр Ларочкин on 31.03.2020.
//  Copyright © 2020 Петр Ларочкин. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var buttonGet: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
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
            buttonGet.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor,constant:  0.0),
            buttonPost.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor,constant:  0.0),
            buttonPost.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 4),
            buttonGet.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 4),
            buttonGet.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant:  UIScreen.main.bounds.width / 5),
            buttonPost.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -UIScreen.main.bounds.width / 5)
        ])
    }
    
    private func addButtons(){
        view.addSubview(buttonPost)
        view.addSubview(buttonGet)
    }
    
    
    
    
    
    
    @objc func tappedGet() {
        // Create URL
        let url = URL(string: "https://api.weather.yandex.ru/v1/forecast?lat=55.75396&lon=37.620393&extra=true")
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
            }
            
        }
        task.resume()
        
    }
    
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
        configureButtons()
        
        // Do any additional setup after loading the view.
    }
}

