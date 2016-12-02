//
//  CommentFeedViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 23/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class CommentFeedViewController: UITableViewController {
    
    var presenter: CommentFeedModuleInterface!
    var indicatorView: UIActivityIndicatorView!
    var emptyView: CommentFeedEmptyView!
    
    var shouldShowInitialLoadView: Bool = false {
        didSet {
            guard oldValue != shouldShowInitialLoadView else {
                return
            }
            
            if shouldShowInitialLoadView {
                tableView.backgroundView = indicatorView
                indicatorView.startAnimating()
            } else {
                indicatorView.stopAnimating()
                tableView.backgroundView = nil
            }
        }
    }
    
    var shouldShowEmptyView: Bool = false {
        didSet {
            guard oldValue != shouldShowEmptyView else {
                return
            }
            
            if shouldShowEmptyView {
                emptyView.frame.size = tableView.bounds.size
                tableView.backgroundView = emptyView
            } else {
                tableView.backgroundView = nil
            }
        }
    }
    
    var prototype = CommentListCell()
    
    override func loadView() {
        super.loadView()
        
        indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicatorView.hidesWhenStopped = true
        
        emptyView = CommentFeedEmptyView()
        emptyView.messageLabel.text = "No comments"
        
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        CommentListCell.register(in: tableView)
        
        title = "Comments"
        
        let barItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(self.back))
        navigationItem.leftBarButtonItem = barItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.refreshComments()
    }
    
    func back() {
        presenter.exit()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.commentCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CommentListCell.dequeue(from: tableView)!
        let comment = presenter.comment(at: indexPath.row) as? CommentListCellItem
        cell.configure(with: comment)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let comment = presenter.comment(at: indexPath.row) as? CommentListCellItem
        prototype.configure(with: comment, isPrototype: true)
        return prototype.dynamicHeight
    }
}

extension CommentFeedViewController: CommentFeedScene {
    
    var controller: UIViewController? {
        return self
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    func showEmptyView() {
        shouldShowEmptyView = true
    }
    
    func showInitialLoadView() {
        shouldShowInitialLoadView = true
    }
    
    func hideEmptyView() {
        shouldShowEmptyView = false
    }
    
    func hideInitialLoadView() {
        shouldShowInitialLoadView = false
    }
    
    func didRefreshComments(with error: String?) {

    }
    
    func didLoadMoreComments(with error: String?) {
        
    }
}