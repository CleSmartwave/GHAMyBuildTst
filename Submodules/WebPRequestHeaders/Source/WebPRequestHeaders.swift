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
        var request = URLRequest(url: self)
        return ImageRequest(urlRequest: setWebPUrlRequest(urlRequest: &request))
    }
    
    public func setRequestWebPHeaders(withRoundedCorners radius: CGFloat) -> ImageRequest {
        var request = URLRequest(url: self)
        return ImageRequest(urlRequest: setWebPUrlRequest(urlRequest: &request), processors: [
            ImageProcessors.RoundedCorners(radius: radius)
        ])
    }
    
    private func setWebPUrlRequest(urlRequest: inout URLRequest) -> URLRequest {
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
