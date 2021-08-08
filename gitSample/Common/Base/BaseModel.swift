//
//  BaseModel.swift
//  gitSample
//
//  Created by admin on 2021/08/07.
//

import Foundation
protocol BaseModel: Codable {

}

extension BaseModel {
    func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            return String(data: jsonData, encoding: .utf8)
        } else {
            return nil
        }
    }
}
