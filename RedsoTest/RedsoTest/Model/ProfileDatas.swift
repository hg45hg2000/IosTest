//
//	ProfileDatas.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyJSON
import UIKit

struct ProfileData : Codable{

	var results : [ProfileDataResult]!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		results = [ProfileDataResult]()
		if let resultsArray = dictionary["results"] as? [[String:Any]]{
			for dic in resultsArray{
                let json = JSON(dic)
				let value = ProfileDataResult(fromJson: json)
				results.append(value)
			}
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if results != nil{
			var dictionaryElements = [[String:Any]]()
			for resultsElement in results {
				dictionaryElements.append(resultsElement.toDictionary())
			}
			dictionary["results"] = dictionaryElements
		}
		return dictionary
	}
    
}
/// Objects conforming to `CanSaveToDisk` have a save method and provide keys for saving individual objects or a list of objects.
protocol CanSaveToDisk: Codable {

    /// Provide default logic for encoding this value.
    static var defaultEncoder: JSONEncoder { get }

    /// This key is used to save the individual object to disk. This works best by using a unique identifier.
    var storageKeyForObject: String { get }

    /// This key is used to save a list of these objects to disk. Any array of items conforming to `CanSaveToDisk` has the option to save as well.
    static var storageKeyForListofObjects: String { get }

    /// Persists the object to disk.
    ///
    /// - Throws: useful to throw an error from an encoder or a custom error if you use stage different from user defaults like the keychain
    func save() throws

}
extension Array where Element: CanSaveToDisk {

    func dataValue() throws -> Data {
        return try Element.defaultEncoder.encode(self)
    }

    func save() throws {
        let storage = UserDefaults.standard
        storage.set(try dataValue(), forKey: Element.storageKeyForListofObjects)
    }

}

extension ProfileData: CanSaveToDisk {

    static var defaultEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        // add additional customization here
        // like dates or data handling
        return encoder
    }

    var storageKeyForObject: String {
        // "com.myapp.patient.123"
        return "com.myapp.patient.123"
    }

    static var storageKeyForListofObjects: String {
        return "com.myapp.patientList"
    }

    func save() throws {

        // you could also save to the keychain easily
        //let keychain = KeychainSwift()
        //keychain.set(dataObject, forKey: storageKeyForObject)

        let data = try ProfileData.defaultEncoder.encode(self)
        let storage = UserDefaults.standard
        storage.setValue(data, forKey: storageKeyForObject)
    }
    func localData () -> ProfileData! {
        do {
            let storage = UserDefaults.standard
            let data = storage.object(forKey: storageKeyForObject)
            let result = try  JSONDecoder().decode(ProfileData.self, from: data as! Data)
            return result
        } catch { print(error) }
        return nil
    }
}
