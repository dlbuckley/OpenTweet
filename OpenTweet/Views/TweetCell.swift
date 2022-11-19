//
//  TweetCell.swift
//  OpenTweet
//
//  Created by Dale Buckley on 14/11/2022.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import UIKit

final class TweetCell: UITableViewCell {

    // MARK: Subviews

    let containerStackView: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 16
        return stack
    }()

    let authorAvatarImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.accessibilityIdentifier = "author_avatar_image_view"
        imageView.layer.cornerRadius = 8
        imageView.layer.cornerCurve = .continuous
        imageView.backgroundColor = .gray
        return imageView
    }()

    let contentStackView: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()

    let authorLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "author_label"
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()

    let contentLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "content_label"
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()

    let createdAtLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "created_at_label"
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }()

    // MARK: Initialisers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(containerStackView)

        containerStackView.addArrangedSubview(authorAvatarImageView)
        containerStackView.addArrangedSubview(contentStackView)

        contentStackView.addArrangedSubview(authorLabel)
        contentStackView.addArrangedSubview(contentLabel)
        contentStackView.addArrangedSubview(createdAtLabel)

        NSLayoutConstraint.activate([
            containerStackView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            authorAvatarImageView.widthAnchor.constraint(equalToConstant: 60),
            authorAvatarImageView.heightAnchor.constraint(equalTo: authorAvatarImageView.widthAnchor)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TweetCell {

    /// Use for the `TableView` reuse identifier
    static let Identifier = "\(TweetCell.self)"

    func configure(with tweet: Tweet, dateFormatter: DateFormatter) {

        authorLabel.text = tweet.author.id
        contentLabel.text = tweet.content
        createdAtLabel.text = dateFormatter.string(from: tweet.creationDate)
    }
}
