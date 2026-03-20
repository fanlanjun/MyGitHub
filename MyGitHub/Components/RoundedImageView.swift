//
//  RoundedImageView.swift
//  MyGitHub
//
//  Created by Frank Fan on 20/3/2026.
//

import UIKit
import Kingfisher

class RoundedImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyle() {
        layer.cornerRadius = 8
        clipsToBounds = true
        contentMode = .scaleAspectFill
        backgroundColor = .systemGray5
    }
    
    func setImage(with url: URL?) {
        kf.setImage(
            with: url,
            placeholder: UIImage(systemName: "person.circle"),
            options: [.transition(.fade(0.2))]
        )
    }
}
