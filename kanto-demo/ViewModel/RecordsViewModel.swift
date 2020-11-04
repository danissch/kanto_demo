//
//  RecordsViewModel.swift
//  kanto-demo
//
//  Created by Daniel Durán Schutz on 30/10/20.
//

import Foundation

class RecordsViewModel: RecordsViewModelProtocol{
    
    var networkService: NetworkServiceProtocol?
    
    private var privRecordsList = Records()
    var recordsList: Records {
        get { return privRecordsList}
    }
    
    func getRecords(complete: @escaping (ServiceResult<Records?>) -> Void) {
        guard let networkService = networkService else {
            return complete(.Error("Missing network service", 0))
        }
        
        let url = "\(ApiRoutes.recordsUrl)"
        networkService.request(url: url, method: .get, parameters: nil) { [weak self] (result) in
            switch result {
            case .Success(let json, let statusCode):
                do {
                    if let data = json?.data(using: .utf8) {
                        let decoder = JSONDecoder()
                        let recordsResponse = try decoder.decode(Records.self, from: data)
                        self?.privRecordsList.append(contentsOf: recordsResponse)
                        return complete(.Success(self?.privRecordsList, statusCode))
                    }
                    return complete(.Error("Error parsing data", statusCode))
                } catch {
                    print("error:\(error)")
                    return complete(.Error("Error decoding JSON", statusCode))
                }
            case .Error(let message, let statusCode):
                print("case .Error ::")
                return complete(.Error(message, statusCode))
            }
        }
    }
    
}
