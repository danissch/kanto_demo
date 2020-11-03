//
//  PersistanceManager.swift
//  kanto-demo
//
//  Created by Daniel Durán Schutz on 2/11/20.
//

import Foundation
import UIKit

class PersistanceManager:NSObject {
    static var sharedInstance = PersistanceManager()
    
    
//    func saveImage(image: UIImage) -> Bool {
//        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
//            return false
//        }
//        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
//            return false
//        }
//        do {
//            try data.write(to: directory.appendingPathComponent("filePhotoUser.png")!)
//            return true
//        } catch {
//            print(error.localizedDescription)
//            return false
//        }
//    }
//
//    func getSavedImage(named: String) -> UIImage? {
//        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) {
//            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
//        }
//        return nil
//    }
//    func saveImageUrl(){
//            let path = "photo/temp/album1/img.jpg"
//            guard   let img = UIImage(named: "img"),
//            let url = img.save(at: .documentDirectory,
//                               pathAndImageName: path) else { return nil }
//    }
    
    var profileImage:String = {
//        let defaultDataImagePNG = UIImage(named: "userprofile")!.pngData()
        return UserDefaults.standard.string(forKey: "profileImage")  ?? ""
    }()
    {
        didSet {
            UserDefaults.standard.set(profileImage, forKey: "profileImage")
        }
    }
    
//    var profileImageUrl:String {
////        let defaultDataImagePNG = UIImage(named: "userprofile")!.pngData()
//
//        return UserDefaults.standard.object(forKey: "profileImage") as? Data ?? defaultDataImagePNG!
//    }()
//    {
//
//            UserDefaults.standard.set(profileImage, forKey: "profileImage")
//        }
//    }
//
//
//        print(url)
        
        
    
    
    
    
    
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
    
    
    
    
    func documentDirectoryPath() -> URL? {
            let path = FileManager.default.urls(for: .documentDirectory,
                                                in: .userDomainMask)
            return path.first
        }
        
        func savePng(_ image: UIImage) {
            if let pngData = image.pngData(),
                let path = documentDirectoryPath()?.appendingPathComponent("userp.png") {
                if let imageData = image.jpegData(compressionQuality: 0.5) {
//                    try imageData.write(to: fileURL)
                    try? pngData.write(to: path)
                    print("appflow.: parece que se guardó")
                }
            }
        }
        
        func saveJpg(_ image: UIImage) {
            if let jpgData = image.jpegData(compressionQuality: 0.5),
                let path = documentDirectoryPath()?.appendingPathComponent("userp.jpg") {
                try? jpgData.write(to: path)
            }
        }
        
        func readImage() -> Data{
            if let path = documentDirectoryPath() {
                let pngImageURL = path.appendingPathComponent("userp.png")
                let jpgImageURL = path.appendingPathComponent("userp.jpg")
                
                let pngImage = FileManager.default.contents(atPath: pngImageURL.path)
                let jpgImage = FileManager.default.contents(atPath: jpgImageURL.path)
                
                print(pngImage)
                print(jpgImage)
                
                return pngImage ?? UIImage(named: "userprofile")?.pngData() as! Data
                
            }
            return (UIImage(named: "userprofile")?.pngData())!
        }

}

extension UIImage {

    func save(at directory: FileManager.SearchPathDirectory,
              pathAndImageName: String,
              createSubdirectoriesIfNeed: Bool = true,
              compressionQuality: CGFloat = 1.0)  -> URL? {
        do {
        let documentsDirectory = try FileManager.default.url(for: directory, in: .userDomainMask,
                                                             appropriateFor: nil,
                                                             create: false)
        return save(at: documentsDirectory.appendingPathComponent(pathAndImageName),
                    createSubdirectoriesIfNeed: createSubdirectoriesIfNeed,
                    compressionQuality: compressionQuality)
        } catch {
            print("-- Error: \(error)")
            return nil
        }
    }

    func save(at url: URL,
              createSubdirectoriesIfNeed: Bool = true,
              compressionQuality: CGFloat = 1.0)  -> URL? {
        do {
            if createSubdirectoriesIfNeed {
                try FileManager.default.createDirectory(at: url.deletingLastPathComponent(),
                                                        withIntermediateDirectories: true,
                                                        attributes: nil)
            }
            guard let data = jpegData(compressionQuality: compressionQuality) else { return nil }
            try data.write(to: url)
            return url
        } catch {
            print("-- Error: \(error)")
            return nil
        }
    }
}

// load from path

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
