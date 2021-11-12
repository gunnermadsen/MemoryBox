//
//  MemoryBoxApp.swift
//  MemoryBox
//
//  Created by gunner madsen on 11/11/21.
//

import SwiftUI

@main
struct MemoryBoxApp: App {
    
    let fileSystemManager = FileSystemManager()

    init() {
        let key = "AlbumList"
        let defaults = UserDefaults.standard
        
        if defaults.object(forKey: key) == nil {
            // reset the UserDefaults on startup
            defaults.removeObject(forKey: key)
            defaults.set(Array<String>(), forKey: key)
        }

        do {
            try fileSystemManager.createLibraryDirectory()
            try fileSystemManager.eraseDirectoryContentsOnStartup()
        }
        catch {
            print(error)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            AlbumView()
        }
    }
}
