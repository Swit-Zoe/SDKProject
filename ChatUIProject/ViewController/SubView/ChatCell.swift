
import UIKit
import FlexLayout
import SnapKit
import TTTAttributedLabel
import Nantes

class ChatCell: UITableViewCell {
    static let reuseIdentifier = "ChatCellView"
    
    fileprivate let padding: CGFloat = 10
    
    fileprivate let nameLabel = UILabel()
//    fileprivate let chatLabel2 : NantesLabel = .init(frame: .zero)
    
    let chatLabel = UITextView()
    
    fileprivate let timeLabel = UILabel()
    fileprivate let timeNameContainer = UIView()
    fileprivate let textContentContainer = UIView()
    let linkPreviewContainer = UIView()
    fileprivate let profileImage:UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 24
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    fileprivate let imageDic = [true:UIImage(named: "User1"),false:UIImage(named: "User2")]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        linkPreviewContainer.subviews.forEach{
//            $0.removeFromSuperview()
//        }
        profileImage.image = nil
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .default
        
        separatorInset = .zero
                
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.lineBreakMode = .byTruncatingTail
        
        chatLabel.font = UIFont.systemFont(ofSize: 16)
        chatLabel.backgroundColor = .clear
        chatLabel.linkTextAttributes = [.underlineColor:UIColor.linkColor,.underlineStyle:1,.foregroundColor:UIColor.linkColor]
        chatLabel.isScrollEnabled = false

       // chatLabel.numberOfLines = 0
        
        timeLabel.font = UIFont.systemFont(ofSize: 16)
        timeLabel.numberOfLines = 1
        timeLabel.textAlignment = .right
        timeLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        
        setColor()
        
        contentView.flex
            .paddingHorizontal(16)
            .direction(.row)
            .paddingVertical(8)
            .define { (flex) in
                
            flex.addItem(profileImage).size(48)
                
            flex.addItem(textContentContainer)
                .paddingLeft(16)
                .direction(.column)
                .justifyContent(.spaceBetween)
                .grow(1)
                .shrink(1)
                .define { (flex) in
                    
                flex.addItem(timeNameContainer)
                        .direction(.row)
                        .justifyContent(.spaceBetween)
                        .alignSelf(.stretch)
                        .define { (flex) in
                            
                    flex.addItem(nameLabel).shrink(3)
                    flex.addItem(timeLabel).shrink(1)
                }
                flex.addItem(chatLabel)
                        .alignSelf(.stretch)
                    
                flex.addItem(linkPreviewContainer)
                        
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setColor(){
        backgroundColor = UIColor.chatBackgroundColor
        nameLabel.textColor = UIColor.chatLabelColor
        chatLabel.textColor = UIColor.chatLabelColor
        timeLabel.textColor = UIColor.chatTimeColor
    }
    
    func configure(currentChat:Chat,presentChat:Chat?) {
        nameLabel.text = currentChat.userName
        nameLabel.flex.markDirty()
        
        timeLabel.text = DateFormatter.commonDf.string(from: currentChat.created)
        timeLabel.flex.markDirty()
        
        chatLabel.attributedText = currentChat.bodyBlockskit.convertRichText()//currentChat.bodyText
       // chatLabel.attributedText = rtfToAttributedString(content)
        chatLabel.flex.markDirty()
        //chatLabel.delegate = delegate
        chatLabel.isEditable = false
        chatLabel.dataDetectorTypes = .link
        
        profileImage.image = imageDic[true]!
        
        
        
        if let pc = presentChat{
            if pc.userID == currentChat.userID &&
                DateFormatter.commonDf.string(from: currentChat.created) == DateFormatter.commonDf.string(from: pc.created)
            {
                profileImage.image = nil
                nameLabel.text = nil
                timeLabel.text = nil
                profileImage.flex.height(0)
                profileImage.flex.markDirty()
            }else{
                profileImage.image = imageDic[true]!
                profileImage.flex.height(48)
                profileImage.flex.markDirty()
            }
        }
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
    
    fileprivate func rtfToAttributedString(_ html:String) -> NSAttributedString? {
      guard let data = html.data(using: .utf8) else {
          
        return NSAttributedString()
      }
        print(html)
      do {
        return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.rtf, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
      } catch {
        return NSAttributedString()
      }
    }
}
