import UIKit

final class MiniPlayerView: UIControl {
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
    private let vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: UIBlurEffect(style: .systemMaterial)))

    private let artworkImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    private let backButton = UIButton(type: .system)
    private let playPauseButton = UIButton(type: .system)
    private let nextButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = .clear
        layer.cornerRadius = 16
        layer.masksToBounds = true

        blurView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(blurView)
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        blurView.contentView.addSubview(vibrancyView)
        NSLayoutConstraint.activate([
            vibrancyView.topAnchor.constraint(equalTo: blurView.contentView.topAnchor),
            vibrancyView.bottomAnchor.constraint(equalTo: blurView.contentView.bottomAnchor),
            vibrancyView.leadingAnchor.constraint(equalTo: blurView.contentView.leadingAnchor),
            vibrancyView.trailingAnchor.constraint(equalTo: blurView.contentView.trailingAnchor)
        ])

        // Artwork
        artworkImageView.translatesAutoresizingMaskIntoConstraints = false
        artworkImageView.contentMode = .scaleAspectFill
        artworkImageView.layer.cornerRadius = 8
        artworkImageView.clipsToBounds = true
        artworkImageView.backgroundColor = .tertiarySystemFill

        // Labels
        titleLabel.font = .preferredFont(forTextStyle: .subheadline)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        subtitleLabel.font = .preferredFont(forTextStyle: .caption1)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 1
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Controls
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        backButton.setImage(UIImage(systemName: "backward.fill", withConfiguration: symbolConfig), for: .normal)
        nextButton.setImage(UIImage(systemName: "forward.fill", withConfiguration: symbolConfig), for: .normal)
        playPauseButton.setImage(UIImage(systemName: "pause.fill", withConfiguration: symbolConfig), for: .normal)

        [backButton, playPauseButton, nextButton].forEach {
            $0.tintColor = .label
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)

        // Layout
        let controlsStack = UIStackView(arrangedSubviews: [backButton, playPauseButton, nextButton])
        controlsStack.axis = .horizontal
        controlsStack.alignment = .center
        controlsStack.spacing = 12
        controlsStack.translatesAutoresizingMaskIntoConstraints = false

        let labelsStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        labelsStack.axis = .vertical
        labelsStack.alignment = .fill
        labelsStack.spacing = 2
        labelsStack.translatesAutoresizingMaskIntoConstraints = false

        vibrancyView.contentView.addSubview(artworkImageView)
        vibrancyView.contentView.addSubview(labelsStack)
        vibrancyView.contentView.addSubview(controlsStack)

        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        let g = layoutMarginsGuide

        let artworkSide: CGFloat = 44
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 64),

            artworkImageView.leadingAnchor.constraint(equalTo: g.leadingAnchor),
            artworkImageView.centerYAnchor.constraint(equalTo: g.centerYAnchor),
            artworkImageView.widthAnchor.constraint(equalToConstant: artworkSide),
            artworkImageView.heightAnchor.constraint(equalToConstant: artworkSide),

            labelsStack.leadingAnchor.constraint(equalTo: artworkImageView.trailingAnchor, constant: 10),
            labelsStack.centerYAnchor.constraint(equalTo: g.centerYAnchor),

            controlsStack.trailingAnchor.constraint(equalTo: g.trailingAnchor),
            controlsStack.centerYAnchor.constraint(equalTo: g.centerYAnchor),

            labelsStack.trailingAnchor.constraint(lessThanOrEqualTo: controlsStack.leadingAnchor, constant: -10)
        ])

        isHidden = true

        NotificationCenter.default.addObserver(self, selector: #selector(handleStart), name: .playerDidStartPlaying, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePause), name: .playerDidPause, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleStop), name: .playerDidStop, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleMetadataUpdate(_:)), name: .miniPlayerMetadataUpdate, object: nil)
    }

    @objc private func didTapPlayPause() {
        PlayerManager.shared.togglePlayPause()
        updatePlayPauseIcon()
    }

    @objc private func handleStart() {
        isHidden = false
        updatePlayPauseIcon()
    }

    @objc private func handlePause() {
        updatePlayPauseIcon()
    }

    @objc private func handleStop() {
        isHidden = true
    }

    @objc private func handleMetadataUpdate(_ note: Notification) {
        if let title = note.userInfo?["title"] as? String {
            titleLabel.text = title
        }
        if let artist = note.userInfo?["artist"] as? String {
            subtitleLabel.text = artist
        }
        if let artwork = note.userInfo?["artwork"] as? UIImage {
            artworkImageView.image = artwork
        }
    }

    private func updatePlayPauseIcon() {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        if PlayerManager.shared.isPlaying {
            playPauseButton.setImage(UIImage(systemName: "pause.fill", withConfiguration: symbolConfig), for: .normal)
        } else {
            playPauseButton.setImage(UIImage(systemName: "play.fill", withConfiguration: symbolConfig), for: .normal)
        }
    }
}
