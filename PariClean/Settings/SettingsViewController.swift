//
//  SettingsViewController.swift
//  PariClean
//
//  Created by Владимир Кацап on 15.08.2024.
//

import UIKit
import StoreKit
import WebKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        createInterface()
    }
    
    func createInterface() {
        let homeLabel = UILabel()
        homeLabel.text = "Settings"
        homeLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        homeLabel.textColor = .white
        view.addSubview(homeLabel)
        homeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        let shareBut = createButtons(title: "Share our app", Image: .share, titleButton: "Share")
        view.addSubview(shareBut)
        shareBut.snp.makeConstraints { make in
            make.height.equalTo(74)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(homeLabel.snp.bottom).inset(-35)
        }
        shareBut.addTarget(self, action: #selector(shareApps), for: .touchUpInside)
        
        let rateBut = createButtons(title: "Rate us", Image: .rate, titleButton: "Rate")
        view.addSubview(rateBut)
        rateBut.snp.makeConstraints { make in
            make.height.equalTo(74)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(shareBut.snp.bottom).inset(-10)
        }
        rateBut.addTarget(self, action: #selector(rateApps), for: .touchUpInside)
        
        let polBut = createButtons(title: "Usage Policy", Image: .policy, titleButton: "Read")
        view.addSubview(polBut)
        polBut.snp.makeConstraints { make in
            make.height.equalTo(74)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(rateBut.snp.bottom).inset(-10)
        }
        polBut.addTarget(self, action: #selector(policy), for: .touchUpInside)
    }
    
    @objc func policy() {
        let webVC = WebViewController()
        webVC.urlString = "pol"
        present(webVC, animated: true, completion: nil)
    }
    
    @objc func rateApps() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            if let url = URL(string: "id") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    @objc func shareApps() {
        let appURL = URL(string: "id")!
        let activityViewController = UIActivityViewController(activityItems: [appURL], applicationActivities: nil)
        
        // Настройка для показа в виде popover на iPad
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    
    func createButtons(title: String, Image: UIImage, titleButton: String) -> UIButton {
        let button = UIButton()
        button.layer.cornerRadius = 28
        button.backgroundColor = .white.withAlphaComponent(0.05)
        
        
        let imageVew = UIImageView(image: Image)
        imageVew.contentMode = .scaleAspectFit
        button.addSubview(imageVew)
        imageVew.snp.makeConstraints { make in
            make.height.width.equalTo(42)
            make.left.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        
        let label = UILabel()
        label.text = title
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        button.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(imageVew.snp.right).inset(-15)
        }
        
        let secButton = UIButton()
        secButton.setTitle(titleButton, for: .normal)
        secButton.setTitleColor(.white, for: .normal)
        secButton.backgroundColor = UIColor(red: 118/255, green: 118/255, blue: 128/255, alpha: 0.24)
        secButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        secButton.layer.cornerRadius = 17
        button.addSubview(secButton)
        secButton.snp.makeConstraints { make in
            make.height.equalTo(34)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(15)
        }
        
        
        return button
    }
    

}



class WebViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var urlString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
        // Загружаем URL
        if let urlString = urlString, let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
    }
}
