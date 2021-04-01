all:
	swift build -Xswiftc -target -Xswiftc x86_64-apple-macosx10.11
	swift-api-extract -F `pwd`/.bild/x86_64-apple-macosx/debug/ -sdk `xcrun --show-sdk-path` `pwd`/.build/x86_64-apple-macosx/debug/Sample.swiftmodule  -module-name Sample -pretty-print

