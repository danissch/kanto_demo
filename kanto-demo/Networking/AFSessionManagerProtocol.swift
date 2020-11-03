//
//  AFSessionManagerProtocol.swift
//  kanto-demo
//
//  Created by Daniel Durán Schutz on 30/10/20.
//

import Foundation
import Alamofire

protocol AFSessionManagerProtocol {
    func responseString(_ url:String,
                        method: HTTPMethod,
                        parameters: Parameters?,
                        enconding: ParameterEncoding,
                        completionHandler: @escaping (DataResponse<String>) -> Void)
}
