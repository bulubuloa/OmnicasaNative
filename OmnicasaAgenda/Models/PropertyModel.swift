//
//  PropertyModel.swift
//  OmnicasaAgenda
//
//  Created by Omnimobile on 12/31/21.
//
/*
 
 {
             "ConstructionType": 0,
             "Id": 6798,
             "IconName": "property.png",
             "PurposeDescNL": "Te Koop",
             "Reference": "Bosstraat 166 Boom",
             "CityName": "Boom",
             "PriceAndUnitNL": "300.000,00 €",
             "StatusDescNL": "Actief",
             "SubStatusDescNL": "WMAND",
             "TypeDescNL": "Huis",
             "Bedrooms": 0,
             "Floor": 0,
             "SurfaceArea": 0.0,
             "TotalArea": 0.0,
             "HasBoard": false,
             "ManagerShortName": "OA",
             "ListingAgent": "OA",
             "ProprietorReference": "2035520.0200646",
             "ProprietorPhones": "+84/91/817.59.04",
             "ProprietorEmails": ",kien@omnicasa.com,omnicasa.kien@gmail.com",
             "Elevel": 0,
             "CO2Emission": 0.0,
             "Street": "Bosstraat",
             "StreetNumber": "166",
             "BoxNr": "1",
             "IsAnnex": false,
             "ProjectId": 0,
             "BuildingId": 0,
             "IsDeleted": false,
             "Price": 300000.0000,
             "PriceUnitId": 1,
             "SubStatusId": 16,
             "ContractTypeId": 0,
             "PictureLargeUrl": "https://cloud-storage.omnicasa.com/private/immovietnam/pic/6798A.jpg?token=eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy91cmkiOiJodHRwczovL2Nsb3VkLXN0b3JhZ2Uub21uaWNhc2EuY29tL3ByaXZhdGUvaW1tb3ZpZXRuYW0vcGljLzY3OThBLmpwZz9leHBpcmVkLWRhdGUtdG9rZW49MjAyMi0wMS0xNVQyMjo1OTo1OS4wMDAwMDAwWiZ3aWR0aD00MDAmaGVpZ2h0PTMwMCIsIm5iZiI6MCwiZXhwIjoxNjQyMjg3NTk5LCJpYXQiOjAsImlzcyI6IldFQkFQSS1JU1NVRVIifQ.E4eg7emNrwj0GNP-eBnU3mBPV8BUZ9NFvLoJ8WLLvwh06NBiSf0vbWy-L8iOVzyIASt-ksimPnDeyrIh_97fnA",
             "PictureXLargeUrl": "https://cloud-storage.omnicasa.com/private/immovietnam/pic/6798A.jpg?token=eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy91cmkiOiJodHRwczovL2Nsb3VkLXN0b3JhZ2Uub21uaWNhc2EuY29tL3ByaXZhdGUvaW1tb3ZpZXRuYW0vcGljLzY3OThBLmpwZz9leHBpcmVkLWRhdGUtdG9rZW49MjAyMi0wMS0xNVQyMjo1OTo1OS4wMDAwMDAwWiZ3aWR0aD0xOTIwJmhlaWdodD0xMjgwIiwibmJmIjowLCJleHAiOjE2NDIyODc1OTksImlhdCI6MCwiaXNzIjoiV0VCQVBJLUlTU1VFUiJ9.umsfAsjAtjv9j4NAdOd54xZMarjjacSS0-rb0WLtB-EtKtzJnq6KUF73FHyRw2wQZB3QJkjpi7gGTpyxlNFFpg",
             "CountPictures": 29
         },
 */
import Foundation

struct PropertyModel : Codable{
    var id: Double
    var cityName: String?
    var priceAndUnitNL: String?
    var reference: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case cityName = "CityName"
        case priceAndUnitNL = "PriceAndUnitNL"
        case reference = "Reference"
    }
}

extension PropertyModel {
    func queryModel() -> QueryModel {
        QueryModel(id: id, name: priceAndUnitNL, reference: reference)
    }
}
