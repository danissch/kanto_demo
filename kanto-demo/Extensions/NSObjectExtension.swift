//
//  NSObjectExtension.swift
//  kanto-demo
//
//  Created by Daniel Durán Schutz on 30/10/20.
//

import Foundation

extension NSObject {
    
    
    @objc class var stringRepresentation:String {
        let name = String(describing: self)
        return name
    }
    
    
}
