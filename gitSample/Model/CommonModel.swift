//
//  CommonModel.swift
//  gitSample
//
//  Created by admin on 2021/08/07.
//

struct CommonModel: BaseModel {
    var message:String?
    var errors:Errors?
    var documentation_url:String?
   
    struct Errors: Codable {
        var resource:String?
        var field:String?
        var code:String?
    }
}
