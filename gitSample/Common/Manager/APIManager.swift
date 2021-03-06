//
//  APIManager.swift
//  gitSample
//
//  Created by admin on 2021/08/07.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

class APIManager: NSObject {
    typealias APIResponse<T> = Swift.Result<T, APIError>

    enum APIError: Error {
        case failWithResponse(CommonModel)
        case failWithMessage(String)
    }

    static public func requestWithName<T: Decodable>(_ requestUrl: String, method: HTTPMethod, parameters: [String: Any]?, responseType: T.Type, response: @escaping (APIResponse<T>) -> Void) {
        let url = URL(string: requestUrl)
        var hTTPHeaders = HTTPHeaders()

        let manager = Session.default
        manager.session.configuration.timeoutIntervalForRequest = 30

        hTTPHeaders["Accept"] = "application/vnd.github.v3+json"
        hTTPHeaders["Authorization"] = GIT_REST_API_KEY

        manager.request(url!, method: method, parameters: parameters, encoding: URLEncoding.default, headers: hTTPHeaders).validate(statusCode: 200..<300).responseJSON { (responseData) in
            DispatchQueue.main.async {
                do {
                    switch responseData.result {
                    case .success(let successData):
                        let data = try JSONSerialization.data(withJSONObject: successData, options: .prettyPrinted)
                        LOG("JSON: \(String(decoding: data, as: UTF8.self))")
                        let object = try JSONDecoder().decode(responseType, from: data)
                        response(.success(object))
                    case .failure(let error):
                        if let responseBody = responseData.data {
                            let object = try JSONDecoder().decode(CommonModel.self, from: responseBody)
                            throw APIError.failWithResponse(object)
                        } else {
                            throw error
                        }
                    }
                } catch let error {
                    if let apiError = APIManager.errorHandler(error) {
                        response(.failure(apiError))
                    } else {
                        return
                    }
                }
            }
        }
    }

    /// API ?????? ??????
    static private func errorHandler(_ error: Error) -> APIError? {
        switch error {
        case APIError.failWithResponse(var object):
            if let message = object.message {
                object.message = message
            } else {
                object.message = "???????????? ????????? ?????????????????????. ?????? ?????? ?????? ?????????????????? ????????????."
            }
            return APIError.failWithResponse(object)
        case DecodingError.typeMismatch(_, let context), DecodingError.dataCorrupted(let context):
            let message = "\(context.codingPath)\n\(context.debugDescription)"
            return APIError.failWithMessage(message)
        default:
            let message = error.localizedDescription
            let code = (error as NSError).code

            guard code != NSURLErrorCancelled else {
                return nil
            }

            switch error.asAFError {
            case .explicitlyCancelled:
                return nil
            case .sessionTaskFailed:
                Utils.presentAlert(title: "??????", message: "???????????? ?????? ?????? ??????.", handler: nil)
                return nil
            default:
                return APIError.failWithMessage(message)
            }
        }
    }
}
