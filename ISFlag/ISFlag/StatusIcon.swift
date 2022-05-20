// StatusIcon.swift

import Cocoa

//--------------------------------------------------------------------------------------------------------------------------------------------
class StatusIcon: NSObject {

	var barItem: NSStatusItem!
	//var statusItemWindow: NSWindow? { get { barItem.button!.window } }

	override init() {
		super.init()
		self.barItem = NSStatusBar.system.statusItem(withLength: -1)
		NotificationCenter.default.addObserver(self, selector: #selector(n_selectedSourceChanged), name: FlagSourceManager.selectedSourceChangedNotification, object: nil)
	}

	// MARK: -

	@objc private func n_selectedSourceChanged(_ notification: Notification) {
		updateIcon()
	}
	
	func updateIcon() {
		let source = FlagSourceManager.shared.selectedSources()

		if let flag = FlagEmoji.iconFlag(from: source.identifier) {
			barItem.button!.image = flag
		}
		else {
			barItem.button!.image = nil
			barItem.button!.title = source.locName ?? source.identifier ?? source.description
		}

		barItem.menu = FlagsMenu.shared.menu
	}

}
//--------------------------------------------------------------------------------------------------------------------------------------------
