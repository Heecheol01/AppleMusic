//
//  AlbumDetail.swift
//  AppleMusic
//
//  Created by 김희철 on 11/24/25.
//

import UIKit

class AlbumDetail: UIViewController {
    
    var collectionName: String?
    var titleText: String?
    var color: UIColor?

    @IBOutlet var lblCollection: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var imgBackground: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lblCollection.text = collectionName
        lblTitle.text = titleText
        imgBackground.backgroundColor = color
    }


}

