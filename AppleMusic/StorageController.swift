//
//  StorageController.swift
//  AppleMusic
//
//  Created by 김희철 on 11/23/25.
//

import UIKit

class StorageController: UITableViewController {
    
    @IBOutlet var stack1: UIStackView!
    @IBOutlet var stack2: UIStackView!
    @IBOutlet var stack3: UIStackView!
    @IBOutlet var stack4: UIStackView!
    @IBOutlet var stack5: UIStackView!
    @IBOutlet var stack6: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        [stack1, stack2, stack3, stack4, stack5, stack6].enumerated().forEach { (idx, stack) in
            guard let stack = stack else { return }
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleStackTap(_:)))
            stack.isUserInteractionEnabled = true
            stack.addGestureRecognizer(tap)
            stack.tag = idx
        }
    }
    
    @objc private func handleStackTap(_ gesture: UITapGestureRecognizer) {
        guard let tappedStack = gesture.view as? UIStackView else { return }
        let id = "\(tappedStack.tag)"
        let labelText = findLabelText(in: tappedStack, restorationID: id)
        performSegue(withIdentifier: "ShowDetail", sender: labelText)
    }
    
    private func findLabel(in view: UIView) -> UILabel? {
        if let label = view as? UILabel { return label }
        for sub in view.subviews {
            if let l = findLabel(in: sub) { return l }
        }
        return nil
    }
    
    private func findLabelText(in view: UIView, restorationID: String) -> String? {
        if let label = view as? UILabel, label.restorationIdentifier == restorationID {
            return label.text
        }
        for sub in view.subviews {
            if let text = findLabelText(in: sub, restorationID: restorationID) {
                return text
            }
        }
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail",
           let dest = segue.destination as? AlbumDetail,
           let title = sender as? String {
            DummyData.shared.albums.forEach { album in
                if album.title == title {
                    dest.titleText = album.title
                    dest.collectionName = ""
                    dest.singer = album.singer
                    dest.image = album.image
                    return
                }
            }
        }
    }

}
