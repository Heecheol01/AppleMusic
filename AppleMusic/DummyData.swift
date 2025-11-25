//
//  DummyData.swift
//  AppleMusic
//
//  Created by 김희철 on 11/25/25.
//

import UIKit

final class DummyData {
    static let shared = DummyData()
    
    struct Album {
        let title: String
        let singer: String
        let image: UIImage?
    }
    
    var albums: [Album] = [
        Album(title: "Bad Dreams", singer: "Teddy Swims", image: UIImage(named: "BadDreams.jpg")),
        Album(title: "Apartment", singer: "Karthegarden", image: UIImage(named: "Apartment.jpg")),
        Album(title: "I've Tried Everything But Therapy", singer: "Teddy Swims", image: UIImage(named: "LoseControl.jpg")),
        Album(title: "이상비행", singer: "Hanroro", image: UIImage(named: "Flight.jpg")),
        Album(title: "자몽살구클럽", singer: "Hanroro", image: UIImage(named: "Jamong.jpg")),
        Album(title: "Harmony", singer: "Karthegarden", image: UIImage(named: "Harmony.jpg"))
    ]
    
    func getAlbums() -> [Album] { albums }
}
