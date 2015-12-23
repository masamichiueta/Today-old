//
//  FileManager.swift
//  Today
//
//  Created by UetaMasamichi on 2015/12/23.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import Foundation

class FileManager {
    
    class func getDocumentsURL() -> NSURL {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        return documentsURL
    }
    
    class func fileInDocumentsDirectory(fileName: String) -> String {
        
        let fileURL = getDocumentsURL().URLByAppendingPathComponent(fileName)
        return fileURL.path!
    }
    
    private static let appGroupIdentifier = "group.com.uetamasamichi.todaygroup"
    
    class func getSharedDocumentsURL() -> NSURL {
        let sharedDocumentsURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(self.appGroupIdentifier)
        return sharedDocumentsURL!
    }
    
    class func fileInSharedDocumentsDirectory(fileName: String) -> String {
        let fileURL = getSharedDocumentsURL().URLByAppendingPathComponent(fileName)
        return fileURL.path!
    }
    
}
