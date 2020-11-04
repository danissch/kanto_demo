//
//  RecordsViewModelProtocol.swift
//  kanto-demo
//
//  Created by Daniel Durán Schutz on 30/10/20.
//

import Foundation

protocol RecordsViewModelProtocol {
    var recordsList:Records { get }
    func getRecords(complete:@escaping (ServiceResult<Records?>) -> Void)
}
