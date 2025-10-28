//
//  AppConfiguration.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//

import Foundation
import NeedleFoundation

protocol AppConfigurationProtocol: AnyObject {
    var baseURL: String { get }
}

final class AppConfiguration: AppConfigurationProtocol {
    var baseURL: String {
        let urlString = Bundle.main.infoDictionary?[Constants.BaseUrlKey] as? String
        return urlString?.replacingOccurrences(of: "\\/", with: "/") ?? ""
    }
}
