//  AppDelegate.swift

import Cocoa

//-----------------------------------------------------------------------------------------------------------------------------------------
@main
class AppDelegate: NSObject, NSApplicationDelegate {

	private let statusIcon = StatusIcon()

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		if THAppInLoginItem.loginItemStatus() != .on {
			THAppInLoginItem.setIsLoginItem(true)
		}

		statusIcon.updateIcon()
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

	func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
		return true
	}

}
//-----------------------------------------------------------------------------------------------------------------------------------------
