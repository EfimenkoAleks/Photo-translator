//
//  FileManager.swift
//  Photo translator
//
//  Created by Aleksandr on 19.09.2024.
//

import Foundation

protocol DP_FileManager: AnyObject {
    func dp_getFileUrlFromPath(_ path: String) -> URL?
    func dp_saveData(_ data: Data, path: String) -> DP_DownLoad
    func dp_removeFile(path: String)
}
