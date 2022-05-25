// PreferencesWindowController.swift

import Cocoa

//--------------------------------------------------------------------------------------------------------------------------------------------
class AppISMenuCellView: NSTableCellView {
	@IBOutlet var popMenu: NSPopUpButton!
}
//--------------------------------------------------------------------------------------------------------------------------------------------


//--------------------------------------------------------------------------------------------------------------------------------------------
fileprivate struct AppObjectItem {
	let app: NSRunningApplication
	let title: String
	let path: String
}
//--------------------------------------------------------------------------------------------------------------------------------------------


//--------------------------------------------------------------------------------------------------------------------------------------------
class PreferencesWindowController : NSWindowController, NSWindowDelegate,
																	THHotKeyFieldViewChangeObserverProtocol,
																	NSTableViewDataSource, NSTableViewDelegate {

	static let shared = PreferencesWindowController(windowNibName: "PreferencesWindowController")

	@IBOutlet var relaunchOnLoginButton: NSButton!
	@IBOutlet var hotKeyButton: NSButton!
	@IBOutlet var hotKeyField: THHotKeyFieldView!

	@IBOutlet var tableView: NSTableView!

	private var appObjectItems: [AppObjectItem]?
	private var flagSources: [FlagSource]?

	override func windowDidLoad() {
		super.windowDidLoad()
	
		self.window!.title = THLocalizedString("ISFlag Preferences")

		let hotKey = THHotKeyRepresentation.init(fromUserDefaultsWithTag: 1)
		hotKeyButton.state = (hotKey != nil && hotKey!.isEnabled == true) ? .on : .off
		hotKeyField.setControlSize(hotKeyButton.controlSize)
		hotKeyField.setChangeObserver(	self,
																keyCode: hotKey?.keyCode ?? 0,
																modifierFlags: hotKey?.modifierFlags ?? 0,
																isEnabled: hotKey?.isEnabled ?? false)

		updateUIApps()
	}
	
	// MARK: -

	func windowDidBecomeMain(_ notification: Notification) {
		updateUILoginItem()
		updateUIApps()
	}

	// MARK: -

	private func updateUILoginItem() {
		relaunchOnLoginButton.state = THAppInLoginItem.loginItemStatus()
	}

	private func updateUIApps() {
		let apps = NSWorkspace.shared.runningApplications

		var appObjectItems = [AppObjectItem]()
		for app in apps.filter( { $0.isAgentOrBackgroundApplication() == false }) {
			let title = app.localizedName ?? app.bundleIdentifier!
			let path = app.bundleURL!.path
			appObjectItems.append(AppObjectItem(app: app, title: title, path: path))
		}

		self.flagSources = FlagSourceManager.shared.sources().filter({ $0.isKeyboardInputSource } )
		self.appObjectItems = appObjectItems

		tableView.reloadData()
	}

	// MARK: -

	func numberOfRows(in tableView: NSTableView) -> Int {
		return appObjectItems?.count ?? 0
	}

	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

		let appObjectItem = appObjectItems![row]

		if tableColumn?.identifier.rawValue == "inputSource_tc" {
			let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "inputSource_cell_id"), owner: self) as! AppISMenuCellView
			cell.popMenu.removeAllItems()

			if let menu = cell.popMenu.menu {
				menu.addItem(THMenuItem(title: THLocalizedString("--"), block: { () in
				}))
				menu.addItem(NSMenuItem.separator())

				for source in flagSources! {
					menu.addItem(THMenuItem(title: source.locName ?? source.identifier!, block: { () in
					}))
				}
			}

			return cell
		}

		let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "app_cell_id"), owner: self) as! NSTableCellView
		cell.imageView?.image = NSWorkspace.shared.icon(forFile: appObjectItem.path)
		cell.textField?.stringValue = appObjectItem.title

		return cell
	}

	func tableViewSelectionDidChange(_ notification: Notification) {
	}

//	func menuNeedsUpdate(_ menu: NSMenu) {
//		menu.removeAllItems()
//
//		let row = tableView.clickedRow
//		let object = row == -1 ? nil : objectList![row]
//
//		guard let object = object, let channel = object.channel
//		else {
//			return
//		}
//
//		menu.addItem(THMenuItem(title: THLocalizedString("Reveal in Finder"), block: {() in
//			ChannelManager.managerOfChannel(channel)?.revealFile(channel: channel.identifier)
//		}))
//
//		menu.addItem(NSMenuItem.separator())
//
//		menu.addItem(THMenuItem(title: THLocalizedString("Remove"), block: {() in
//			self.removeObject(object)
//		}))
//	}

//	@IBAction func tableViewAction(_ sender: NSTableView) {
//		let row = self.tableView.selectedRow
//
//		let object = row == -1 ? nil : objectList![row]
//		let channel = object?.channel
//
//		UserDefaults.standard.set(ChannelManager.managerOfChannel(channel)?.pathOfChannel(channel), forKey: "selected")
//	}

	// MARK: -
	
	@IBAction func relaunchOnLoginButtonAction(_ sender: NSButton) {
		THAppInLoginItem.setIsLoginItem(sender.state == .on)
		updateUILoginItem()
	}

	@IBAction func hotKeyButtonAction(_ sender: NSButton) {
		self.hotKeyField.setIsEnabled(sender.state == .on)
	}

	// MARK: -

	@objc func hotKeyFieldView(_ sender: THHotKeyFieldView!, didChangeWithKeyCode keyCode: UInt, modifierFlags: UInt, isEnabled: Bool) -> Bool {
		THHotKeyRepresentation(keyCode: keyCode, modifierFlags: modifierFlags, isEnabled: isEnabled).saveToUserDefaults(withTag: 1)
		if isEnabled {
			return THHotKeyCenter.shared().registerHotKey(withKeyCode: keyCode, modifierFlags: modifierFlags, tag: 1)
		}
		return THHotKeyCenter.shared().unregisterHotKey(withTag: 1)
	}

}
//--------------------------------------------------------------------------------------------------------------------------------------------
