// FlagEmoji.swift

import Cocoa

//-----------------------------------------------------------------------------------------------------------------------------------------
struct FlagEmoji {

	static func emojiFlag(from code: String) -> String? {
		if let r = code.range(of: "com.apple.keylayout.") {
			let country = code[r.upperBound...]
			if country == "French" {
				return "π«π·"
			}
			if country == "English" {
				return "π¬π§"
			}
			if country == "US" {
				return "πΊπΈ"
			}
			if country == "Russian" {
				return "π·πΊ"
			}
			if country == "German" {
				return "π©πͺ"
			}
			if country == "SwissGerman" {
				return "π©πͺ"
			}

		}
		return nil
	}

	static func iconFlag(from code: String?) -> NSImage? {
		guard let code = code, let flag = emojiFlag(from: code)
		else {
			return nil
		}

		let img = NSImage(size: NSSize(16.0, 16.0))
		img.lockFocus()
			flag.draw(at: NSPoint(0.0, 0.0), withAttributes: nil)
		img.unlockFocus()

		return img
	}

}
//-----------------------------------------------------------------------------------------------------------------------------------------
