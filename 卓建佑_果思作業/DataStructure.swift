//
//  DataStructure.swift
//  卓建佑_果思作業
//
//  Created by Ray Septian Togi on 2025/4/18.
//

import Foundation

struct GitHubSearchResponse: Codable {
    let items: [Repository]
}

// get keys from https://docs.github.com/en/rest/repos/repos?apiVersion=2022-11-28
struct Repository: Codable {
    let full_name: String
    let description: String?
    let owner: Owner
    let language: String?
    let stargazers_count: Int
    let watchers_count: Int
    let forks_count: Int
    let open_issues_count: Int
}

struct Owner: Codable {
    let login: String
    let avatar_url: String
}

