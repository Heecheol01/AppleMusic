//
//  AlbumDetail.swift
//  AppleMusic
//
//  Created by 김희철 on 11/24/25.
//

import UIKit

class AlbumDetail: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var bad = ["Bad Dreams", "Bad Dreams"]
    var hanroro = ["이상비행", "이상비행", "해초", "화해", "금붕어", "자처", "사랑하게 될 거야"]
    var tour = ["I've Tried Everything But Therapy", "Some Things I'll Never Know", "Lose Control", "What More Can I Say", "The Door", "Goodbye's Been Good to You", "Last Communion", "You Still Get to Me", "SuitCase", "Flame", "Evergreen"]
    var apartment = ["Apartment", "섬으로 가요 (Feat. 오혁)", "그저 그런 날", "Lost 2 (Feat.선우정아)", "Home Sweet Home", "444", "젊은 꿈", "Beyond (feat. O3ohn)", "갈게", "Blue Blue", "Mother", "Together"]
    var jamong = ["자몽살구클럽", "내일에서 온 티켓", "용의자", "갈림길", "0+0", "__에게", "시간을 달리네", "도망"]
    var harmony = ["harmony", "harmony", "네 번의 여름", "내일의 우리", "내겐 그 아무도 없을 거야", "Foolish World", "My Old Friend"]
    
    var collectionName: String?
    var titleText: String?
    var image: UIImage?
    var singer: String?
    var album: [String] = []

    @IBOutlet var lblCollection: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSinger: UILabel!
    @IBOutlet var imgBackground: UIImageView!
    @IBOutlet var tableListView: UITableView!
    
    // 1-based safe accessor for album array
    private func albumTitle(atOneBased index: Int) -> String? {
        // valid 1-based range is 1...album.count
        guard index >= 1 && index <= album.count else { return nil }
        return album[index - 1]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lblCollection.text = collectionName
        lblTitle.text = titleText
        lblSinger.text = singer
        imgBackground.image = image
        
        tableListView.dataSource = self
        tableListView.delegate = self
        
        if titleText == bad[0] {
            album = bad
        } else if titleText == hanroro[0] {
            album = hanroro
        } else if titleText == tour[0] {
            album = tour
        } else if titleText == apartment[0] {
            album = apartment
        } else if titleText == jamong[0] {
            album = jamong
        } else {
            album = harmony
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return album.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Song", for: indexPath)
        
        let oneBasedIndex = indexPath.row + 1
        if let title = albumTitle(atOneBased: oneBasedIndex) {
            cell.textLabel?.text = "\(oneBasedIndex). \(title)"
        } else {
            cell.textLabel?.text = nil
        }
        
        return cell
    }
}
