//
//  Build.swift
//  CircleCIAPI
//
//  Created by Yu Tawata on 2019/05/07.
//

import Foundation

public struct Build: Codable {
    enum CodingKeys: String, CodingKey {
        case body
        case reponame
        case buildUrlString = "build_url"
        case branch
        case username
        case user
        case vcsRevision = "vcs_revision"
        case buildNum = "build_num"
        case committerEmail = "committer_email"
        case status
        case committerName = "committer_name"
        case subject
        case vcsType = "vcs_type"
        case vcsUrl = "vcs_url"
        case authorName = "author_name"
        case authorEmail = "author_email"
    }

    public struct User: Codable {
        enum CodingKeys: String, CodingKey {
            case isUser = "is_user"
            case login
            case avatarUrlString = "avatar_url"
            case name
            case vcsType = "vcs_type"
            case id
        }

        public var isUser: Bool
        public var login: String
        public var avatarUrlString: String
        public var name: String
        public var vcsType: String
        public var id: Int

        public init(
            isUser: Bool,
            login: String,
            avatarUrlString: String,
            name: String,
            vcsType: String,
            id: Int) {
            self.isUser = isUser
            self.login = login
            self.avatarUrlString = avatarUrlString
            self.name = name
            self.vcsType = vcsType
            self.id = id
        }
    }

    public var body: String?
    public var reponame: String
    public var buildUrlString: String
    public var branch: String
    public var username: String
    public var user: User
    public var vcsRevision: String
    public var buildNum: Int
    public var committerEmail: String?
    public var status: String
    public var committerName: String?
    public var subject: String?
    public var vcsType: String?
    public var vcsUrl: String
    public var authorName: String?
    public var authorEmail: String?

    public init(
        body: String?,
        reponame: String,
        buildUrlString: String,
        branch: String,
        username: String,
        user: User,
        vcsRevision: String,
        buildNum: Int,
        committerEmail: String?,
        status: String,
        committerName: String?,
        subject: String?,
        vcsType: String?,
        vcsUrl: String,
        authorName: String?,
        authorEmail: String?) {
        self.body = body
        self.reponame = reponame
        self.buildUrlString = buildUrlString
        self.branch = branch
        self.username = username
        self.user = user
        self.vcsRevision = vcsRevision
        self.buildNum = buildNum
        self.committerEmail = committerEmail
        self.status = status
        self.committerName = committerName
        self.subject = subject
        self.vcsType = vcsType
        self.vcsUrl = vcsUrl
        self.authorName = authorName
        self.authorEmail = authorEmail
    }
}
