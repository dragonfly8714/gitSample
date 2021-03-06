//
//  SearchViewController.swift
//  gitSample
//
//  Created by admin on 2021/08/07.
//

import RxSwift
import RxCocoa

class SearchViewController: BaseUIViewController {
    @IBOutlet var mSearchTableView: UITableView!
    @IBOutlet var mSearchNoneView: UIView!
    @IBOutlet var mSearchBar: UISearchBar!

    private var mSearchViewModel = SearchViewModel()
    private let mDisposeBag = DisposeBag()
    private var mIsLoadFetch = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setKeyboardNotification(scrollView: mSearchTableView)
        mSearchTableView.delegate = self
        mSearchTableView.dataSource = self
        mSearchTableView.register(UINib(nibName: "SearchItemCell", bundle: nil), forCellReuseIdentifier: "SearchItemCell")

        mSearchViewModel.delegate = self
        mSearchBar
            .rx.text
            .orEmpty
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { keyword in
                if !keyword.isEmpty {
                    self.mSearchViewModel.fetchSearch(keyword)
                }
            })
            .disposed(by: mDisposeBag)
    }
}

// MARK: - SearchViewModelDelegate
extension SearchViewController: SearchViewModelDelegate {
    internal func onUpdateData(result: Bool) {
        mIsLoadFetch = !mSearchViewModel.getIsEnd()
        mSearchTableView.reloadData()

        mSearchNoneView.isHidden = result
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mSearchViewModel.itemCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchItemCell") as? SearchItemCell {
            cell.lbTitle.text = mSearchViewModel.title(indexPath.row)
            cell.lbDescription.text = mSearchViewModel.description(indexPath.row)
            cell.lbLanguage.text = mSearchViewModel.language(indexPath.row)
            cell.lbStarCnt.text = String(mSearchViewModel.stargazers_count(indexPath.row))
            cell.lbForkCnt.text = String(mSearchViewModel.forks_count(indexPath.row))
            return cell
        } else {
            return UITableViewCell()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.height && !self.mSearchViewModel.getIsEnd() && self.mIsLoadFetch {
            self.mIsLoadFetch = false
            self.mSearchViewModel.fetchSearch("")
        }
    }
}
