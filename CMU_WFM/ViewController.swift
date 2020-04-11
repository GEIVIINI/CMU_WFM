//
//  ViewController.swift
//  CMU_WFM
//
//  Created by Methawin on 6/4/2563 BE.
//  Copyright © 2563 Methawin. All rights reserved.
//

import UIKit
import Alamofire
import ImageSlideshow
import Kingfisher

class ViewController: UIViewController {

    @IBOutlet weak var imageSlide: ImageSlideshow! {
        didSet {
            imageSlide.layer.cornerRadius = 10
            imageSlide.contentScaleMode = .scaleAspectFill
        }
    }
    
    @IBOutlet weak var buttomImageSlide: ImageSlideshow! {
        didSet {
            buttomImageSlide.layer.cornerRadius = 10
            buttomImageSlide.contentScaleMode = .scaleAspectFit
        }
    }
    
    
    var topNews: [News]?
    var buttomNews: [News]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = LocalFile.getUser()
        if let token = user?.token {
            var headers = HTTPHeaders()
            headers.add(name: "X-WFH-SESSION", value: token)
            AF.request("https://b-gib.banana.co.th/wfh/v1r/news?newsType=FEED&newsId", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseJSON { response in
                    switch (response.result) {
                case .success:
                    if let json = response.value as? [String:Any] {
                        if let results = json["data"] as? [[String:Any]]   {
                            var news = [News]()
                            for result in results {
                                news.append(News(jsonDict: result as NSDictionary))
                            }
                            self.topNews = news
                            self.setImage(newsFeed: news, top: true)
                        }
                    }
              case .failure:
                  print("Error")
              }
            }
            AF.request("https://b-gib.banana.co.th/wfh/v1r/news?newsType=FIX&newsId", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseJSON { response in
                    switch (response.result) {
                case .success:
                    if let json = response.value as? [String:Any] {
                        if let results = json["data"] as? [[String:Any]]   {
                            var news = [News]()
                            for result in results {
                                news.append(News(jsonDict: result as NSDictionary))
                            }
                            self.buttomNews = news
                            self.setImage(newsFeed: news, top: false)
                        }
                    }
              case .failure:
                  print("Error")
              }
            }
        }
        let topGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.topTap))
        imageSlide.addGestureRecognizer(topGestureRecognizer)
        let buttomGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.buttomTap))
        buttomImageSlide.addGestureRecognizer(buttomGestureRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.navigationItem.titleView = customNavbar(titleTopText: "Work", titleButtomText: "\nFrom Home", imageName: "logo_cmu")
    }
    
    func customNavbar(titleTopText: String, titleButtomText: String, imageName: String) -> UIView {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        let label = UILabel(frame: CGRect(x: 50, y: 0, width: screenWidth/2, height: 44))
        label.numberOfLines = 0
        label.text = titleTopText
        label.textAlignment = NSTextAlignment.left
        
        let topAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20.0) as Any]
        let botAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 14.0) as Any]

        let topString = NSMutableAttributedString(string: titleTopText, attributes: topAttributes)
        let botString = NSAttributedString(string: titleButtomText, attributes: botAttributes)
        topString.append(botString)
        label.attributedText = topString
        
        let image = UIImageView()
        image.image = UIImage(named: imageName)
        let imageWidth = label.frame.size.height
        let imageHeight = label.frame.size.height
        
        let imageSpace = UIImageView(frame: CGRect(x: 46, y: 0, width: 1, height: 44))
        imageSpace.backgroundColor = .darkGray
        

        image.frame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        image.contentMode = UIView.ContentMode.scaleAspectFit

        titleView.addSubview(label)
        titleView.addSubview(image)
        titleView.addSubview(imageSpace)
        return titleView
    }
    

    func setImage(newsFeed: [News], top: Bool) {
        var imageSource: [KingfisherSource] = []
        for news in newsFeed {
            imageSource.append(KingfisherSource(urlString: news.coverImageLink!)!)
        }
        if top {
            imageSlide.setImageInputs(imageSource)
        } else {
            buttomImageSlide.setImageInputs(imageSource)
        }
    }
    
    @objc func topTap() {
        let viewController = NewsDetailViewController(nibName: "NewsDetailViewController", bundle: nil)
        if let currentNews = topNews?[imageSlide.currentPage] {
            viewController.setNews(currentNews: currentNews, isTop: true)
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func buttomTap() {
        let viewController = NewsDetailViewController(nibName: "NewsDetailViewController", bundle: nil)
        if let currentNews = buttomNews?[buttomImageSlide.currentPage] {
            viewController.setNews(currentNews: currentNews, isTop: false)
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

