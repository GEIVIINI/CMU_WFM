//
//  News.swift
//  CMU_WFM
//
//  Created by Methawin on 7/4/2563 BE.
//  Copyright © 2563 Methawin. All rights reserved.
//

import Foundation

class News: NSObject, NSCoding {
  
    var newsId: String?
    var newsType: String?
    var source: String?
    var nameTH: String?
    var nameEN: String?
    var startDate: String?
    var endDate: String?
    var descriptionTH: String?
    var descriptionEN: String?
    var disabled: String?
    var link: String?
    var coverImage: String?
    var list: String?
    var crDate: String?
    var coverImageLink: String?
    var allViews: String?
    
    func toDictionary() -> NSDictionary{
        return [
            "newsId": newsId as Any,
            "newsType": newsType as Any,
            "source": source as Any,
            "nameTH": nameTH as Any,
            "nameEN": nameEN as Any,
            "startDate": startDate as Any,
            "endDate": endDate as Any,
            "descriptionTH": descriptionTH as Any,
            "descriptionEN": descriptionEN as Any,
            "disabled": disabled as Any,
            "link": link as Any,
            "coverImage": coverImage as Any,
            "list": list as Any,
            "crDate": crDate as Any,
            "coverImageLink": coverImageLink as Any,
            "allViews": allViews as Any,
        ]
    }
    
    override init() {
    }
    
    init(jsonDict:NSDictionary) {
        newsId = jsonDict.object(forKey: "newsId") as? String
        newsType = jsonDict.object(forKey: "newsType") as? String
        source = jsonDict.object(forKey: "source") as? String
        nameTH = jsonDict.object(forKey: "nameTH") as? String
        nameEN = jsonDict.object(forKey: "nameEN") as? String
        startDate = jsonDict.object(forKey: "startDate") as? String
        endDate = jsonDict.object(forKey: "endDate") as? String
        descriptionTH = jsonDict.object(forKey: "descriptionTH") as? String
        descriptionEN = jsonDict.object(forKey: "descriptionEN") as? String
        disabled = jsonDict.object(forKey: "disabled") as? String
        link = jsonDict.object(forKey: "link") as? String
        coverImage = jsonDict.object(forKey: "coverImage") as? String
        list = jsonDict.object(forKey: "list") as? String
        crDate = jsonDict.object(forKey: "crDate") as? String
        coverImageLink = jsonDict.object(forKey: "coverImageLink") as? String
        allViews = (jsonDict.object(forKey: "allViews") as? String)!
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(newsId, forKey: "newsId")
        aCoder.encode(newsType, forKey: "newsType")
        aCoder.encode(source, forKey: "source")
        aCoder.encode(nameTH, forKey: "nameTH")
        aCoder.encode(nameEN, forKey: "nameEN")
        aCoder.encode(startDate, forKey: "startDate")
        aCoder.encode(endDate, forKey: "endDate")
        aCoder.encode(descriptionTH, forKey: "descriptionTH")
        aCoder.encode(descriptionEN, forKey: "descriptionEN")
        aCoder.encode(disabled, forKey: "disabled")
        aCoder.encode(link, forKey: "link")
        aCoder.encode(coverImage, forKey: "coverImage")
        aCoder.encode(list, forKey: "list")
        aCoder.encode(crDate, forKey: "crDate")
        aCoder.encode(coverImageLink, forKey: "coverImageLink")
        aCoder.encode(allViews, forKey: "allViews")
    }
    
    required init?(coder aDecoder: NSCoder) {
        newsId = aDecoder.decodeObject(forKey: "newsId") as? String
        newsType = aDecoder.decodeObject(forKey: "newsType") as? String
        source = aDecoder.decodeObject(forKey: "source") as? String
        nameTH = aDecoder.decodeObject(forKey: "nameTH") as? String
        nameEN = aDecoder.decodeObject(forKey: "nameEN") as? String
        startDate = aDecoder.decodeObject(forKey: "startDate") as? String
        endDate = aDecoder.decodeObject(forKey: "endDate") as? String
        descriptionTH = aDecoder.decodeObject(forKey: "descriptionTH") as? String
        descriptionEN = aDecoder.decodeObject(forKey: "descriptionEN") as? String
        disabled = aDecoder.decodeObject(forKey: "disabled") as? String
        link = aDecoder.decodeObject(forKey: "link") as? String
        coverImage = aDecoder.decodeObject(forKey: "coverImage") as? String
        list = aDecoder.decodeObject(forKey: "list") as? String
        crDate = aDecoder.decodeObject(forKey: "crDate") as? String
        coverImageLink = aDecoder.decodeObject(forKey: "coverImageLink") as? String
        allViews = aDecoder.decodeObject(forKey: "allViews") as? String
    }
    
}
