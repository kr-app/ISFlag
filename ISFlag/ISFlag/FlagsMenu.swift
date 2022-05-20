// FlagsMenu.swift

import Cocoa

//--------------------------------------------------------------------------------------------------------------------------------------------
class FlagsMenu: NSObject, NSMenuDelegate {

	static let shared = FlagsMenu()

	private(set) var menu: NSMenu!

	override init() {
		super.init()
		menu = NSMenu(title: nil, delegate: self, autoenablesItems: false)
	}

	func menuNeedsUpdate(_ menu: NSMenu) {
		menu.removeAllItems()

		let sources = FlagSourceManager.shared.sources()

		for source in sources.filter( { $0.isKeyboardInputSource }) {
			let title = source.locName ?? source.identifier ?? "?"
			let menuItem = THMenuItem(title: title, block: { () in
				FlagSourceManager.shared.setSource(source, selected: true)
			})
			menuItem.state = source.selected == true ? .on : .off
			menuItem.image = FlagEmoji.iconFlag(from: source.identifier!)
			menu.addItem(menuItem)
		}

		menu.addItem(NSMenuItem.separator())

		if let palette = sources.first(where: { $0.identifier == "com.apple.CharacterPaletteIM" }) {
			let selected = palette.selected == true
			let menuItem = THMenuItem(title: selected ? THLocalizedString("Hide Emoji & Symbols") : THLocalizedString("Show Emoji & Symbols"), block: { () in
				FlagSourceManager.shared.setSource(palette, selected: !selected)
			})
			menuItem.state = selected ? .on : .off
			menu.addItem(menuItem)
		}

		if let palette = sources.first(where: { $0.identifier == "com.apple.PressAndHold" }) {
			let menuItem = THMenuItem(title: THLocalizedString("Show Keyboard Viewer"), block: { () in
				FlagSourceManager.shared.setSource(palette, selected: true)
			})
			menu.addItem(menuItem)
		}

		if menu.th_lastItem()?.isSeparatorItem == false {
			menu.addItem(NSMenuItem.separator())
		}

		let menuItem = THMenuItem(title: THLocalizedString("Preserve Keyboard Layout by app"), block: { () in

		})
		menu.addItem(menuItem)

		menu.addItem(NSMenuItem.separator())

		menu.addItem(THMenuItem(title: THLocalizedString("Open Keyboard Preferences…"), block: { () in
			let prefPane = "/System/Library/PreferencePanes/Keyboard.prefPane"
			if FileManager.default.fileExists(atPath: prefPane) {
				NSWorkspace.shared.open(URL(fileURLWithPath: prefPane))
			}
		}))
	}

}
//--------------------------------------------------------------------------------------------------------------------------------------------
