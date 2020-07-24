//
//  AppListResponseModel.swift
//  BitriseAPI
//
//  Created by Yu Tawata on 2020/07/11.
//

import Foundation

public struct AppListResponseModel: Equatable, Codable {
    public var data: [AppResponseItemModel]?
    public var paging: PagingResponseModel?
}
