//
//  LoadViewController.swift
//  PariClean
//
//  Created by Владимир Кацап on 12.08.2024.
//
import SnapKit
import UIKit

class LoadViewController: UIViewController {
    
    var progressLabel: UILabel?
    var timer: Timer?
    var progress: Int = 0
    var progressForView: Float = 0
    var progressView: UIProgressView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        createInterface()
        startProgress()
    }
    
    func createInterface() {
        let imageView = UIImageView(image: .userLoadOne)
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(520)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-70)
        }
        
        progressView = {
            let progressView = UIProgressView()
            progressView.setProgress(0, animated: true)
            progressView.layer.cornerRadius = 2
            progressView.backgroundColor = .white.withAlphaComponent(0.05)
            progressView.progressTintColor = UIColor(red: 248/255, green: 255/255, blue: 21/255, alpha: 1)
            progressView.clipsToBounds = true
            return progressView
        }()
        view.addSubview(progressView!)
        progressView?.snp.makeConstraints({ make in
            make.height.equalTo(10)
            make.width.equalTo(205)
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).inset(-30)
        })
        
        progressLabel = {
            let label = UILabel()
            label.text = "LOADING 0%"
            label.font = .systemFont(ofSize: 17, weight: .semibold)
            label.textColor = .white
            return label
        }()
        view.addSubview(progressLabel!)
        progressLabel?.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(progressView!.snp.bottom).inset(-15)
        })
    }


    func startProgress() {
        progress = 0
        progressLabel?.text = "\(progress)%"      //ПОРМЕНЯТЬ НА timeInterval: 0.07
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }
    
    @objc func updateProgress() {
            if progress < 100 {
                progress += 1
                progressLabel?.text = "LOADING \(progress)%"
                progressForView += 0.01
                UIView.animate(withDuration: 0.1) {
                    self.progressView?.setProgress(self.progressForView, animated: true)
                }
            } else {
                timer?.invalidate()
                timer = nil
                if isBet == false {
                    if UserDefaults.standard.object(forKey: "tab") != nil {
                        self.navigationController?.setViewControllers([TabBarViewController()], animated: true)
                    } else {
                       self.navigationController?.setViewControllers([UserOnbViewController()], animated: true)
                    }
                } else {
                    
                }
            }
        }
    
}
