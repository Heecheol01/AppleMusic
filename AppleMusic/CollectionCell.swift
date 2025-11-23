//
//  CollectionCell.swift
//  AppleMusic
//
//  Created by 김희철 on 11/23/25.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // Unity의 Awake 혹은 Start와 유사
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
}
