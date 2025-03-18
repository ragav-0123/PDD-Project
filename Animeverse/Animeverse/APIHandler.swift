//
//  APIHandler.swift
//  Animeverse
//
//  Created by SAIL on 19/02/25.
//


import Foundation
import UIKit


class APIHandler {
    static var shared: APIHandler = APIHandler()
    
    init() {}
    
    func getAPIValues<T:Codable>(type: T.Type, apiUrl: String, method: String, onCompletion: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = URL(string: apiUrl) else {
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            onCompletion(.failure(error))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        print("URL --------> \(url)")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                onCompletion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "No data received", code: 1, userInfo: nil)
                onCompletion(.failure(error))
                return
            }
            print("=====\(String(data: data, encoding: .utf8))")
            do {
                let decodedData = try JSONDecoder().decode(type, from: data)
                onCompletion(.success(decodedData))
                print(decodedData)
            } catch {
                onCompletion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func postAPIValues<T: Codable>(
        type: T.Type,
        apiUrl: String,
        method: String,
        formData: [String: Any], // Dictionary for form data parameters
        onCompletion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: apiUrl) else {
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            onCompletion(.failure(error))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
       
        // Construct the form data string
        var formDataString = ""
        for (key, value) in formData {
            formDataString += "\(key)=\(value)&"
        }
        formDataString = String(formDataString.dropLast())
        
        request.httpBody = formDataString.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        print("URL --------> \(url)")
        print("FormData --------> \(formData)")

        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                onCompletion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "No data received", code: 1, userInfo: nil)
                onCompletion(.failure(error))
                return
            }
            print("=====API Response", String(data: data, encoding: .utf8))
            do {
                let decodedData = try JSONDecoder().decode(type, from: data)
                onCompletion(.success(decodedData))
                print(decodedData)
            } catch {
                onCompletion(.failure(error))
            }
        }
        
        task.resume()
    }
    


    func postAPIValuesWithPDF<T: Codable>(
        type: T.Type,
        apiUrl: String,
        method: String = "POST",
        formData: [String: Any], // Dictionary containing both text and file data
        onCompletion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: apiUrl) else {
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            onCompletion(.failure(error))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Append form data parameters
        for (key, value) in formData {
            if let fileUrl = value as? URL { // Check if value is a file URL
                let fileName = fileUrl.lastPathComponent
                let mimeType = "application/pdf"
                
                if let fileData = try? Data(contentsOf: fileUrl) {
                    body.append("--\(boundary)\r\n".data(using: .utf8)!)
                    body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
                    body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
                    body.append(fileData)
                    body.append("\r\n".data(using: .utf8)!)
                }
            } else { // Normal form field
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                body.append("\(value)\r\n".data(using: .utf8)!)
            }
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                onCompletion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "No data received", code: 1, userInfo: nil)
                onCompletion(.failure(error))
                return
            }
            
            print("=====API Response", String(data: data, encoding: .utf8) ?? "No Response")
            
            do {
                let decodedData = try JSONDecoder().decode(type, from: data)
                onCompletion(.success(decodedData))
            } catch {
                onCompletion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        // Use URLSession to download the image asynchronously
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Check if the data is not nil and there were no errors
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    // Create a UIImage from the data
                    let image = UIImage(data: data)
                    completion(image)
                }
            } else {
                // In case of an error, return nil
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
    
    
    func postAPIValuesWithFormData<T: Codable>(
        type: T.Type,
        apiUrl: String,
        method: String,
        formData: [String: Any], // Dictionary for form data parameters
        onCompletion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: apiUrl) else {
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            onCompletion(.failure(error))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.uppercased()
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        for (key, value) in formData {
            if let fileData = value as? Data, key == "profilePic" {
                // Generate a unique filename using timestamp
                let timestamp = Int(Date().timeIntervalSince1970)
                let filename = "profile_\(timestamp).jpg"
                let mimeType = "image/jpeg"
                
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
                body.append(fileData)
                body.append("\r\n".data(using: .utf8)!)
            } else if let stringValue = value as? String {
                // Append normal form fields
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                body.append("\(stringValue)\r\n".data(using: .utf8)!)
            }
        }

        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        print("URL --------> \(url)")
        print("FormData --------> \(formData)")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                onCompletion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "No data received", code: 1, userInfo: nil)
                onCompletion(.failure(error))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(type, from: data)
                onCompletion(.success(decodedData))
                print(decodedData)
            } catch {
                onCompletion(.failure(error))
            }
        }
        
        task.resume()
    }
}


extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
