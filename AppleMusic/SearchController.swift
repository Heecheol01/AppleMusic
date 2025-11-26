//
//  Search.swift
//  AppleMusic
//
//  Created by 김희철 on 11/23/25.
//

import UIKit
import Speech
import AVFoundation
import Foundation

struct ITunesResponse: Decodable {
    let resultCount: Int
    let results: [Track]
}

struct Track: Decodable {
    let trackName: String?
    let artistName: String?
    let previewUrl: String?
    let artworkUrl100: String?
}

class SearchController: UIViewController, UISearchBarDelegate {

    private let searchController = UISearchController()
    private var currentTask: URLSessionDataTask?

    override func viewDidLoad() {
        super.viewDidLoad()
//         Do any additional setup after loading the view.
        configureSearch()
    }

    private func configureSearch() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Apple Music"

        navigationItem.searchController = searchController

        navigationItem.hidesSearchBarWhenScrolling = false

        navigationController?.navigationBar.prefersLargeTitles = false

        definesPresentationContext = true
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 키보드 내리기
        searchBar.resignFirstResponder()
        
        print("엔터 버튼")

        let query = searchBar.text ?? ""
        let (title, artist) = parseTitleAndArtist(from: query)

        // 유효성 검사: 제목/가수 둘 다 비어있으면 요청하지 않음
        if (title?.isEmpty ?? true) && (artist?.isEmpty ?? true) {
            presentSimpleAlert(title: "검색어가 없습니다", message: "제목 또는 가수를 입력해 주세요.")
            return
        }

        // iTunes API 요청
        searchITunesOnce(title: title, artist: artist)
    }

    private func parseTitleAndArtist(from query: String) -> (title: String?, artist: String?) {
        let parsed = query.components(separatedBy: ", ")
        if parsed.count < 1 { return (nil, nil) }
        let title = parsed[0]
        let singer = parsed[1]
        return (title, singer)
    }
    
    private func searchITunesOnce(title: String?, artist: String?) {
        // 진행 중인 요청이 있으면 취소 (선택)
        currentTask?.cancel()
        
        print("searchITunesOnce")

        // term 구성: "제목 가수" 형태로 합치기
        let combinedTerm: String = [title, artist]
            .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: " ")
        
        print("combindeTerm: \(combinedTerm)")

        guard !combinedTerm.isEmpty else { return }

        var components = URLComponents(string: "https://itunes.apple.com/search")!
        components.queryItems = [
            URLQueryItem(name: "term", value: combinedTerm),
            URLQueryItem(name: "entity", value: "song"),
            URLQueryItem(name: "limit", value: "1"),
        ]

        guard let url = components.url else { return }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }

            if let error = error as NSError?, error.code == NSURLErrorCancelled {
                // 취소된 요청은 무시
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.presentSimpleAlert(title: "오류", message: "네트워크 응답이 없습니다.")
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(ITunesResponse.self, from: data)
                let track = decoded.results.first

                DispatchQueue.main.async {
                    if let track = track {
                        self.presentPlayAlert(for: track)
                    } else {
                        self.presentSimpleAlert(title: "결과 없음", message: "일치하는 노래를 찾지 못했습니다.")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.presentSimpleAlert(title: "오류", message: "결과를 해석하는 도중 문제가 발생했습니다.")
                }
            }
        }
        currentTask = task
        task.resume()
    }
    
    private func presentPlayAlert(for track: Track) {
        let title = track.trackName ?? "알 수 없는 제목"
        let artist = track.artistName ?? "알 수 없는 가수"

        let alert = UIAlertController(
            title: "노래를 찾았습니다",
            message: "\(artist) - \(title)\n재생할까요?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "재생", style: .default, handler: { [weak self] _ in
            if let urlString = track.previewUrl, let url = URL(string: urlString) {
                PlayerManager.shared.play(url: url)
                NotificationCenter.default.post(name: .miniPlayerMetadataUpdate, object: nil, userInfo: [
                    "title": title,
                    "artist": artist as Any
                ])
            } else {
                self?.presentSimpleAlert(title: "재생 불가", message: "미리듣기 URL이 없습니다.")
            }
        }))

        present(alert, animated: true, completion: nil)
    }

    private func presentSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

