//
//  PersonModel.swift
//  OmnicasaAgenda
//
//  Created by Omnimobile on 12/31/21.
//

/*
 
 {
           "ViewType": 0,
           "Id": 208159,
           "IconName": "person.png",
           "AddressTitle": "Mr.",
           "Name": "DSWDS",
           "FirstName": "dsd22222222",
           "Reference": "DSWDS dsd",
           "CategoriesDesc": "SERVICE",
           "Email": "dsd@gmail.com",
           "PhoneNumber1": "0909888777",
           "CompanyName": "OMNICASA SOFTWARE SOLUTIONS",
           "ManagerShortName": "TA2",
           "LetterTitle": "Dear Sir",
           "StatusNameNL": "Actief",
           "SiteName": "Agence A",
           "IDCardNumber": "506-4315134-36",
           "Password": "1O7&W7z5G",
           "CompanyId": 36,
           "IsDeleted": false
       },
 */
import Foundation

struct PersonModel : Codable {
    var id: Double
    var name: String?
    var firstName: String?
    var reference: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case firstName = "FirstName"
        case reference = "Reference"
    }
}

extension PersonModel {
    func queryModel() -> QueryModel {
        QueryModel(id: id, name: firstName, reference: reference)
    }
}
