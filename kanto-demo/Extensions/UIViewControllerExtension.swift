//
//  UIViewControllerExtension.swift
//  kanto-demo
//
//  Created by Daniel Durán Schutz on 30/10/20.
//

import Foundation
import UIKit

extension UIViewController {

    internal class func instantiateFromXIB<T:UIViewController>() -> T{
        let xibName = T.stringRepresentation
        let vc = T(nibName: xibName, bundle: nil)
        return vc
    }
    
    func presentWithStyle1(vcFrom:UIViewController, vcTo:UIViewController, animated:Bool = true, presentStyle:UIModalPresentationStyle = .fullScreen, transitionStyle:UIModalTransitionStyle = .coverVertical){
        vcTo.modalPresentationStyle = presentStyle
        vcTo.modalTransitionStyle = transitionStyle
        vcFrom.present(vcTo, animated: true, completion: nil)
    }
    
    @objc internal func navigateBack(){
        if isModal {
            dismiss(animated: true, completion: nil)
        }else{
            _ = navigationController?.popViewController(animated: true)
        }
    }
        
    var isModal:Bool {
        if presentingViewController != nil {
            return true
        }
        if presentingViewController?.presentedViewController == self {
            return true
        }
        if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        }
        if tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        
        return false
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
