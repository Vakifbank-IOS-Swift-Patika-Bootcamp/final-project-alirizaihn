//
//  GameServisClient.swift
//  GameCollector
//
//  Created by Ali Rıza İLHAN on 11.12.2022.
//

import Foundation
import Alamofire

final class GameServisClient {
    static let BASE_URL = "https://api.rawg.io/api"
    
    static func getGameList(completion: @escaping ([GameModel]?, Error?) -> Void) {
        let urlString = BASE_URL + "/games" + "?key=" + Constants.API_KEY + "&page=1&page_size=15"
        handleResponse(urlString: urlString, responseType: GetGamesResponseModel.self) { responseModel, error in
            completion(responseModel?.results, error)
        }
    }
    
    static private func handleResponse<T: Decodable>(urlString: String, responseType: T.Type, completion: @escaping (T?, Error?) -> Void) {
        AF.request(urlString).response { response in
            guard let data = response.value else {
                DispatchQueue.main.async {
                    completion(nil, response.error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(T.self, from: data!)
                print("fada\(responseObject)")
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }
            catch {
                print("fada2\(error)")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
}
