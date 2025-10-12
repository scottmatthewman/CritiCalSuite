//
//  PropertyWrappers.swift
//  CritiCalSettings
//
//  Created by Scott Matthewman on 11/10/2025.
//

import SwiftUI
import Defaults

/// Read-only property wrapper for settings
/// Use in views that should only read settings, not modify them
@propertyWrapper
public struct ReadOnlySetting<Value: Defaults.Serializable>: DynamicProperty {
    @Default private var value: Value

    public init(_ key: Defaults.Key<Value>) {
        self._value = Default(key)
    }

    public var wrappedValue: Value {
        value
    }
}

/// Read-write property wrapper for settings
/// Use in AppSettings views that need to modify settings
@propertyWrapper
public struct Setting<Value: Defaults.Serializable>: DynamicProperty {
    @Default private var value: Value

    public init(_ key: Defaults.Key<Value>) {
        self._value = Default(key)
    }

    public var wrappedValue: Value {
        get { value }
        nonmutating set { value = newValue }
    }

    public var projectedValue: Binding<Value> {
        $value
    }
}
