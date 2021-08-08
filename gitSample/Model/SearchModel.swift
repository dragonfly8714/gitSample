//
//  SearchModel.swift
//  gitSample
//
//  Created by admin on 2021/08/07.
//

struct SearchModel: BaseModel {
    var total_count: Int?
    var incomplete_results: Bool?
    var items: [Search]?
}

struct Search: Codable {
    var name:String?
    var description:String?
    var language:String?
    var stargazers_count:Int?
    var forks_count:Int?
    var html_url:String?
}
