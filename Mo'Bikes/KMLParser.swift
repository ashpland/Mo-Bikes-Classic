//
//  KMLParser.swift
//  Mo'Bikes
//
//  Created by Andrew on 2017-10-31.
//  Copyright © 2017 hearthedge. All rights reserved.
//

import UIKit
import AEXML

class KMLParser: NSObject {
    let fountainsKML = Bundle.main.url(forResource: "drinking_fountains", withExtension: "kml")
    let washroomsKML = Bundle.main.url(forResource: "public_washrooms", withExtension: "kml")
    
//    let fountainsData = try? Data()
    
    public func KMLTest() {
        
        let xmlData = try? Data(contentsOf: fountainsKML!)
        
        do {
            let xmlDoc = try AEXMLDocument(xml: xmlData!)
//            print(xmlDoc.xml)
            
            
            for child in xmlDoc.root.children {
                print(child.name)
            }
            
            
            
        } catch  {
            print("\(error)")
        }
    
    }
    
    
    
    
    
    

    


}
