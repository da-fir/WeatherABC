//
//  NetworkManager.swift
//  SandboxApp
//
//  Created by Darul Firmansyah on 28/06/24.
//

import Combine
import Foundation
import CoreLocation

public enum APIError: Error, Codable {
    case invalidURL
    case requestFailed(String)
    case decodingFailed
}

public enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public enum Endpoint {
    case weather(CLLocation)
    
    var path: String {
        switch self {
        case .weather:
            return "/weather"
        }
    }
    
    var httpMethod: HttpMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var parameters: [String: String] {
        switch self {
        case .weather(let cLLocation):
            return [
                "lat": cLLocation.coordinate.latitude.description,
                "lon": cLLocation.coordinate.longitude.description
            ]
        }
    }
}

public protocol NetworkManagerProtocol: AnyObject {
    func asyncRequest<T: Decodable>(endpoint: Endpoint) async throws -> T
}

public final class NetworkManager: NetworkManagerProtocol {
    private let baseURL: String = "https://api.openweathermap.org/data/2.5"
    
    public init() { }
    
    private func defaultParams() -> [URLQueryItem] {
        return [
            URLQueryItem(name: "appid", value: "bc17ff63f5545b684eebb7c9cf25e09c"),
            URLQueryItem(name: "exclude", value: "hourly,daily")
        ]
    }
    
    //https://api.openweathermap.org/data/3.0/onecall?lat=33.44&lon=-94.04&exclude=hourly,daily&appid={API key}
    public func asyncRequest<T: Decodable>(endpoint: Endpoint) async throws -> T {
        let urlRequest = try constructURLRequest(endpoint: endpoint)
        
        return try await withCheckedThrowingContinuation { continuation in
            let task = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
                .dataTask(with: urlRequest) { data, response, _ in
                    guard response is HTTPURLResponse else {
                        continuation.resume(throwing: APIError.invalidURL)
                        return
                    }
                    guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                        continuation.resume(throwing:
                                                APIError.decodingFailed)
                        return
                    }
                    guard let data = data else {
                        continuation.resume(throwing: APIError.decodingFailed)
                        return
                    }
                    guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
                        continuation.resume(throwing: APIError.decodingFailed)
                        return
                    }
                    continuation.resume(returning: decodedResponse)
                }
            task.resume()
        }
    }
    
    private func constructURLRequest(endpoint: Endpoint) throws -> URLRequest {
        var queryItems: [URLQueryItem] = defaultParams()
        for param in endpoint.parameters {
            queryItems.append(URLQueryItem(name: param.key, value: param.value))
        }
        
        guard let input = URL(string: baseURL + endpoint.path)
        else {
            throw APIError.invalidURL
        }
        var urlComponents = URLComponents(url: input, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url
        else {
            throw APIError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.httpMethod.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        return urlRequest
    }
}
