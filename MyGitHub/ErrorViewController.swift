//
//  ErrorViewController.swift
//  MyGitHub
//
//  Created by Frank Fan on 20/3/2026.
//

import UIKit

class ErrorViewController: UIViewController {
    
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        label.text = NSLocalizedString("error_message", comment: "")
        label.textAlignment = .center
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func configure(with err: Error) {
        label.text = err.localizedDescription
        
    }
}
