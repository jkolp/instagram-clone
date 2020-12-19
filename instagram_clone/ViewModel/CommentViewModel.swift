//
//  CommentViewModel.swift
//  instagram_clone
//
//  Created by Projects on 12/17/20.
//

import UIKit

struct CommentViewModel {
    
    private let comment: Comments
    
    var profileImageUrl: URL? {
        return URL(string: comment.profileImageUrl)
    }
    
    init(comment: Comments){
        self.comment = comment
    }
    
    func commentLabelText() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: "\(comment.username)  ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        
        attributedString.append(NSAttributedString(string: comment.commentText, attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        
        return attributedString
    }
    
    
    // To auto-resize the comment view. Passing (width) becuase commentViewModel does not have access to width that controller does.
    func size(forWidth width: CGFloat) -> CGSize {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = comment.commentText
        label.lineBreakMode = .byWordWrapping
        label.setWidth(width)
        
        return label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
