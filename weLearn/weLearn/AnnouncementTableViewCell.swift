//
//  AnnouncementTableViewCell.swift
//  weLearn
//
//  Created by Cris on 3/1/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import UIKit
import  SnapKit

class AnnouncementTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupToHierachy()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupToHierachy() {
        self.contentView.addSubview(date)
        self.contentView.addSubview(bar)
        self.contentView.addSubview(quote)
        self.contentView.addSubview(author)
    }
    
    func setupConstraints() {
        date.snp.makeConstraints { (lbl) in
            lbl.top.leading.equalTo(contentView).offset(10)
        }
        
        quote.snp.makeConstraints { (lbl) in
            lbl.leading.equalTo(bar.snp.trailing).offset(10)
            lbl.top.equalTo(date.snp.bottom).offset(10)
            lbl.trailing.equalTo(contentView).inset(20)
            lbl.bottom.equalTo(author.snp.top)
            //lbl.centerY.equalTo(contentView)
        }
        
        bar.snp.makeConstraints { (view) in
            view.leading.equalTo(contentView).offset(10)
            view.width.equalTo(5)
            view.height.equalTo(quote)
            view.top.equalTo(quote)
        }
        
        author.snp.makeConstraints { (view) in
            view.bottom.equalTo(contentView)//.inset(20)
            view.trailing.equalTo(contentView).inset(10)
        }
    }
    
    lazy var date: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.lineBreakMode = .byTruncatingTail
        lbl.font = UIFont(name: "Avenir-Heavy", size: 14)
        lbl.textColor = UIColor.darkGray
        return lbl
    }()
    
    lazy var quote: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 3
        lbl.textAlignment = .left
        lbl.lineBreakMode = .byWordWrapping
        lbl.font = UIFont(name: "Avenir-LightOblique", size: 24)
        return lbl
    }()
    
    lazy var author: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.lineBreakMode = .byTruncatingTail
        lbl.font = UIFont(name: "Avenir-Heavy", size: 16)
        lbl.textColor = UIColor.darkGray
        return lbl
    }()
    
    lazy var bar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.weLearnGreen
        return view
    }()

}