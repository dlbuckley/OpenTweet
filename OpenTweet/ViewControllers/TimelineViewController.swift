//
//  ViewController.swift
//  OpenTweet
//
//  Created by Olivier Larivain on 9/30/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import UIKit

final class TimelineViewController: UIViewController {

    // MARK: Properties

    let viewModel: TimelineViewModel

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()

    private lazy var dataSource: UITableViewDiffableDataSource<TimelineSection, Tweet> = {

        return UITableViewDiffableDataSource<TimelineSection, Tweet>(tableView: tableView) { [unowned self] tableView, indexPath, tweet in

            guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetCell.Identifier, for: indexPath) as? TweetCell else {
                fatalError("\(TweetCell.self) has not been registered.")
            }

            cell.configure(with: tweet, dateFormatter: self.dateFormatter)

            return cell
        }
    }()

    // MARK: Subviews

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.accessibilityIdentifier = "table_view"
        tableView.register(TweetCell.self, forCellReuseIdentifier: TweetCell.Identifier)
        return tableView
    }()

    // MARK: Initialisers

    init(viewModel: TimelineViewModel) {

        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

        tableView.dataSource = dataSource

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        loadTimeline()
	}

    // MARK: Actions

    private func loadTimeline() {

        Task {
            let tweets = try await viewModel.loadTimeline()

            var snapshot = NSDiffableDataSourceSnapshot<TimelineSection, Tweet>()
            snapshot.appendSections([.main])
            snapshot.appendItems(tweets, toSection: .main)
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
}

extension TimelineViewController {

    enum TimelineSection: Hashable {
        case main
    }
}
