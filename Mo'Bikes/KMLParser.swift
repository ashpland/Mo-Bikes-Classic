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

            if let allPlacemarks = xmlDoc.root["Document"]["Folder"]["Placemark"].all {
                for placemark in allPlacemarks {
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
    
    
    
    public func getLines(xmlurl: URL) -> Array<RawBikeway>? {
        
        let xmlData = try? Data(contentsOf: xmlurl)
        
        do {
            var returnArray = [RawBikeway]()
            let xmlDoc = try AEXMLDocument(xml: xmlData!)
            
            if let allPlacemarks = xmlDoc.root["Document"]["Folder"]["Placemark"].all {
                for placemark in allPlacemarks {
                    let descriptionInput = placemark["description"].value!
                    var lineSegments = [String]()
                    
                    if let allLineStrings = placemark["MultiGeometry"]["LineString"].all {
                        
                        for lineString in allLineStrings {
                            lineSegments.append(lineString["coordinates"].value!)
                        }
                    }
                    returnArray.append(RawBikeway(descriptionInput: descriptionInput, lineSegments: lineSegments))
                }
                
            }
            return returnArray
            
        } catch  {
            print("\(error)")
            return nil
        }
    }
    
    public struct RawBikeway {
        var descriptionString : String
        var lineSegmentsArray : Array<String>
        
        init(descriptionInput: String, lineSegments: Array<String>) {
            descriptionString = descriptionInput
            lineSegmentsArray = lineSegments
        }
    }
    
    
}
