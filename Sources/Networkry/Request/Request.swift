//
//  Request.swift
//  
//
//  Created by Aaqib Hussain on 19.12.21.
//

import Foundation

public protocol Request {
    var host: String { get }
    var path: String { get }
    var requestType: RequestType { get }
}
