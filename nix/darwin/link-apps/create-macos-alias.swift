#!/usr/bin/env swift

// Create an alias file ("bookmark88" format).  Note that although Finder treats
// this like a symlink, it is different.
//
// Equivalent to:
// osascript -e "tell application "Finder" to make new alias at POSIX file \"${dest}\" to POSIX file \"${src}\""


import Foundation

var src: String?
var dest: String?

if CommandLine.argc < 3 {
    print("Expected two arguments: src and dest.")
    exit(1)
} else {
    src = CommandLine.arguments[1]
    dest = CommandLine.arguments[2]
}

let url = URL(fileURLWithPath: src!)
let aliasUrl = URL(fileURLWithPath: dest!)

do {
    let data = try url.bookmarkData(options: .suitableForBookmarkFile, includingResourceValuesForKeys: nil, relativeTo: nil)
    try URL.writeBookmarkData(data, to: aliasUrl)
} catch {
    print("Unexpected error: \(error).")
    exit(1)
}
