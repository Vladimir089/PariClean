//
//  AchivementViewController.swift
//  PariClean
//
//  Created by Владимир Кацап on 14.08.2024.
//

import UIKit

class AchivementViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        createInterface() 
    }
    
    func createInterface() {
        let topLabel = UILabel()
        topLabel.text = "Achievement"
        topLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        topLabel.textColor = .white
        view.addSubview(topLabel)
        topLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        let exitButton: UIButton = {
            let button = UIButton()
            button.backgroundColor = .white.withAlphaComponent(0.05)
            button.layer.cornerRadius = 12
            button.setImage(.xmark.resize(targetSize: CGSize(width: 18, height: 18)), for: .normal)
            return button
        }()
        view.addSubview(exitButton)
        exitButton.snp.makeConstraints { make in
            make.height.width.equalTo(36)
            make.left.equalToSuperview().inset(15)
            make.centerY.equalTo(topLabel)
        }
        exitButton.addTarget(self, action: #selector(exit), for: .touchUpInside)
        
        //ДОДЕЛАТЬ АЧИВКИ И НАСТРойКИ
    }
   
    @objc func exit() {
        self.navigationController?.popViewController(animated: true)
    }
}
