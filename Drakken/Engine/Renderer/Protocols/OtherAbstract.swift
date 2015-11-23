//
// Created by Allison Lindner on 03/10/15.
// Copyright (c) 2015 Allison Lindner. All rights reserved.
//

import Foundation

public class OtherComponentAbstract: NSObject, OtherComponent {
	public var descriptor: Descriptor!

	public var component: Component!
	public var transform: Transformable!
	public var rigidbody: RigidbodyProtocol?

	override init () {
		descriptor = Descriptor()

		super.init()
	}
}