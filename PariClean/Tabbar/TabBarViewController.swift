//
//  TabBarViewController.swift
//  PariClean
//
//  Created by Владимир Кацап on 12.08.2024.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    let homeVC = HomeViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = UIColor(red: 23/255, green: 33/255, blue: 37/255, alpha: 1)
        createInterface()
        UserDefaults.standard.setValue("1", forKey: "tab")
    }
    

    func createInterface() {
        let separator = UIView()
        separator.backgroundColor = .white.withAlphaComponent(0.1)
        tabBar.addSubview(separator)
        separator.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.right.top.equalToSuperview()
        }
        
        tabBar.unselectedItemTintColor = .white.withAlphaComponent(0.3)
        tabBar.tintColor = UIColor(red: 248/255, green: 255/255, blue: 21/255, alpha: 1)
        
        
        
        let homeItem = UITabBarItem(title: "Home", image: .home.resize(targetSize: CGSize(width: 22, height: 22)), tag: 0)
        homeVC.tabBarItem = homeItem
        
        viewControllers = [homeVC]
    }

}



extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}


extension UIViewController {
    func hideNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func showNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
