//
//  SearchViewModel.swift
//  gitSample
//
//  Created by admin on 2021/08/07.
//

import RxSwift
import RxCocoa
protocol SearchViewModelDelegate: AnyObject {
    func onUpdateData(result: Bool)
}

class SearchViewModel {
    weak var delegate: SearchViewModelDelegate?

    private var startIndex = DEFAULT_SEARCH_PAGE
    private var searchKeyword = ""
    private var disposeBag = DisposeBag()
    private var searchResponse = SearchModel()

    func getIsEnd() -> Bool {
        return searchResponse.items?.count ?? 0 > searchResponse.total_count ?? 0
    }

    func itemCount() -> Int {
        return self.searchResponse.items?.count ?? 0
    }

    func title(_ index: Int) -> String {
        return self.searchResponse.items?[index].name ?? ""
    }

    func description(_ index: Int) -> String {
        return self.searchResponse.items?[index].description ?? ""
    }

    func language(_ index: Int) -> String {
        return self.searchResponse.items?[index].language ?? ""
    }

    func stargazers_count(_ index: Int) -> Int {
        return self.searchResponse.items?[index].stargazers_count ?? 0
    }

    func forks_count(_ index: Int) -> Int {
        return self.searchResponse.items?[index].forks_count ?? 0
    }
}

extension SearchViewModel {
    func fetchSearch(_ keyword: String) {
        if keyword.isEmpty {
            startIndex += 1
        } else {
            searchKeyword = keyword
            startIndex = DEFAULT_SEARCH_PAGE
            self.searchResponse.items?.removeAll()
        }

        var parameters: [String: Any] = [:]
        parameters["q"] = searchKeyword
        parameters["page"] = startIndex
        parameters["per_page"] = DEFAULT_SEARCH_SIZE
        APIManager.requestWithName(API_URL, method: .get, parameters: parameters, responseType: SearchModel.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if let total_count = response.total_count {
                    self.searchResponse.total_count = total_count
                }

                if let incomplete_results = response.incomplete_results {
                    self.searchResponse.incomplete_results = incomplete_results
                }

                if let items = response.items, items.count > 0 {
                    if self.searchResponse.items != nil && self.searchResponse.items?.count ?? 0 > 0 {
                        self.searchResponse.items?.append(contentsOf: items)
                    } else {
                        self.searchResponse.items = items
                    }
                }

                self.delegate?.onUpdateData(result: self.searchResponse.items?.count ?? 0 > 0 )
            case .failure(let error):
                self.delegate?.onUpdateData(result: false)
                switch error {
                case .failWithResponse(let res):
                    Utils.presentAlert(title: res.message, message: res.message, handler: nil)
                case .failWithMessage(let msg):
                    Utils.presentAlert(title: "알림", message: msg, handler: nil)
                }
            }
        }
    }
}
