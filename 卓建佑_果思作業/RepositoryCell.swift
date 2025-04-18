//
//  RepositoryCell.swift
//  卓建佑_果思作業
//
//  Created by Ray Septian Togi on 2025/4/18.
//

import UIKit

class RepositoryCell: UITableViewCell {
    let repoIcon = UIImageView()
    let nameLabel = UILabel()
    let descLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    func setupViews() {
        repoIcon.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = .boldSystemFont(ofSize: 18)
        descLabel.font = .systemFont(ofSize: 14)
        descLabel.textColor = .gray
        descLabel.numberOfLines = 2
        repoIcon.layer.cornerRadius = 20
        repoIcon.clipsToBounds = true

        contentView.addSubview(repoIcon)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descLabel)

        NSLayoutConstraint.activate([
            repoIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            repoIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            repoIcon.widthAnchor.constraint(equalToConstant: contentView.frame.width/3),
            repoIcon.heightAnchor.constraint(equalToConstant: contentView.frame.width/3),

            nameLabel.leadingAnchor.constraint(equalTo: repoIcon.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            nameLabel.topAnchor.constraint(equalTo: repoIcon.centerYAnchor, constant: -25),

            descLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            descLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
        ])
    }

    func configure(with repo: Repository) {
        nameLabel.text = repo.full_name
        descLabel.text = repo.description ?? ""
        repoIcon.load(urlString: repo.owner.avatar_url)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Image Loader

extension UIImageView {
    /// Extracts data from give url and convert to UIImage
    func load(urlString: String) {
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}

