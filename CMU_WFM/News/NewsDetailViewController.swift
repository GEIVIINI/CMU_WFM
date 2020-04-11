//
//  NewsDetailViewController.swift
//  CMU_WFM
//
//  Created by Methawin on 7/4/2563 BE.
//  Copyright © 2563 Methawin. All rights reserved.
//

import UIKit
import Kingfisher

class NewsDetailViewController: UIViewController {

    var news = News()
    var isTop = true
    
    @IBOutlet weak var newImageView: UIImageView! {
        didSet {
            newImageView.layer.cornerRadius = 10
            newImageView.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet weak var dateLbel: UILabel!
    @IBOutlet weak var newsLabel: UILabel!
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var newsDetailLabel: UILabel!
    @IBOutlet weak var linkButton: UIButton! {
        didSet {
            linkButton.layer.borderColor = UIColor.purple.cgColor
            linkButton.titleLabel?.textColor = UIColor.purple
            linkButton.layer.borderWidth = 2
            linkButton.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var imageNSLayoutConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var multiSize = 1.0
        if isTop {
            multiSize = 1.7
        } else {
            multiSize = 0.7
        }
        let newConstraint = imageNSLayoutConstraint.constraintWithMultiplier(CGFloat(multiSize))
        view.removeConstraint(imageNSLayoutConstraint)
        view.addConstraint(newConstraint)
        view.layoutIfNeeded()
        imageNSLayoutConstraint = newConstraint
        if let titleName = news.nameTH {
            self.title = titleName
        }
        if let views = news.allViews {
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(named:"icon_news_view")
            imageAttachment.bounds = CGRect(x: 0, y: 0, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
            let attachmentString = NSAttributedString(attachment: imageAttachment)
            let completeText = NSMutableAttributedString(string: "")
            completeText.append(attachmentString)
            let textAfterIcon = NSAttributedString(string: " " + views)
            completeText.append(textAfterIcon)
            self.viewLabel.attributedText = completeText
        }
        if let date = news.crDate {
            dateLbel.text = convertDateFormater(date)
        }
        if let source = news.source {
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(named:"icon_news_source")
            imageAttachment.bounds = CGRect(x: 0, y: 0, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
            let attachmentString = NSAttributedString(attachment: imageAttachment)
            let completeText = NSMutableAttributedString(string: "")
            completeText.append(attachmentString)
            let textAfterIcon = NSAttributedString(string: " " + source)
            completeText.append(textAfterIcon)
            self.newsLabel.attributedText = completeText
        }
        if let coverImageLink = news.coverImageLink {
            let imageUrl = URL(string: coverImageLink)
            newImageView.kf.setImage(with: imageUrl)
        }
        if let description = news.descriptionTH {
            newsDetailLabel.text = description.htmlToString
        }
        if let link = news.link {
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(named:"icon_news_link")
            imageAttachment.bounds = CGRect(x: 6, y: 0, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
            let attachmentString = NSAttributedString(attachment: imageAttachment)
            let completeText = NSMutableAttributedString(string: "")
            completeText.append(attachmentString)
            let textAfterIcon = NSAttributedString(string: "   " + "link" + " ")
            completeText.append(textAfterIcon)
            self.linkButton.setAttributedTitle(completeText, for: .normal)
            self.linkButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        }
    }

    @objc func buttonAction(sender: UIButton!) {
        if let link = news.link {
            guard let url = URL(string: link) else { return }
            UIApplication.shared.open(url)
        }
    }
    
    func convertDateFormater(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd MMM yyyy"
        return  dateFormatter.string(from: date!)
    }
    
    func setNews(currentNews: News, isTop: Bool) {
        self.news = currentNews
        self.isTop = isTop
    }
    
}

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
