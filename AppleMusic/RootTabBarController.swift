import UIKit

final class RootTabBarController: UITabBarController {
    private let miniPlayer = MiniPlayerView()
    private let miniPlayerHeight: CGFloat = 56

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMiniPlayer()
        setupNotifications()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupMiniPlayer() {
        miniPlayer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(miniPlayer)

        NSLayoutConstraint.activate([
            miniPlayer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            miniPlayer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            miniPlayer.bottomAnchor.constraint(equalTo: tabBar.topAnchor)
        ])

        // 시작은 숨김 상태 (MiniPlayerView 내부에서도 기본 숨김)
        miniPlayer.isHidden = true
    }

    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleStart), name: .playerDidStartPlaying, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleStop), name: .playerDidStop, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePause), name: .playerDidPause, object: nil)
    }

    @objc private func handleStart() {
        showMiniPlayer(animated: true)
    }

    @objc private func handlePause() {
        // 일시정지는 표시 유지
        showMiniPlayer(animated: true)
    }

    @objc private func handleStop() {
        hideMiniPlayer(animated: true)
    }

    private func showMiniPlayer(animated: Bool) {
        guard miniPlayer.isHidden else { return }
        miniPlayer.alpha = 0
        miniPlayer.isHidden = false
        applyBottomInset(miniPlayerHeight)
        if animated {
            UIView.animate(withDuration: 0.25) {
                self.miniPlayer.alpha = 1
            }
        } else {
            miniPlayer.alpha = 1
        }
    }

    private func hideMiniPlayer(animated: Bool) {
        guard !miniPlayer.isHidden else { return }
        let animations = {
            self.miniPlayer.alpha = 0
        }
        let completion: (Bool) -> Void = { _ in
            self.miniPlayer.isHidden = true
            self.applyBottomInset(0)
        }
        if animated {
            UIView.animate(withDuration: 0.25, animations: animations, completion: completion)
        } else {
            animations()
            completion(true)
        }
    }

    private func applyBottomInset(_ inset: CGFloat) {
        // 현재 탭의 모든 VC에 동일한 bottom inset 적용 (스크롤 영역이 미니플레이어에 가리지 않도록)
        if let vcs = viewControllers {
            for vc in vcs {
                vc.additionalSafeAreaInsets.bottom = inset
            }
        } else if let vc = selectedViewController {
            vc.additionalSafeAreaInsets.bottom = inset
        }
    }
}
