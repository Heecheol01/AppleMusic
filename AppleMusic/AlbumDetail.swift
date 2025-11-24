//
//  AlbumDetail.swift
//  AppleMusic
//
//  Created by 김희철 on 11/24/25.
//

import UIKit
import AVFoundation

class AlbumDetail: UITableViewController {
    
    var bad = ["Bad Dreams"]
    var hanroro = ["이상비행", "해초", "화해", "금붕어", "자처", "사랑하게 될 거야"]
    var tour = ["Some Things I'll Never Know", "Lose Control", "What More Can I Say", "The Door", "Goodbye's Been Good to You", "Last Communion", "You Still Get to Me", "SuitCase", "Flame", "Evergreen"]
    var apartment = ["Apartment", "섬으로 가요 (Feat. 오혁)", "그저 그런 날", "Lost 2 (Feat.선우정아)", "Home Sweet Home", "444", "젊은 꿈", "Beyond (feat. O3ohn)", "갈게", "Blue Blue", "Mother", "Together"]
    var jamong = ["내일에서 온 티켓", "용의자", "갈림길", "0+0", "__에게", "시간을 달리네", "도망"]
    var harmony = ["harmony", "네 번의 여름", "내일의 우리", "내겐 그 아무도 없을 거야", "Foolish World", "My Old Friend"]
    
    var collectionName: String?
    var titleText: String?
    var image: UIImage?
    var singer: String?
    var album: [String] = []
    
    @IBOutlet var tableListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableListView.dataSource = self
        tableListView.delegate = self
        
        let key = titleText?.lowercased()
        switch key {
        case "bad dreams": album = bad
        case "이상비행": album = hanroro
        case "i've tried everything but therapy": album = tour
        case "apartment": album = apartment
        case "자몽살구클럽": album = jamong
        case "harmony": album = harmony
        default: album = []
        }
        
        configureTableHeader()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlePlayerStart), name: .playerDidStartPlaying, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePlayerStop), name: .playerDidStop, object: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return album.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Song", for: indexPath)
        
        let text = album[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = "\(indexPath.row + 1) \t\(text)"
        
        return cell
    }
    
    // https://www.youtube.com/watch?v=8QZygWsfyzk
    private func configureTableHeader() {
        let container = UIView()

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        let collectionLabel = UILabel()
        collectionLabel.textAlignment = .center
        collectionLabel.font = .preferredFont(forTextStyle: .title1)
        collectionLabel.text = collectionName
        collectionLabel.numberOfLines = 0

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.font = .preferredFont(forTextStyle: .title2)
        titleLabel.text = titleText
        titleLabel.numberOfLines = 0

        let singerLabel = UILabel()
        singerLabel.textAlignment = .center
        singerLabel.textColor = .secondaryLabel
        singerLabel.font = .preferredFont(forTextStyle: .subheadline)
        singerLabel.text = singer
        singerLabel.numberOfLines = 0
        
        let buttonsStack = UIStackView()
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 20
        buttonsStack.alignment = .fill
        buttonsStack.distribution = .fillEqually
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false

        let playButton = UIButton(type: .system)
        let shuffleButton = UIButton(type: .system)
        
        var playConfig = UIButton.Configuration.tinted()
        playConfig.title = "재생"
        playConfig.image = UIImage(systemName: "play.fill")
        playConfig.baseBackgroundColor = .lightGray
        playConfig.imagePadding = 6
        playConfig.cornerStyle = .capsule
        playButton.configuration = playConfig
        playButton.tintColor = .red
        playButton.addTarget(self, action: #selector(didTapPlay), for: .touchUpInside)

        var shuffleConfig = UIButton.Configuration.tinted()
        shuffleConfig.title = "셔플"
        shuffleConfig.image = UIImage(systemName: "shuffle")
        shuffleConfig.baseBackgroundColor = .lightGray
        shuffleConfig.imagePadding = 6
        shuffleConfig.cornerStyle = .capsule
        shuffleButton.configuration = shuffleConfig
        shuffleButton.tintColor = .red

        buttonsStack.addArrangedSubview(playButton)
        buttonsStack.addArrangedSubview(shuffleButton)

        [collectionLabel, imageView, titleLabel, singerLabel, buttonsStack].forEach { stack.addArrangedSubview($0) }
        
        stack.setCustomSpacing(16, after: singerLabel)
        
        let bottomSpacer = UIView()
        bottomSpacer.translatesAutoresizingMaskIntoConstraints = false
        bottomSpacer.heightAnchor.constraint(equalToConstant: 20).isActive = true
        stack.addArrangedSubview(bottomSpacer)

        container.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            stack.topAnchor.constraint(equalTo: container.topAnchor),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            buttonsStack.leadingAnchor.constraint(equalTo: stack.leadingAnchor, constant: 16),
            buttonsStack.trailingAnchor.constraint(equalTo: stack.trailingAnchor, constant: -16)
        ])

        playButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        shuffleButton.heightAnchor.constraint(equalTo: playButton.heightAnchor).isActive = true

        if let img = imageView.image {
            imageView.heightAnchor.constraint(
                equalTo: imageView.widthAnchor,
                multiplier: img.size.height / img.size.width
            ).isActive = true
        }

        let targetSize = CGSize(width: tableView.bounds.width, height: UIView.layoutFittingCompressedSize.height)
        let height = container.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height

        container.frame = CGRect(origin: .zero, size: CGSize(width: tableView.bounds.width, height: height))
        tableView.tableHeaderView = container
    }
    
    private func showMiniPlayer(in tableView: UITableView, miniPlayerHeight: CGFloat = 64) {
        var inset = tableView.contentInset
        inset.bottom = max(inset.bottom, miniPlayerHeight + 8)
        tableView.contentInset = inset

        var indicatorInset = tableView.scrollIndicatorInsets
        indicatorInset.bottom = max(indicatorInset.bottom, miniPlayerHeight + 8)
        tableView.scrollIndicatorInsets = indicatorInset
    }
    
    @objc private func handlePlayerStart() {
        // 미니 플레이어 높이와 여백에 맞게 조정
        showMiniPlayer(in: tableListView, miniPlayerHeight: 64)
    }

    @objc private func handlePlayerStop() {
        // 숨길 때는 복원(필요하면 복원 함수 따로 만들어 원래 값 저장/복구)
        tableListView.contentInset.bottom = 0
        tableListView.scrollIndicatorInsets.bottom = 0
    }
    
    private struct ITunesSearchResponse: Decodable {
        let resultCount: Int
        let results: [ITunesTrack]
    }

    private struct ITunesTrack: Decodable {
        let trackName: String?
        let artistName: String?
        let collectionName: String?
        let artworkUrl100: String?
        let previewUrl: String?
    }
    
    private func searchPreviewURLITunes(term: String, artist: String? = nil, country: String = "KR", limit: Int = 5) async throws -> URL? {
        let q = term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? term
        let urlString = "https://itunes.apple.com/search?term=\(q)&entity=song&country=\(country)&limit=\(limit)"
        guard let url = URL(string: urlString) else { return nil }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try? JSONDecoder().decode(ITunesSearchResponse.self, from: data)
        guard let response = decoded, response.resultCount > 0 else { return nil }

        // 우선 아티스트가 일치하는 결과에서 previewUrl을 찾음
        if let artist = artist?.lowercased() {
            if let match = response.results.first(where: { res in
                guard let ra = res.artistName?.lowercased() else { return false }
                return ra.contains(artist)
            })?.previewUrl, let u = URL(string: match) {
                return u
            }
        }

        // 없으면 첫 결과의 previewUrl 사용
        if let first = response.results.first?.previewUrl, let u = URL(string: first) {
            return u
        }
        return nil
    }
    
    @MainActor
    private func playPreviewFromITunes(title: String, artist: String?) async {
        do {
            let term = [title, artist].compactMap { $0 }.joined(separator: " ")
            guard let previewURL = try await searchPreviewURLITunes(term: term, artist: artist) else {
                print("iTunes preview URL을 찾을 수 없습니다.")
                return
            }
            PlayerManager.shared.play(url: previewURL)
            NotificationCenter.default.post(name: .miniPlayerMetadataUpdate, object: nil, userInfo: [
                "title": title,
                "artist": artist as Any,
                "artwork": self.image!
            ])
            print("미리듣기 재생 시작: \(previewURL.absoluteString)")
        } catch {
            print("iTunes 미리듣기 재생 실패: \(error)")
        }
    }
    
    @objc private func didTapPlay() {
        Task { [weak self] in
            guard let self else { return }
            // iTunes 미리듣기 우선
            if let first = self.album.first {
                await self.playPreviewFromITunes(title: first, artist: self.singer)
            } else if let title = self.titleText {
                await self.playPreviewFromITunes(title: title, artist: self.singer)
            } else {
                print("재생할 곡 정보를 찾을 수 없습니다.")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedTitle = album[indexPath.row]
        Task { [weak self] in
            guard let self else { return }
            await self.playPreviewFromITunes(title: selectedTitle, artist: self.singer)
        }
    }
}

