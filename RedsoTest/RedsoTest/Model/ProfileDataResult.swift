//
//	ProfileDataResult.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyJSON

enum Type :String{
    case employee
    case banner
}


struct ProfileDataResult{

	var avatar : String!
	var expertise : [String] = []
	var id : String!
	var name : String!
	var position : String!
	var type : Type!
	var url : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromJson json: JSON){
        avatar = json["avatar"].stringValue
        if let stringArray = json["expertise"].arrayObject{
         expertise = stringArray as! [String]
        }
        id = json["id"].stringValue
        name = json["name"].stringValue
        position = json["position"].stringValue
        type = Type(rawValue: json["type"].stringValue)
        url = json["url"].stringValue 
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if avatar != nil{
			dictionary["avatar"] = avatar
		}
//		if expertise != nil{
			dictionary["expertise"] = expertise
//		}
		if id != nil{
			dictionary["id"] = id
		}
		if name != nil{
			dictionary["name"] = name
		}
		if position != nil{
			dictionary["position"] = position
		}
		if type != nil{
			dictionary["type"] = type
		}
		if url != nil{
			dictionary["url"] = url
		}
		return dictionary
	}
    func expertiseString()->String{
        var result = ""
        for expertise in self.expertise {
            result  = result + expertise + " "
        }
        return result
    }
}
