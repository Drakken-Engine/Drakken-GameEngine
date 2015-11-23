//
// Created by Allison Lindner on 08/10/15.
// Copyright (c) 2015 Allison Lindner. All rights reserved.
//

import Foundation

@objc public class Descriptor: NSObject {
	public var label: String!
	public var tag: String!

	public init(label: String, tag: String) {
		self.label = label
		self.tag = tag

		super.init()
	}

	public convenience override init() {
		self.init(label: "", tag: "")
	}
}
