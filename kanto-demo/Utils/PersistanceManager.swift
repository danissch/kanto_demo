//
//  PersistanceManager.swift
//  kanto-demo
//
//  Created by Daniel Durán Schutz on 2/11/20.
//

import Foundation
import UIKit

protocol PersistanceManagerDelegate {
//    func onSaveData()
    func onLoadUserImg(img:UIImage)
}

class PersistanceManager:NSObject {
    static var sharedInstance = PersistanceManager()
    
    var delegate:PersistanceManagerDelegate?
    
    var profileImage:String = {
//        let defaultDataImagePNG = UIImage(named: "userprofile")!.pngData()
        return UserDefaults.standard.string(forKey: "profileImage") ?? ""
    }()
    {
        didSet {
            UserDefaults.standard.set(profileImage, forKey: "profileImage")
        }
    }
    
    var profileName: String = {
        return UserDefaults.standard.string(forKey: "profileName") ?? "Ana Chacon"
    }()
    {
        didSet {
            UserDefaults.standard.set(profileName, forKey: "profileName")
        }
    }

    var profileUserName: String = {
        return UserDefaults.standard.string(forKey: "profileUserName") ?? "achaconc"
    }()
    {
        didSet {
            UserDefaults.standard.set(profileUserName, forKey: "profileUserName")
        }
    }

    var profileBiography: String = {
        return UserDefaults.standard.string(forKey: "profileBiography") ?? "This is my biography"
    }()
    {
        didSet {
            UserDefaults.standard.set(profileBiography, forKey: "profileBiography")
        }
    }
    
    func saveimg(image:UIImage){
        do {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent("userp_img.png")
            if let pngImageData = image.pngData() {
                try pngImageData.write(to: fileURL, options: .atomic)
            }
        } catch {
            print("appflow:: Error saveimg : \(error)")
        }
    }
    
    func loadimg() -> UIImage {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = documentsURL.appendingPathComponent("userp_img.png").path
        if FileManager.default.fileExists(atPath: filePath) {
            let img = UIImage(contentsOfFile: filePath)!
            delegate?.onLoadUserImg(img: img)
            return img
        }
        return UIImage(named: "userprofile")!
    }
        
}

extension UIImage {
    convenience init?(fileURLWithPath url: URL, scale: CGFloat = 1.0) {
        do {
            let data = try Data(contentsOf: url)
            self.init(data: data, scale: scale)
        } catch {
            print("-- Error: \(error)")
            return nil
        }
    }
}
