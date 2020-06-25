//
//  WORXAPI.swift
//  WORX
//
//  Created by Jaelhorton on 5/21/20.
//  Copyright © 2020 worx. All rights reserved.
//

import Foundation
import Alamofire


class WORXAPI {
    static let sharedInstance = WORXAPI()
    var hostURL = "http://worx.football/"
    var baseURL = "http://worx.football/api"
    
    func getHostURL() -> String {
        return hostURL
    }
    
    func getAPIBaseURL() -> String {
        return baseURL
    }
    
    func login(withEmail email: String, withPassword password: String, withCompletion completion: @escaping (LoginResponse?, Error?) -> Void) {
        let params: Parameters = ["email": email, "password": password]
        
        AF.request("\(getAPIBaseURL())/player/login", method: .post, parameters: params)
            .validate()
            .response { response in
                switch response.result {
                case .success(let data):
                    do {
                        let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data!)
                        //let loginResponse = String(decoding: data!, as: UTF8.self)
                        // debugPrint("Parsed login response: \(loginResponse)")
                        completion(loginResponse, nil)
                    } catch let error {
                        debugPrint("Login Error: \(error)")
                        completion(nil, error)
                    }
                case .failure(let error):
                    debugPrint("Login Error: \(error)")
                    completion(nil, error)
                }
            }
    }
    func register(withEmail email: String, withPassword password: String, withFirstName firstname: String, withLastName lastname: String, withBirthday birthday: String, withPhoto photo: String, withCompletion completion: @escaping (LoginResponse?, Error?) -> Void) {
        let params: Parameters = ["email": email, "password": password, "first_name": firstname, "last_name": lastname, "birthday": birthday, "photo": photo]
        
        AF.request("\(getAPIBaseURL())/player/register", method: .post, parameters: params)
            .validate()
            .response { response in
                switch response.result {
                case .success(let data):
                    do {
                        let registerResponse = try JSONDecoder().decode(LoginResponse.self, from: data!)
                        // debugPrint("Parsed register response: \(registerResponse)")
                        completion(registerResponse, nil)
                    } catch let error {
                        debugPrint("Register Error: \(error)")
                        completion(nil, error)
                    }
                case .failure(let error):
                    debugPrint("Register Error: \(error)")
                    completion(nil, error)
                }
            }
    }
    func fetchMatchList(start_time: String, latitude: Double, longitude: Double, radius: Int, withCompletion completion: @escaping (MatchResponse?, Error?) -> Void) {
        let params: Parameters = ["start_time": start_time, "latitude": latitude, "longitude": longitude, "radius": radius]
//        let params: Parameters = ["start_time": start_time, "latitude": 53.2535714, "longitude": -1.4257437, "radius": 640000]
        let url = "\(getAPIBaseURL())/matches/get"
        AF.request(url, method: .post, parameters: params)
            .validate()
            .response { response in
                switch response.result {
                case .success(let data):
                    do {
                        let messageResponse = try JSONDecoder().decode(MatchResponse.self, from: data!)
                        // debugPrint("Parsed register response: \(registerResponse)")
                        completion(messageResponse, nil)
                    } catch let error {
                        debugPrint("Fetching Matches Error: \(error)")
                        completion(nil, error)
                    }
                case .failure(let error):
                    debugPrint("Fetching Matches Error: \(error)")
                    completion(nil, error)
                }
            }
    }
    func getPlayerInfo(user_id: Int, withCompletion completion: @escaping (LoginResponse?, Error?) -> Void) {
        let params: Parameters = ["player_id": user_id]
        let url = "\(getAPIBaseURL())/player/info"
        AF.request(url, method: .post, parameters: params)
            .validate()
            .response { response in
                switch response.result {
                case .success(let data):
                    do {
                        let messageResponse = try JSONDecoder().decode(LoginResponse.self, from: data!)
                        // debugPrint("Parsed register response: \(registerResponse)")
                        completion(messageResponse, nil)
                    } catch let error {
                        debugPrint("Get PlayerInfo Error: \(error)")
                        completion(nil, error)
                    }
                case .failure(let error):
                    debugPrint("Get PlayerInfo Error: \(error)")
                    completion(nil, error)
                }
            }
    }
    func transactionHistory(user_id: Int, withCompletion completion: @escaping (TransactionResponse?, Error?) -> Void) {
        let params: Parameters = ["player_id": user_id]
        let url = "\(getAPIBaseURL())/transactions/get"
        AF.request(url, method: .post, parameters: params)
            .validate()
            .response { response in
                switch response.result {
                case .success(let data):
                    do {
                        let messageResponse = try JSONDecoder().decode(TransactionResponse.self, from: data!)
                        // debugPrint("Parsed register response: \(registerResponse)")
                        completion(messageResponse, nil)
                    } catch let error {
                        debugPrint("Get Transactions Error: \(error)")
                        completion(nil, error)
                    }
                case .failure(let error):
                    debugPrint("Get Transactions Error: \(error)")
                    completion(nil, error)
                }
            }
    }
    func deleteAccount(user_id: Int, content: String, withCompletion completion: @escaping (WorxResponse?, Error?) -> Void) {
        let params: Parameters = ["player_id": user_id, "content": content]
        let url = "\(getAPIBaseURL())/player/delete"
        AF.request(url, method: .post, parameters: params)
            .validate()
            .response { response in
                switch response.result {
                case .success(let data):
                    do {
                        let messageResponse = try JSONDecoder().decode(WorxResponse.self, from: data!)
                        // debugPrint("Parsed register response: \(registerResponse)")
                        completion(messageResponse, nil)
                    } catch let error {
                        debugPrint("Deleting Account Error: \(error)")
                        completion(nil, error)
                    }
                case .failure(let error):
                    debugPrint("Deleting Account Error: \(error)")
                    completion(nil, error)
                }
            }
    }
    func sendFeedback(user_id: Int, type: Int, content: String, withCompletion completion: @escaping (WorxResponse?, Error?) -> Void) {
        let params: Parameters = ["player_id": user_id, "type": type, "content": content]
        let url = "\(getAPIBaseURL())/activity/setFeedback"
        AF.request(url, method: .post, parameters: params)
            .validate()
            .response { response in
                switch response.result {
                case .success(let data):
                    do {
                        let messageResponse = try JSONDecoder().decode(WorxResponse.self, from: data!)
                        // debugPrint("Parsed register response: \(registerResponse)")
                        completion(messageResponse, nil)
                    } catch let error {
                        debugPrint("Sending Feedback Error: \(error)")
                        completion(nil, error)
                    }
                case .failure(let error):
                    debugPrint("Sending Feedback Error: \(error)")
                    completion(nil, error)
                }
            }
    }
    func bookPlace(user_id: Int, match_id: Int, withCompletion completion: @escaping (WorxResponse?, Error?) -> Void) {
        let params: Parameters = ["player_id": user_id, "match_id": match_id]
        let url = "\(getAPIBaseURL())/booking/reserve"
        AF.request(url, method: .post, parameters: params)
            .validate()
            .response { response in
                switch response.result {
                case .success(let data):
                    do {
                        let messageResponse = try JSONDecoder().decode(WorxResponse.self, from: data!)
                        // debugPrint("Parsed register response: \(registerResponse)")
                        completion(messageResponse, nil)
                    } catch let error {
                        debugPrint("Book Place Error: \(error)")
                        completion(nil, error)
                    }
                case .failure(let error):
                    debugPrint("Book Place Error: \(error)")
                    completion(nil, error)
                }
            }
    }
    func purchasePayment(user_id: Int, cardNumber: String, expiryMonth: Int, expiryYear: Int, cardCVC: String, amount: String, withCompletion completion: @escaping (WorxResponse?, Error?) -> Void) {
        let params: Parameters = ["player_id": user_id, "card_name": "VISA Card", "card_number": cardNumber, "card_cvc": cardCVC, "card_month": expiryMonth, "card_year": expiryYear, "amount": amount]
        let url = "\(getAPIBaseURL())/payment/pay"
        AF.request(url, method: .post, parameters: params)
            .validate()
            .response { response in
                switch response.result {
                case .success(let data):
                    do {
                        let messageResponse = try JSONDecoder().decode(WorxResponse.self, from: data!)
                        // debugPrint("Parsed register response: \(registerResponse)")
                        completion(messageResponse, nil)
                    } catch let error {
                        debugPrint("Purchase Payment Error: \(error)")
                        completion(nil, error)
                    }
                case .failure(let error):
                    debugPrint("Purchase Payment Error: \(error)")
                    completion(nil, error)
                }
            }
    }

    // MARK: - get auth header
    /*
    func getAuthHeader() -> HTTPHeaders {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(AuthManager.sharedInstance.accessToken)"]
        return headers
    }
    */
    
}
