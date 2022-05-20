// FlagSourceManager.swift

import Cocoa
import Carbon
import InputMethodKit

//-----------------------------------------------------------------------------------------------------------------------------------------
class FlagSourceManager {
	static let selectedSourceChangedNotification = Notification.Name("FlagSourceManager-selectedSourceChangedNotification")
	static let shared = FlagSourceManager()

	init() {
		DistributedNotificationCenter.default.addObserver(self, selector: #selector(n_selectedKeyboardInputSourceChanged), name: NSNotification.Name(kTISNotifySelectedKeyboardInputSourceChanged as String), object: nil)
	}

	// MARK: -

	@objc private func n_selectedKeyboardInputSourceChanged(_ notification: Notification) {
		THLogInfo("notification:\(notification)")
		NotificationCenter.default.post(name: Self.selectedSourceChangedNotification, object: self, userInfo: nil)
	}

	// MARK: -

	func selectedSources() -> FlagSource {
		let inputSource = TISCopyCurrentKeyboardInputSource().takeRetainedValue()
		return FlagSource(inputSource: inputSource)
	}

	func sources() -> [FlagSource] {
		let inputSources = (TISCreateInputSourceList(nil, false).takeRetainedValue() as NSArray) as! [TISInputSource]
		let sources = inputSources.map( { FlagSource(inputSource: $0) })

		THLogDebug("sources:\(sources as NSArray)")
		return sources
	}

	@discardableResult func setSource(_ source: FlagSource, selected: Bool) -> Bool {
		let err = selected ? TISSelectInputSource(source.inputSource) : TISDeselectInputSource(source.inputSource)
		if err == noErr {
			return true
		}
		THLogError("can not select/deselect source:\(source), selected:\(selected), err:\(err)")
		return false
	}

}
//-----------------------------------------------------------------------------------------------------------------------------------------
