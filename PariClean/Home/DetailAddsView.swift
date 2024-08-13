//
//  DetailAddsView.swift
//  PariClean
//
//  Created by Владимир Кацап on 13.08.2024.
//

import Foundation
import UIKit



extension HomeViewController {
    
    func crateViewDetail() {
        detailView = {
            let view = UIView()
            view.backgroundColor = .black
            
            
            return view
        }()
        
        view.addSubview(detailView!)
        detailView!.snp.makeConstraints { make in
            make.height.equalTo(296)
            make.left.right.equalToSuperview()
        }
        
    }
    
    
    
    
    
    
}
