//
//  NotiCell.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/02/03.
//

import UIKit
import FlexLayout
import SnapKit


class NotiCell:UITableViewCell, InChatCell {
    static var reuseIdentifier = "NotiCellView"
  
    let notiViewLabel = UILabel().then{
        $0.textColor = .label
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textAlignment = .center
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        selectionStyle = .default
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .default
        selectedBackgroundView = UIView().then{
            $0.backgroundColor = .clear
        }
        separatorInset = .zero
        backgroundColor = .chatBackgroundColor
        
        setFlex()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func setFlex(){
        contentView.flex
            .justifyContent(.center)
            .define { (flex) in
                flex.addItem(UIView())
                    .height(0)
                    .backgroundColor(.systemGray5)
                flex.addItem(notiViewLabel)
                    .marginVertical(8)
                    .backgroundColor(.systemGray5)
                flex.addItem(UIView())
                    .height(0)
                    .backgroundColor(.systemGray5)
            }
    }
    
    func configure(viewModel:ViewModel) {
        selectionStyle = .default
        
        notiViewLabel.text = viewModel.bodyText
        notiViewLabel.flex.markDirty()
        selectionStyle = .none
        layout()
    }
   
    
           
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    fileprivate func layout() {
        contentView.flex.layout(mode: .adjustHeight)
    }
    
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        layout()
        return contentView.frame.size
    }
}



