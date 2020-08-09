//
//  AppDelegate.swift
//  MusicMenuBar
//
//  Created by Evan Swanson on 8/9/20.
//  Copyright © 2020 Evan Swanson. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let musicItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var error: NSDictionary?
    
    @objc func reloadSongView(){
        musicItem.button!.title = executeAndReturnString()
    }
    
    func executeAndReturnString() -> String {
        if let scriptObject=NSAppleScript(source: """
        tell application "Music"
            if player state is playing then
                return ((name of current track) & " - " & (artist of current track))
            else
                return "Paused"
            end if
        end tell
        """){
            if let outputString = scriptObject.executeAndReturnError(&error).stringValue {
                return outputString
            }
        }
        return "An error occurred."
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        if let button = musicItem.button {
            button.title = executeAndReturnString()
        }
        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(reloadSongView), userInfo: nil, repeats: true)
    }
}

