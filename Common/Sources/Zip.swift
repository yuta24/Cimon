//
//  Zip.swift
//  Shared
//
//  Created by Yu Tawata on 2019/05/11.
//

import Foundation

// swiftlint:disable function_parameter_count
public func zip<A, B>(_ a: A?, _ b: B?, _ closure: (A, B) -> Void) {
    if let a = a, let b = b {
        closure(a, b)
    }
}

public func zip<A, B, C>(_ a: A?, _ b: B?, _ c: C?, _ closure: (A, B, C) -> Void) {
    if let a = a, let b = b, let c = c {
        closure(a, b, c)
    }
}

public func zip<A, B, C, D>(_ a: A?, _ b: B?, _ c: C?, _ d: D?, _ closure: (A, B, C, D) -> Void) {
    if let a = a, let b = b, let c = c, let d = d {
        closure(a, b, c, d)
    }
}

public func zip<A, B, C, D, E>(_ a: A?, _ b: B?, _ c: C?, _ d: D?, _ e: E?, _ closure: (A, B, C, D, E) -> Void) {
    if let a = a, let b = b, let c = c, let d = d, let e = e {
        closure(a, b, c, d, e)
    }
}

public func zip<A, B, C, D, E, F>(_ a: A?, _ b: B?, _ c: C?, _ d: D?, _ e: E?, _ f: F?, _ closure: (A, B, C, D, E, F) -> Void) {
    if let a = a, let b = b, let c = c, let d = d, let e = e, let f = f {
        closure(a, b, c, d, e, f)
    }
}

public func zip<A, B, C, D, E, F, G>(_ a: A?, _ b: B?, _ c: C?, _ d: D?, _ e: E?, _ f: F?, _ g: G?, _ closure: (A, B, C, D, E, F, G) -> Void) {
    if let a = a, let b = b, let c = c, let d = d, let e = e, let f = f, let g = g {
        closure(a, b, c, d, e, f, g)
    }
}

public func zip<A, B, C, D, E, F, G, H>(_ a: A?, _ b: B?, _ c: C?, _ d: D?, _ e: E?, _ f: F?, _ g: G?, _ h: H?, _ closure: (A, B, C, D, E, F, G, H) -> Void) {
    if let a = a, let b = b, let c = c, let d = d, let e = e, let f = f, let g = g, let h = h {
        closure(a, b, c, d, e, f, g, h)
    }
}

public func zip<A, B, C, D, E, F, G, H, I>(_ a: A?, _ b: B?, _ c: C?, _ d: D?, _ e: E?, _ f: F?, _ g: G?, _ h: H?, _ i: I?, _ closure: (A, B, C, D, E, F, G, H, I) -> Void) {
    if let a = a, let b = b, let c = c, let d = d, let e = e, let f = f, let g = g, let h = h, let i = i {
        closure(a, b, c, d, e, f, g, h, i)
    }
}

public func zip<A, B, C, D, E, F, G, H, I, J>(_ a: A?, _ b: B?, _ c: C?, _ d: D?, _ e: E?, _ f: F?, _ g: G?, _ h: H?, _ i: I?, _ j: J?, _ closure: (A, B, C, D, E, F, G, H, I, J) -> Void) {
    if let a = a, let b = b, let c = c, let d = d, let e = e, let f = f, let g = g, let h = h, let i = i, let j = j {
        closure(a, b, c, d, e, f, g, h, i, j)
    }
}

public func zip<A, B, C, D, E, F, G, H, I, J, K>(_ a: A?, _ b: B?, _ c: C?, _ d: D?, _ e: E?, _ f: F?, _ g: G?, _ h: H?, _ i: I?, _ j: J?, _ k: K?, _ closure: (A, B, C, D, E, F, G, H, I, J, K) -> Void) {
    if let a = a, let b = b, let c = c, let d = d, let e = e, let f = f, let g = g, let h = h, let i = i, let j = j, let k = k {
        closure(a, b, c, d, e, f, g, h, i, j, k)
    }
}

public func zip<A, B, C, D, E, F, G, H, I, J, K, L>(_ a: A?, _ b: B?, _ c: C?, _ d: D?, _ e: E?, _ f: F?, _ g: G?, _ h: H?, _ i: I?, _ j: J?, _ k: K?, _ l: L?, _ closure: (A, B, C, D, E, F, G, H, I, J, K, L) -> Void) {
    if let a = a, let b = b, let c = c, let d = d, let e = e, let f = f, let g = g, let h = h, let i = i, let j = j, let k = k, let l = l {
        closure(a, b, c, d, e, f, g, h, i, j, k, l)
    }
}
// swiftlint:enable function_parameter_count
