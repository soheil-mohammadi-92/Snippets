//
//  NetworkManager
//  NetworkingDemo
//
//  Created by Soheil Mohammadi on 2022-10-28.
//

import Foundation

struct Results: Decodable{
    var id: String {
        return code
    }
    let code: String
    let product: Product
    
    enum CodingKeys: String, CodingKey {
            case code, product
        }
}


struct Product: Decodable, Identifiable {
    let id: String
    let keywords: [String]
    let brands: String
    let brandsTags: [String]
    let categories: String
    let countries: String
    let countriesHierarchy: [String]
    let nutriments: Nutriments
    let productName: String
    let productQuantity: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case keywords = "_keywords"
        case brands
        case brandsTags = "brands_tags"
        case categories
        case countries
        case countriesHierarchy = "countries_hierarchy"
        case nutriments
        case productName = "product_name"
        case productQuantity = "product_quantity"
    }
}

struct Nutriments: Decodable{
    let carbohydrates100G: Double
    let energyKcal100G: Double
    let fat100G: Double
    let proteins100G: Double
    
    
    enum CodingKeys: String, CodingKey {
        case carbohydrates100G = "carbohydrates_100g"
        case energyKcal100G = "energy-kcal_100g"
        case fat100G = "fat_100g"
        case proteins100G = "proteins_100g"
    }
}



@MainActor class NetworkManager: ObservableObject {
    
    @Published var products = [Product]()
  
    var tempProduct: Product?
    
    func fetchData(barcode: String){
        if let url = URL(string: "https://world.openfoodfacts.org/api/v0/product/" + barcode){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error == nil {
                    let decoder = JSONDecoder()
                    if let safeData = data {
                        do {
                           let results = try decoder.decode(Results.self, from: safeData)
                            DispatchQueue.main.async{
                                self.tempProduct = results.product
                                self.products.append(results.product)
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        }
        
    }
}
