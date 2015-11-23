//
//  GETransforme.swift
//  Underground_Survivors
//
//  Created by Allison Lindner on 14/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

import simd

public class Transform: NSObject, Transformable {
	private var _position: float3!
	private var _rotationAngles: float3!
	private var _scale: float3!
	private var _pivo: float3!
	private var _meshScale: float3!

	var parentModelMatrix: float4x4?

	private var _modelMatrix: float4x4!
	private var _rigidbody: RigidbodyProtocol?

	override init () {
		_position = float3(0.0)
		_rotationAngles = float3(0.0)
		_scale = float3(1.0)
		_pivo = float3(0.0)
		_meshScale = float3(1.0)

		super.init()
	}

	func setRigidbody(rigidbody: RigidbodyProtocol) {
		_rigidbody = rigidbody
	}

	func getModelMatrix() -> float4x4 {

		_modelMatrix =
				newTranslation(float3( _position.x, _position.y, _position.z)) *
				newRotation(_rotationAngles.x, axis: float3(1.0, 0.0, 0.0)) *
				newRotation(_rotationAngles.y, axis: float3(0.0, 1.0, 0.0)) *
				newRotation(_rotationAngles.z, axis: float3(0.0, 0.0, 1.0)) *
				newTranslation(float3( _pivo.x, _pivo.y, _pivo.z)) *
				newScale(_scale.x, y: _scale.y, z: _scale.z)

		if parentModelMatrix != nil {
			return parentModelMatrix! * _modelMatrix
		}

		return _modelMatrix
	}

	func setParentModelMatrix(modelMatrix: float4x4) {
		parentModelMatrix = modelMatrix
	}

	public func setPosition(position: float2) {
		if let rigidbody = _rigidbody {
			if rigidbody.created {
				rigidbody.setPosition(CGPointMake(CGFloat(position.x), CGFloat(position.y)))
			}
		}
		_position.x = position.x
		_position.y = position.y
	}

	public func getPosition() -> float2 {
		if let rigidbody = _rigidbody {
			if rigidbody.created {
				_position.x = Float(rigidbody.getPosition().x)
				_position.y = Float(rigidbody.getPosition().y)
			}
		}
		return float2(_position.x, _position.y)
	}

	public func setZPosition(z: Float) {
		_position.z = z
	}

	public func getZPosition() -> Float {
		return _position.z
	}

	public func setZRotationDegree(degree: Float) {
		setZRotationRadian(toRadians(degree))
	}

	public func getZRotationDegree() -> Float {
		return toDegrees(getZRotationRadian())
	}

	public func setZRotationRadian(radian: Float) {
		if let rigidbody = _rigidbody {
			if rigidbody.created {
				rigidbody.setZRotation(radian)
			}
		}
		_rotationAngles.z = radian
	}

	public func getZRotationRadian() -> Float {
		if let rigidbody = _rigidbody {
			if rigidbody.created {
				_rotationAngles.z = rigidbody.getZRotation()
			}
		}
		return _rotationAngles.z
	}

	public func setScale(scale: float2) {
		_scale = float3(scale.x, scale.y, 1.0)
	}

	public func getScale() -> float2 {
		return float2(_scale.x, _scale.y)
	}

	public func setMeshScale(scale: float2) {
		_meshScale = float3(scale.x, scale.y, 1.0)
	}

	public func getMeshScale() -> float2 {
		return float2(_meshScale.x, _meshScale.y)
	}

	public func setPivo(pivo: float2) {
		_pivo = float3(pivo.x, pivo.y, 0.0)
	}

	public func getPivo() -> float2 {
		return float2(_pivo.x, _pivo.y)
	}
}