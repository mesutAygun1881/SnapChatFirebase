//
//  UserSingleton.swift
//  SnapChatFirebase
//
//  Created by mesutAygun on 29.03.2021.
//

import Foundation

class UserSingleton {
    
    static let sharedUserInfo = UserSingleton()
    
    var email = ""
    var username = ""
    
    
    private init() {
        
        
    }
}
