//
//  PhotoCollectionViewFlowLayout.swift
//  PicUp
//
//  Created by Charlie Kim on 2018. 2. 27..
//  Copyright © 2018년 Charlie Kim. All rights reserved.
//

import UIKit

class PhotoCollectionViewFlowLayout: UICollectionViewFlowLayout {
    var recentOffset: CGPoint = CGPoint()
    
    override func prepare() {
        super.prepare()
        
        self.scrollDirection = .horizontal
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        if velocity.x == 0 {
            return recentOffset
        }
        
        if let collectionView = self.collectionView {
            let halfWidth = collectionView.bounds.size.width * 0.5
            
            if let attributesForVisibleCell = self.layoutAttributesForElements(in: collectionView.bounds) {
                var candidateAttributes: UICollectionViewLayoutAttributes?
                
                for attributes in attributesForVisibleCell {
                    if attributes.representedElementCategory != .cell {
                        continue
                    }
                    
                    if (attributes.center.x == 0) || (attributes.center.x > (collectionView.contentOffset.x + halfWidth) && velocity.x < 0) {
                        continue
                    }
                    
                    candidateAttributes = attributes
                }
                
                if proposedContentOffset.x == -(collectionView.contentInset.left) {
                    return proposedContentOffset
                }
                
                guard let _ = candidateAttributes else {
                    return recentOffset
                }
                
                recentOffset = CGPoint(x: floor(candidateAttributes!.center.x - halfWidth), y: proposedContentOffset.y)
                return recentOffset
            }
        }
        
        recentOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        return recentOffset
    }
}
