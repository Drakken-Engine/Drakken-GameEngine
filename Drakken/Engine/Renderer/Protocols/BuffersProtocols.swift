//
// Created by Allison Lindner on 09/11/15.
// Copyright (c) 2015 Allison Lindner. All rights reserved.
//

import Foundation

protocol Bufferable {
	var index: Int { get set }

	func setupOnRenderer(renderer: Renderer)
}