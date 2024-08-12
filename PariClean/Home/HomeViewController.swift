//
//  HomeViewController.swift
//  PariClean
//
//  Created by Владимир Кацап on 12.08.2024.
//

import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    func reloadDiagramm(allDays: Int, totalDays: Int)
}

class HomeViewController: UIViewController {
    
    let progressView = CircularProgressView(frame: CGRect(x: 0, y: 0, width: 150, height: 150), lineWidth: 5, rounded: true)
    
    var progress = [0, 31]
    var progressLabel: UILabel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        createInterface()
        checkData()
    }
    
    func checkData() {
        if let data = UserDefaults.standard.array(forKey: "Home") as? [Int] {
            progress = data
        } else {
            progress = [0, 31]
        }
        fillProgress()
    }
    
    func fillProgress() {
        let oneProg = Float(progress[0])
        let twoProg = Float(progress[1])
        
        progressView.progress = oneProg / twoProg
        progressLabel?.text = "\(progress[0])/\(progress[1])"
    }
    
    @objc func openEditDays() {
        let vc = EditDiagramViewController()
        vc.delegate = self
        self.present(vc, animated: true)
    }
    

    func createInterface() {
        let homeLabel = UILabel()
        homeLabel.text = "Home"
        homeLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        homeLabel.textColor = .white
        view.addSubview(homeLabel)
        homeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        let midView = UIView()
        midView.backgroundColor = .white.withAlphaComponent(0.08)
        midView.layer.cornerRadius = 16
        view.addSubview(midView)
        midView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(293)
            make.top.equalTo(homeLabel.snp.bottom).inset(-50)
        }
        
        let editButtin: UIButton = {
            let button = UIButton(type: .system)
            button.setImage(.edit.resize(targetSize: CGSize(width: 20, height: 18)), for: .normal)
            button.backgroundColor = .white.withAlphaComponent(0.05)
            button.layer.cornerRadius = 24
            button.tintColor = .white.withAlphaComponent(0.5)
            return button
        }()
        midView.addSubview(editButtin)
        editButtin.snp.makeConstraints { make in
            make.height.width.equalTo(48)
            make.right.top.equalToSuperview().inset(15)
        }
        editButtin.addTarget(self, action: #selector(openEditDays), for: .touchUpInside)
        
        progressView.progressColor = .white
        progressView.trackColor = .white.withAlphaComponent(0.08)
        midView.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.height.width.equalTo(150)
            make.center.equalToSuperview()
        }
        
        progressLabel = {
            let label = UILabel()
            label.text = "\(progress[0])/\(progress[1])"
            label.font = .systemFont(ofSize: 20, weight: .regular)
            label.textColor = .white
            return label
        }()
        midView.addSubview(progressLabel!)
        progressLabel?.snp.makeConstraints({ make in
            make.center.equalToSuperview()
        })
        
        let daysLabel = UILabel()
        daysLabel.text = "Days without bad habits"
        daysLabel.font = .systemFont(ofSize: 28, weight: .bold)
        daysLabel.textColor = .white
        midView.addSubview(daysLabel)
        daysLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
        }
        
    }

}


extension HomeViewController: HomeViewControllerDelegate {   //ДОДЕЛАТЬ РЕДАКТИРОВАНИЕ 
    func reloadDiagramm(allDays: Int, totalDays: Int) {
        progress = [allDays, totalDays]
        fillProgress()
        
        UserDefaults.standard.setValue(progress, forKey: "Home")
    }
}
