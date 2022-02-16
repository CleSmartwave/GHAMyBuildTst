//
//  WebPRequestHeaders.swift
//  WebPRequestHeaders
//
//  Created by Pat Osorio on 3/11/20.
//  Copyright © 2020 Pat Osorio. All rights reserved.
//

import Foundation
import Nuke
import UIKit

extension URL {
    
    public func setRequestWebPHeaders() -> ImageRequest {
        var request = ImageRequest(url: self)
        request.urlRequest = setWebPUrlRequest(imageRequest: request)
        return request
    }
    
    public func setRequestWebPHeaders(withRoundedCorners radius: CGFloat) -> ImageRequest {
        var request = ImageRequest(url: self, processors: [
            ImageProcessor.RoundedCorners(radius: radius)
        ])
        request.urlRequest = setWebPUrlRequest(imageRequest: request)
        return request
    }
    
    private func setWebPUrlRequest(imageRequest: ImageRequest) -> URLRequest {
        var urlRequest = imageRequest.urlRequest
        urlRequest.setValue("image/webp", forHTTPHeaderField: "Accept")
        urlRequest.setValue(getUserAgent(), forHTTPHeaderField: "User-Agent")
        return urlRequest
    }
    
    private func getUserAgent() -> String {
        let bundleIdentifier = Bundle.main.bundleIdentifier ?? ""
        let systemVersion = UIDevice.current.systemVersion
        if let dict = Bundle.main.infoDictionary {
           if let version = dict["CFBundleShortVersionString"] as? String,
               let bundleVersion = dict["CFBundleVersion"] as? String,
               let appName = dict["CFBundleName"] as? String {
            return "\(appName)/\(version) (\(bundleIdentifier); build:\(bundleVersion); iOS \(systemVersion))"
           }
        }
        return ""
    }
}
