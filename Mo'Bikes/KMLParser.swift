//
//  KMLParser.swift
//  Mo'Bikes
//
//  Created by Andrew on 2017-10-31.
//  Copyright © 2017 hearthedge. All rights reserved.
//

import AEXML

class KMLParser: NSObject {
    static let sharedInstance = KMLParser();
    
    public func getPoints(xmlurl: URL) -> Array<String>? {
        
        let xmlData = try? Data(contentsOf: xmlurl)
        
        do {
            var returnArray = [String]()
            let xmlDoc = try AEXMLDocument(xml: xmlData!)

            if let testOutput = xmlDoc.root["Document"]["Folder"]["Placemark"].all {
                for placemark in testOutput {
                    let coordinateString = placemark["Point"]["coordinates"].value
                    returnArray.append(coordinateString!)
                }
            }
            return returnArray

        } catch  {
            print("\(error)")
            return nil
        }
    }
}
