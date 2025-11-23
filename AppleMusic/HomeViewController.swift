//
//  ViewController.swift
//  AppleMusic
//
//  Created by 김희철 on 11/23/25.
//

import UIKit

struct Album {
    let title: String
    let color: UIColor
}

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var collectionView1: UICollectionView!
    @IBOutlet var collectionView2: UICollectionView!
    @IBOutlet var collectionView3: UICollectionView!
    @IBOutlet var collectionView4: UICollectionView!
    @IBOutlet var collectionView5: UICollectionView!
    @IBOutlet var collectionView6: UICollectionView!
    @IBOutlet var collectionView7: UICollectionView!
    @IBOutlet var collectionView8: UICollectionView!
    @IBOutlet var collectionView9: UICollectionView!
    @IBOutlet var collectionView10: UICollectionView!
    
    // 더미 데이터
    private var albums: [Album] = [
        Album(title: "Album 1", color: .systemPink),
        Album(title: "Album 2", color: .systemBlue),
        Album(title: "Album 3", color: .systemGreen),
        Album(title: "Album 4", color: .systemOrange),
        Album(title: "Album 5", color: .systemPurple),
        Album(title: "Album 6", color: .systemTeal)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        [collectionView1, collectionView5, collectionView7].forEach {
            cv in
            cv?.dataSource = self
            cv?.delegate = self
            cv?.collectionViewLayout = scrollCell(280)
            cv?.showsHorizontalScrollIndicator = false
            cv?.decelerationRate = .fast
        }
        
        [collectionView2, collectionView3, collectionView4, collectionView6, collectionView8, collectionView9, collectionView10].forEach {
            cv in
            cv?.dataSource = self
            cv?.delegate = self
            cv?.collectionViewLayout = scrollCell(220)
            cv?.showsHorizontalScrollIndicator = false
            cv?.decelerationRate = .fast
        }
    }
    
    // https://ios-development.tistory.com/948
    private func scrollCell(_ height: CGFloat) -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.52),
            heightDimension: .absolute(height)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = 2
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)

        return UICollectionViewCompositionalLayout(section: section)
    }

    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        albums.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "인기 추천곡",
            for: indexPath
        ) as? CollectionCell {
            let album = albums[indexPath.item]
            cell.imageView.backgroundColor = album.color
            cell.titleLabel.text = album.title
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 어떤 컬렉션뷰에서 왔는지 구분이 필요하면 collectionView 비교로 분기 가능
        performSegue(withIdentifier: "ShowDetail", sender: (collectionView, indexPath))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail",
           let dest = segue.destination as? AlbumDetail,
           let (collectionView, indexPath) = sender as? (UICollectionView, IndexPath) {

            let collectionViewName: String
            if collectionView === collectionView1 { collectionViewName = "인기 추천" }
            else if collectionView === collectionView2 { collectionViewName = "최근 재생한 음악" }
            else if collectionView === collectionView3 { collectionViewName = "한국 인디" }
            else if collectionView === collectionView4 { collectionViewName = "컨트리" }
            else if collectionView === collectionView5 { collectionViewName = "나만을 위한 추천" }
            else if collectionView === collectionView6 { collectionViewName = "추천 스테이션" }
            else if collectionView === collectionView7 { collectionViewName = "리플레이: 가장 많이 들은 음악" }
            else if collectionView === collectionView8 { collectionViewName = "나의 무드 찾기" }
            else if collectionView === collectionView9 { collectionViewName = "최신 발매" }
            else if collectionView === collectionView10 { collectionViewName = "Teddy Swims 팬이 즐겨 찾는 다른 항목" }
            else { collectionViewName = "unknown" }

            let album = albums[indexPath.item]
            dest.titleText = album.title
            dest.collectionName = collectionViewName
            dest.color = album.color
        }
    }
}
