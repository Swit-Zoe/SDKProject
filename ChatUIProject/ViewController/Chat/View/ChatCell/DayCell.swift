//
//  DayCell.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/02/03.
//

import UIKit
import FlexLayout
import SnapKit

protocol InChatCell:UITableViewCell{
    func configure(viewModel:ViewModel)
    static var reuseIdentifier:String {get set}
}


class DayCell:UITableViewCell, InChatCell {
    static var reuseIdentifier = "DayCellView"
  
    let dayChangeLabel = UILabel().then {
        $0.textColor = .lightGray
        $0.numberOfLines = 1
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        selectionStyle = .default
        
      //  setFlex()
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
            .direction(.row)
            .justifyContent(.center)
            .height(32)
            .define { flex in
            flex.addItem()
                .direction(.row)
                .height(1)
                .width(100%)
                .backgroundColor(.systemGray5)
                .alignSelf(.center)
                .define{ flex in}
            
            flex.addItem(dayChangeLabel)
                .direction(.row)
                .backgroundColor(.clear)
                .alignSelf(.center)
                .define{ flex in}
            
            flex.addItem()
                .direction(.row)
                .height(1)
                .width(100%)
                .backgroundColor(.systemGray5)
                .alignSelf(.center)
                .define{ flex in}
            
        }
    }
    
    func configure(viewModel:ViewModel) {
        selectionStyle = .default
        
        dayChangeLabel.text = viewModel.bodyText
        dayChangeLabel.flex.markDirty()
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



