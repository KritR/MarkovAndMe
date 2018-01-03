//
//  MarkovState.swift
//  MarkovChainQuotes
//
//  Created by Krithik Rao on 1/1/18.
//  Copyright © 2018 Krithik Rao. All rights reserved.
//

import Foundation
import RandomKit

class FrequencyMarkovChain<T: Hashable> {
    var chain = Dictionary<T, FrequencyMarkovNode<T>>()
    
    func addTranisitionOccurrence(oldState: T, newState: T){
        if let node = chain[oldState], let transitionNode = chain[newState] {
            node.addTransitionOccurrence(transitionNode)
        } else if let node = chain[oldState] {
            let transitionNode = FrequencyMarkovNode<T>(state: newState)
            node.addTransitionOccurrence(transitionNode)
            chain[newState] = transitionNode
        } else if let transitionNode = chain[newState] {
            let node = FrequencyMarkovNode<T>(state: oldState)
            node.addTransitionOccurrence(transitionNode)
            chain[oldState] = node
        }
        else {
            let node = FrequencyMarkovNode<T>(state: oldState)
            let transitionNode = FrequencyMarkovNode<T>(state: newState)
            node.addTransitionOccurrence(transitionNode)
            chain[newState] = transitionNode
            chain[oldState] = node
        }
    }
    
    func trainOnTransitionList(list: [T]){
        if(list.count <= 1){
            return;
        }
        for i in (1..<list.count).reversed() {
            let nextState = list[i]
            let currState = list[i-1]
            addTranisitionOccurrence(oldState: currState, newState: nextState)
        }
    }
    
    func getNextState(currentState: T) -> T? {
        if let node = chain[currentState] {
            return node.getNextNode().state
        } else {
            return nil
        }
    }
    
    func contains(state: T) -> Bool {
        return chain.keys.contains(state)
    }
}

class FrequencyMarkovNode<T: Hashable> {
    
    let state : T;
    var nextState = Dictionary<FrequencyMarkovNode<T>,Int>();
    var totalFreq : Int {
        return Int(nextState.values.reduce(0, +))
    }
    
    init(state: T){
        self.state = state;
    }
    
    func addTransitionOccurrence(_ transitionNode: FrequencyMarkovNode<T>) {
        if let freq = nextState[transitionNode] {
            nextState[transitionNode] = freq + 1
        } else {
            nextState[transitionNode] = 1
        }
    }
    
    func getTransitionProbability(transitionNode: FrequencyMarkovNode<T>) -> Double {
        if let freq = nextState[transitionNode] {
            return Double(freq) / Double(nextState.values.reduce(0, +))
        } else {
            return 0
        }
    }
    
    func getNextNode() -> FrequencyMarkovNode<T> {
        var freqValue = Int.random(in: 0 ..< totalFreq, using: &Xoroshiro.default)! + 1
        for (state, freq) in nextState {
            freqValue = freqValue - freq
            if(freqValue <= 0) {
                return state
            }
        }
        return self
    }
}

extension FrequencyMarkovNode : Hashable {
    var hashValue: Int {
        return state.hashValue
    }
    
    static func == (lhs: FrequencyMarkovNode, rhs: FrequencyMarkovNode) -> Bool {
        return lhs.state == rhs.state
    }
}

