//
//  NetworkController.swift
//  Marvel Superheroes
//
//  Created by Luis Carlos Rosa on 13/03/18.
//  Copyright © 2018 Luis. All rights reserved.
//

import Foundation

enum BackendError: Error {
    case urlError(reason: String)
    case objectSerialization(reason: String)
}

class NetworkController {
    
    
    private var baseUrl:String
    private var apiKey:String = "b56deb618cadad85723376a7c4956743"
    private var privateKey:String = "a9420be765d8255c52a6896f4699d3e59a1f8364"
    
    init(baseUrl:String) {
        self.baseUrl = baseUrl
    }
    
    public func getSuperheroes(limit: Int, offset: Int, completionHandler: @escaping (Data?, Error?) -> Void) {
        
        let timestamp = NSDate().timeIntervalSince1970
        let hash = md5("\(timestamp)\(privateKey)\(apiKey)")
        let endpoint = "\(baseUrl)?apikey=\(apiKey)&ts=\(timestamp)&hash=\(hash)&limit=\(limit)&offset=\(offset)"
        
        createRequest(urlString: endpoint, completionHandler: completionHandler)
    }
    
    public func getSuperherosByName(searchText: String, limit: Int, offset: Int, completionHandler: @escaping (Data?, Error?) -> Void) {
        let timestamp = NSDate().timeIntervalSince1970
        let hash = md5("\(timestamp)\(privateKey)\(apiKey)")
        let endpoint = "\(baseUrl)?apikey=\(apiKey)&ts=\(timestamp)&hash=\(hash)&limit=\(limit)&offset=\(offset)&nameStartsWith=\(searchText)"
        
        createRequest(urlString: endpoint, completionHandler: completionHandler)
    }
    
    public func getItemDetails(completionHandler: @escaping (Data?, Error?) -> Void) {
        let timestamp = NSDate().timeIntervalSince1970
        let hash = md5("\(timestamp)\(privateKey)\(apiKey)")
        let endpoint = "\(baseUrl)?apikey=\(apiKey)&ts=\(timestamp)&hash=\(hash)"
        
        createRequest(urlString: endpoint, completionHandler: completionHandler)
    }
    
    private func createRequest(urlString: String, completionHandler: @escaping (Data?, Error?) -> Void) {
        
        guard let url = URL(string: urlString) else {
            let error = BackendError.urlError(reason: "Could not construct URL")
            completionHandler(nil, error)
            return
        }
        let urlRequest = URLRequest(url: url)
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            guard error == nil else {
                completionHandler(nil, error!)
                return
            }
            guard let responseData = data else {
                let error = BackendError.objectSerialization(reason: "No data in response")
                completionHandler(nil, error)
                return
            }
            
            completionHandler(responseData, nil)
            
        })
        task.resume()
    }
    
    private func md5(_ string: String) -> String {
        let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
        var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5_Init(context)
        CC_MD5_Update(context, string, CC_LONG(string.lengthOfBytes(using: String.Encoding.utf8)))
        CC_MD5_Final(&digest, context)
        context.deallocate(capacity: 1)
        var hexString = ""
        for byte in digest {
            hexString += String(format:"%02x", byte)
        }
        return hexString
    }
}


