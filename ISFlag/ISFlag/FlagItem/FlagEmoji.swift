// FlagEmoji.swift

import Cocoa

//-----------------------------------------------------------------------------------------------------------------------------------------
struct FlagEmoji {

	static func emojiFlag(from code: String) -> String? {
		if let r = code.range(of: "com.apple.keylayout.") {
			let country = code[r.upperBound...]
			if country == "French" {
				return "🇫🇷"
			}
			if country == "English" {
				return "🇬🇧"
			}
			if country == "US" {
				return "🇺🇸"
			}
			if country == "Russian" {
				return "🇷🇺"
			}
			if country == "German" {
				return "🇩🇪"
			}
			if country == "SwissGerman" {
				return "🇩🇪"
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
