//
//  FirebaseController.swift
//  MealHack
//
//  Created by Chun Long Fong on 21/4/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class FirebaseController: NSObject, DatabaseProtocol {

    var database: Firestore

    override init() {
        FirebaseApp.configure()
        database = Firestore.firestore()
        super.init()
    }

    func cleanup() {

    }

}
