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
        return UserDefaults.standard.string(forKey: "profileImage") ?? ""
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
    
    func saveimg(image:UIImage){
        print("appflow::PersistanceManager saveimg")
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
        print("appflow::PersistanceManager loadimg")
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = documentsURL.appendingPathComponent("userp_img.png").path
        if FileManager.default.fileExists(atPath: filePath) {
            let img = UIImage(contentsOfFile: filePath)!
            delegate?.onLoadUserImg(img: img)
            return img
        }
        return UIImage(named: "userprofile")!
    }
    
//    func documentDirectoryPath() -> URL? {
//            let path = FileManager.default.urls(for: .documentDirectory,
//                                                in: .userDomainMask)
//            return path.first
//        }
        
//        func savePng(_ image: UIImage) {
//            print("appflow.: savePng")
//            if let pngData = image.pngData(),
//                let path = documentDirectoryPath()?.appendingPathComponent("userp.png") {
//                if let imageData = image.jpegData(compressionQuality: 0.5) {
////                    try imageData.write(to: fileURL)
//                    do {
//                        try pngData.write(to: path)
//
//                    } catch {
//                        print("Error savePng image : \(error)")
//                    }
//                    print("appflow.: parece que se guardó")
//                    profileImage = path.absoluteString
//                    print("appflow::savePng:: profileImage:: \(profileImage)")
//                }
//            }
//        }
        
//        func saveJpg(_ image: UIImage) {
//
//            if let jpgData = image.jpegData(compressionQuality: 0.5),
//                let path = documentDirectoryPath()?.appendingPathComponent("userp.jpg") {
//                try? jpgData.write(to: path)
//            }
//        }
        
//        func readImage() -> Data{
//            print("appflow::readImage ")
//            if let path = documentDirectoryPath() {
//                let pngImageURL = path.appendingPathComponent("userp.png")
//                let jpgImageURL = path.appendingPathComponent("userp.jpg")
//
//                let pngImage = FileManager.default.contents(atPath: pngImageURL.path)
//                let jpgImage = FileManager.default.contents(atPath: jpgImageURL.path)
//                print("appflow:: pngImageURL.path:\(pngImageURL.path)")
//                print("appflow:: type pngImageURL.path:\(type(of:pngImageURL.path))")
//                print(pngImage)
//                print(jpgImage)
//
//                return pngImage ?? UIImage(named: "userprofile")?.pngData() as! Data
//
//            }
//            return (UIImage(named: "userprofile")?.pngData())!
//        }

    
//    func load(fileName: String) -> UIImage? {
//        let fileURL = documentDirectoryPath()?.appendingPathComponent(fileName)
//        print("appflow:: load fileURL::: \(fileURL)")
//        do {
////            let imageData = try Data(contentsOf: fileURL!)
////            guard let img2 = UIImage(fileURLWithPath: fileURL!) else { return UIImage(named:"userprofile")}
//            let img2 = UIImage(fileURLWithPath: fileURL!)
//            return img2
////            return UIImage(data: imageData)
//        } catch {
//            print("Error loading image : \(error)")
//        }
//        return nil
//    }
    
//    func fileInDocumentsDirectory(filename: String) -> String {
//
//        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let fileURL = documentsURL.appendingPathComponent(filename).absoluteString
//        return fileURL
//    }
}

//extension UIImage {
//
//    func save(at directory: FileManager.SearchPathDirectory,
//              pathAndImageName: String,
//              createSubdirectoriesIfNeed: Bool = true,
//              compressionQuality: CGFloat = 1.0)  -> URL? {
//        do {
//        let documentsDirectory = try FileManager.default.url(for: directory, in: .userDomainMask,
//                                                             appropriateFor: nil,
//                                                             create: false)
//        return save(at: documentsDirectory.appendingPathComponent(pathAndImageName),
//                    createSubdirectoriesIfNeed: createSubdirectoriesIfNeed,
//                    compressionQuality: compressionQuality)
//        } catch {
//            print("-- Error: \(error)")
//            return nil
//        }
//    }
//
//    func save(at url: URL,
//              createSubdirectoriesIfNeed: Bool = true,
//              compressionQuality: CGFloat = 1.0)  -> URL? {
//        do {
//            if createSubdirectoriesIfNeed {
//                try FileManager.default.createDirectory(at: url.deletingLastPathComponent(),
//                                                        withIntermediateDirectories: true,
//                                                        attributes: nil)
//            }
//            guard let data = jpegData(compressionQuality: compressionQuality) else { return nil }
//            try data.write(to: url)
//            return url
//        } catch {
//            print("-- Error: \(error)")
//            return nil
//        }
//    }
//}

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
