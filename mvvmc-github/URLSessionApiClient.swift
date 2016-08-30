//
//  Created by Felix Simoes on 11/07/16.
//  Copyright © 2016 Njiuko. All rights reserved.
//

import Foundation

class URLSessionApiClient: ApiClient {
    let session: URLSession
    var authentication: AuthenticationService

    init(authentication: AuthenticationService) {
        self.authentication = authentication
        session = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    func execute(route: ApiRouter, completion: ApiClientCompletionHandler) {
        var request = URLRequest(url: route.url)
        print("\(request.httpMethod ?? "?") : \(request.url?.absoluteString ?? "?")")

        if route.requiresAuthentication {
            guard let signedRequest = authentication.sign(request: request) else {
                completion(.failure(.Unauthorized))
                return
            }
            request = signedRequest
        }

        let task = session.dataTask(with: request) { data, response, error in
            // TODO: Check new log system for Xcode 8 and iOS 10
            print("   error: \(error)")
            print("response: \(response)")
            //print("    data: \(data)")
            
            func completionOnMainThread(result: ApiClientResult) {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            if error != nil {
                completionOnMainThread(result: ApiClientResult.failure(.Other(error!)))
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                switch statusCode {
                case 401:
                    completionOnMainThread(result: .failure(.Unauthorized))
                    return
                case let s where s < 200 || s >= 300:
                    completionOnMainThread(result: .failure(.NoSuccessStatusCode(statusCode: statusCode)))
                    return
                default: break
                }
            }
            
            guard let data = data else {
                completionOnMainThread(result: .failure(.NoData))
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data)
                completionOnMainThread(result: .success(json as AnyObject))
            } catch {
                completionOnMainThread(result: .failure(.CouldNotParseJSON))
            }
        }
        task.resume()
    }
}

extension ApiRouter {
    var url: URL {
        let parameterString = parameters.stringFromHttpParameters()
        if parameterString.isEmpty {
            return URL(string: urlString)!
        } else {
            return URL(string: "\(urlString)?\(parameterString)")!
        }
    }

    var requiresAuthentication: Bool {
        switch self {
        case .profile: return true
        default: return false
        }
    }
}

extension Dictionary {
    
    /// Build string representation of HTTP parameter dictionary of keys and objects
    ///
    /// This percent escapes in compliance with RFC 3986
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: String representation in the form of key1=value1&key2=value2 where the keys and values are percent escaped
    
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).stringByAddingPercentEncodingForURLQueryValue()!
            let percentEscapedValue = (value as! String).stringByAddingPercentEncodingForURLQueryValue()!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        
        return parameterArray.joined(separator: "&")
    }
    
}

extension String {
    
    /// Percent escapes values to be added to a URL query as specified in RFC 3986
    ///
    /// This percent-escapes all characters besides the alphanumeric character set and "-", ".", "_", and "~".
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: Returns percent-escaped string.
    
    func stringByAddingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
    
}
