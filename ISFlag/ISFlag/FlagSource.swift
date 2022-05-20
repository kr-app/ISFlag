// FlagSource.swift

import Cocoa
import Carbon
import InputMethodKit

//-----------------------------------------------------------------------------------------------------------------------------------------
class FlagSource: NSObject {

	var inputSource: TISInputSource!

	var identifier: String?
	var locName: String?
	var type: String?
	var category: String?
	var selected: Bool?
	var selectable: Bool?

	var isKeyboardInputSource: Bool { self.category == (kTISCategoryKeyboardInputSource as String) }

	private func getProperty(source: TISInputSource, key: CFString) -> AnyObject? {
		guard let cfType = TISGetInputSourceProperty(source, key)
		else {
			return nil
		}
		return Unmanaged<AnyObject>.fromOpaque(cfType).takeUnretainedValue()
	}

	init(inputSource source: TISInputSource) {
		super.init()

		self.inputSource = source

		self.identifier = getProperty(source: source, key: kTISPropertyInputSourceID) as? String
		self.locName = getProperty(source: source, key: kTISPropertyLocalizedName) as? String
		self.type = getProperty(source: source, key: kTISPropertyInputSourceType) as? String
		self.category = getProperty(source: source, key: kTISPropertyInputSourceCategory) as? String
		self.selected = getProperty(source: source, key:  kTISPropertyInputSourceIsSelected) as? Bool
		self.selectable = getProperty(source: source, key:  kTISPropertyInputSourceIsSelectCapable) as? Bool
//		return getProperty(kTISPropertyInputSourceLanguages) as! [String]
	}

	override var description: String {
		th_description("identifier:\(identifier) type:\(type) category:\(category) locName: \(locName) selected: \(selected) selectable:\(selectable)")
	}

}
//-----------------------------------------------------------------------------------------------------------------------------------------
