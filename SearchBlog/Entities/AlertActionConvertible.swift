//
//  AlertActionConvertible.swift
//  SearchBlog
//
//  Created by kup on 2022/09/19.
//

import UIKit

protocol AlertActionConvertible{
    var title: String { get }
    var style: UIAlertAction.Style { get }
}
