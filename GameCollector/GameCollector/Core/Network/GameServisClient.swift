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
    
    static func getGameList(searchText: String?, genreId: Int?, page: Int = 1, pageSize: Int = 15, ordering: String?, completion: @escaping ([GameModel]?, Error?) -> Void) {
        let urlString = BASE_URL + "/games"
        var parameters: Parameters = ["key": Constants.API_KEY, "page": page, "page_size":pageSize]
        if let searchText = searchText {
            parameters ["search"] = searchText
        }
        if let genreId = genreId {
            parameters ["genres"] = genreId
        }
        if let ordering = ordering {
            parameters ["ordering"] = ordering
        }
        handleResponse(urlString: urlString, parameters: parameters, responseType: GetGamesResponseModel.self) { responseModel, error in
            completion(responseModel?.results, error)
        }
    }
    
    static func fetchGenres(page: Int, pageSize: Int, completion: @escaping ([GenreModel]?, Error?) -> Void) {
        var urlString = BASE_URL + "/genres"
        let parameters: Parameters = ["key": Constants.API_KEY, "page": page, "page_size":pageSize]
        handleResponse(urlString: urlString, parameters: parameters, responseType: GetGengersResponseModel.self) { responseModel, error in
            completion(responseModel?.results, error)
        }
    }
 
    
    static private func handleResponse<T: Decodable>(urlString: String, parameters:Parameters?, responseType: T.Type, completion: @escaping (T?, Error?) -> Void) {
        print("bakalı\(urlString) \(parameters)")
        AF.request(urlString,parameters: parameters).response { response in
            guard let data = response.value else {
                DispatchQueue.main.async {
                    completion(nil, response.error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(T.self, from: data!)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }
            catch {
                print("baksdawa\(error)")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
}
