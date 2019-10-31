//
//  EmojiCollectionViewController.swift
//  tipTester
//
//  Created by Marlon Raskin on 10/31/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class EmojiCollectionViewController: UIViewController {

	@IBOutlet private weak var emojiCollectionView: UICollectionView!
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var blurView: UIView!

	let layer = CAGradientLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
		emojiCollectionView.delegate = self
		emojiCollectionView.dataSource = self
		isModalInPresentation = true
		let blurEffect = UIBlurEffect(style: .regular)
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
		blurEffectView.frame = blurView.bounds
		blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		blurView.addSubview(blurEffectView)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

	@IBAction func saveEmojiSet(_ sender: UIBarButtonItem) {

	}

	@IBAction func cancelTapped(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}

	let emojiArray = Array("""
		😏😐😌🤓🤬🥳🤪😁😃😞🤢😆😁😉🤣☺️😍😛😋🤨🤓😎🤩😔😕🙁☹️😖😩🥺😤🤔🤗😬🙄🤮😡😶😐😑🤭🤤🥴\
		👺😈👿👹🤡💩👻💀👽👾🤖🎃😺😼😾😻🙌👏👍👎🤘👌🖖🤙🖕💋👄👀👅🤷‍♀️🤷‍♂️🕺💃👑🕶👓🐶🐱🐭🐹🐰🦊🐻\
		🐼🐨🐯🦁🐮🐷🐽🐸🐵🐒🐔🦆🦅🦖🦕🐙🐠🐬🐳🦈🐋🐊🐅🦍🐘🦏🐕🦌🐄🐉🐿🦚🦜🐲🌵🌲🎄🌴🌱🍀🍂🌺🌸\
		🌻🌞🌝🌚💥💫🌎⭐️✨⚡️🔥🌪🌈🍻🥂🍴🍽🥢🥇🥈🥉🏅🏆🎗🎫🎟🎪🛫🚀🛰🎢🏖🚨🚔📺📸📷💾💿📻🎙📡💵\
		💸💴💶💷💰💳💣🧨🔫🚬🧻🚽🧼🗝🔑🎊🎉📍📌🆗🆒1️⃣2️⃣3️⃣4️⃣5️⃣6️⃣7️⃣8️⃣9️⃣🔟✅✳️❎💯🚫❌🆘🛑❗️❕❓❔\
		‼️⁉️🎶🎵☑️✔️📢📣🏁🏳️
		""").map { String($0) }

}

extension EmojiCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return emojiArray.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let emojiCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath) as? EmojiCollectionViewCell else { return UICollectionViewCell() }

		let emoji = emojiArray[indexPath.item]

		emojiCell.emojiLabel.text = emoji

		return emojiCell
	}
}
