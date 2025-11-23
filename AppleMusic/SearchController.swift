//
//  Search.swift
//  AppleMusic
//
//  Created by 김희철 on 11/23/25.
//

import UIKit
import Speech
import AVFoundation

class SearchController: UIViewController, UISearchResultsUpdating {

    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
//         Do any additional setup after loading the view.
        configureSearch()
    }

    private func configureSearch() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Apple Music"

        // 네비게이션 바에 검색 컨트롤러를 통합
        navigationItem.searchController = searchController

        // 스크롤과 관계없이 항상 검색바를 보여줌
        navigationItem.hidesSearchBarWhenScrolling = false

        // Apple Music 느낌: Large Title 비활성화
        navigationController?.navigationBar.prefersLargeTitles = false

        // 검색 프레젠테이션 컨텍스트를 현재 VC로 제한
        definesPresentationContext = true
    }

    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        // query로 결과 필터링/검색 후 UI 업데이트
    }
}
