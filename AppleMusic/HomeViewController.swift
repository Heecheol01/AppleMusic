//
//  ViewController.swift
//  AppleMusic
//
//  Created by 김희철 on 11/23/25.
//

import UIKit

struct Album {
    let title: String
    let singer: String
    let image: UIImage?
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
    
    // 각 컬렉션뷰마다 서로 다른 랜덤 6개를 유지
    private var dataForCollection: [UICollectionView: [Album]] = [:]
    
    // 더미 데이터
    private var albums: [Album] = [
        Album(title: "Bad Dreams", singer: "Teddy Swims", image: UIImage(named: "BadDreams.jpg")),
        Album(title: "Apartment", singer: "Karthegarden", image: UIImage(named: "Apartment.jpg")),
        Album(title: "I've Tried Everything But Therapy", singer: "Teddy Swims", image: UIImage(named: "LoseControl.jpg")),
        Album(title: "이상비행", singer: "Hanroro", image: UIImage(named: "Flight.jpg")),
        Album(title: "자몽살구클럽", singer: "Hanroro", image: UIImage(named: "Jamong.jpg")),
        Album(title: "Harmony", singer: "Karthegarden", image: UIImage(named: "Harmony.jpg"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let all = albums
        let carousels: [UICollectionView?] = [collectionView1, collectionView2, collectionView3, collectionView4,
                                              collectionView5, collectionView6, collectionView7, collectionView8,
                                              collectionView9, collectionView10]
        
        carousels.forEach { cvOpt in
            if let cv = cvOpt {
                dataForCollection[cv] = Array(all.shuffled().prefix(6))
            }
        }
        
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
        return dataForCollection[collectionView]?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "인기 추천곡",
            for: indexPath
        ) as! CollectionCell

        if let album = dataForCollection[collectionView]?[indexPath.item] {
            cell.imageView.image = album.image
            cell.titleLabel.text = album.title
        } else {
            cell.imageView.image = nil
            cell.titleLabel.text = nil
        }
        return cell
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

            if let album = dataForCollection[collectionView]?[indexPath.item] {
                dest.titleText = album.title
                dest.collectionName = collectionViewName
                dest.image = album.image
                dest.singer = album.singer
            }
        }
    }
}
