//
//  BSNodeModify.swift
//  DataStructures
//
//  Created by Richard Clark on 4/25/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import Foundation

extension BSNode {

    /// Replace this node with the given one, i.e. set this node's parent to point to the new node. This
    /// assumes that the replacement doesn't change the node order, other than removing the current node
    /// from it. Parameter with: The node to replace with, which can be nil
    public func replace(with node: BSNode?) {
        if isLeft {
            parent.leftNode = node
        } else {
            parent.rightNode = node
        }
    }

    /// Insert the given value/count as this node's left child, updating the "next" pointers and
    /// rebalancing as needed.
    /// - Parameters:
    ///   - val: The value for the new node.
    ///   - n: The value count.
    /// - Returns: The new node
    @discardableResult
    func insertLeftChildNode(_ val: T) -> BSNode<T> {
        let pred = inOrderPredecessor
        let newNode = BSNode(val, 1, parent: self, direction: .left)
        left = newNode
        pred?.next = left
        left!.next = self
        rebalanceIfNecessary()
        return newNode
    }

    /// Insert the given value/count as this node's right child, updating the "next" pointers and
    /// rebalancing as needed.
    /// - Parameters:
    ///   - val: The value for the new node.
    ///   - n: The value count.
    /// - Returns: The new node
    @discardableResult
    func insertRightChildNode(_ val: T) -> BSNode<T> {
        let newNode = BSNode(val, 1, parent: self, direction: .right)
        right = newNode
        right!.next = next
        next = right
        rebalanceIfNecessary()
        return newNode
    }

    /// Increase by one the count of the given value, in the subtree having this node as root. If there is
    /// already a node for this value, increase the count by 1, otherwise insert a new node and initialize
    /// the count to 1. Return the node for the value.
    /// Complexity is *O(log(n))*.
    /// - Parameters:
    ///   - val: The value to insert or increment the count of
    /// - Returns: The existing or newly-inserted node, and a flag indicating whether the node is newly-created
    @discardableResult
    func insert(_ val: T) -> (node: BSNode<T>, new: Bool) {
        if val == value {
            valueCount += 1
            return (self, false)
        } else if val < value {
            if let thisLeft = left {
                return thisLeft.insert(val)
            } else {
                return (insertLeftChildNode(val), true)
             }
        } else {
            if let thisRight = right {
                return thisRight.insert(val)
            } else {
                return (insertRightChildNode(val), true)
            }
        }
    }

    /// Delete this node
    func deleteNode() {
        let pred = inOrderPredecessor
        var replaced = false
        if let thisLeft = left {
            if let thisRight = right {
                // Two children. Replace value with that of the in-order predecessor or successor.
                if thisLeft.height > thisRight.height {
                    let predecessor = thisLeft.maxNode
                    copyValueFrom(predecessor)
                    predecessor.deleteNode()
                } else {
                    let successor = thisRight.minNode
                    copyValueFrom(successor)
                    next = successor.next
                    successor.deleteNode()
                }
            } else {
                // Only left child
                replace(with: thisLeft)
                replaced = true
            }
        } else {
            if let thisRight = right {
                // Only right child
                replace(with: thisRight)
                replaced = true
            } else {
                // No children
                replace(with: nil)
                replaced = true
            }
        }
        if replaced {
            pred?.next = next
            if let bsParent = parent as? BSNode {
                bsParent.rebalanceIfNecessary()
            }
        }
    }
}
