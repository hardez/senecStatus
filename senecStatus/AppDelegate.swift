//
//  AppDelegate.swift
//  senecStatus
//
//  Created by Marco Eckhardt on 05.11.20.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let popOver = NSPopover()
    


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if let button = self.statusBarItem.button{
            button.image = NSImage(named: "sun")
            button.action = #selector(AppDelegate.toggleSenecView(sender:))
            
        }
        
        popOver.contentViewController = senecView.loadFromNib()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func toggleSenecView(sender: NSStatusBarButton){
        if popOver.isShown{
            popOver.performClose(sender)
        } else {
            if let button = statusBarItem.button{
                popOver.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                
            }
        }
    }


}

