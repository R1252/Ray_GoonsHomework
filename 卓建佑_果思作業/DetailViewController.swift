//
//  DetailViewController.swift
//  卓建佑_果思作業
//
//  Created by Ray Septian Togi on 2025/4/18.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var ownerLabel : UILabel!
    @IBOutlet weak var titleLanguageLabel : UILabel!
    @IBOutlet weak var languageLabel : UILabel!
    @IBOutlet weak var descriptionLabel : UILabel!
    @IBOutlet weak var repoImage : UIImageView!
    
    var repository: Repository?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupDetailView()
    }
    
    /// Setup detailed view
    func setupDetailView() {
        guard let repo = repository else {
            print("No repository selected")
            return
        }
        
        ownerLabel.text = repo.owner.login
        titleLanguageLabel.text = repo.full_name
        languageLabel.text = "Written in \(repo.language ?? "-")"
        
        let descriptionText = """
        \(repo.stargazers_count) stars
        \(repo.watchers_count) watchers
        \(repo.forks_count) forks
        \(repo.open_issues_count) open issues
        """

        descriptionLabel.text = descriptionText
        repoImage.load(urlString: repo.owner.avatar_url)
    }
}

