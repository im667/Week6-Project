//
//  HomeViewController.swift
//  Week6-Project
//
//  Created by mac on 2021/11/01.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "HOME"
        
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(IsClickedPlusBarButton(_:)))
        
        let backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(IsClickedBackBtn))
        
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    

    @objc func IsClickedPlusBarButton(_ sender:UIBarButtonItem){
        
        let sb = UIStoryboard(name: "Content", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: AddViewController.identifier) as! AddViewController
        let nav = UINavigationController(rootViewController: vc)
        
        nav.modalPresentationStyle = .fullScreen
        
        present(nav, animated: true, completion: nil)
        

    }
    @objc func IsClickedBackBtn (){
        navigationController?.popViewController(animated: true)
    }
    }

