
import UIKit
import FlexLayout
import SnapKit
import TTTAttributedLabel
import Nantes
import RichString
import Lottie
import Gifu
import Kingfisher

class ChatCell:UITableViewCell, InChatCell {
    static var reuseIdentifier = "ChatCellView"
    
    var chatContentsView = ChatContentsView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        selectionStyle = .default
        
        chatContentsView.removeFromSuperview()
        chatContentsView = ChatContentsView()
        setFlex()
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
            .define { (flex) in
                
                flex.addItem(chatContentsView)
                    .width(100%)
            }
    }
    
    func configure(viewModel:ViewModel) {
        selectionStyle = .default
        
        setLabelAndImage(viewModel:viewModel)
        setImageAssetData(viewModel:viewModel)
        setOGData(viewModel:viewModel)
        setMessageData(viewModel:viewModel)
        setReactionLayout(viewModel:viewModel)
        setCommentLayout(viewModel:viewModel)
        
        layout()
    }
    
    private func setImageAssetData(viewModel:ViewModel){
        chatContentsView.imageAssetContainer.hide()
        guard let assetData = viewModel.assetData else {return}
        if assetData.count == 0 {return}
        chatContentsView.imageAssetContainer.show()
        
        let ad = assetData.filter{$0.fileMIME == .image}
                
        var temp = UIView()
        for (i,element) in ad.enumerated() {
            
            let imageView = UIImageView()
            imageView.image = UIImage(named: "sample")
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 5
            imageView.clipsToBounds = true
            
            var heightConstant:CGFloat = 100
            
            if i<3{
                chatContentsView
                    .imageAssetContainer
                    .contentContainer
                    .flex
                    .addItem(imageView)
                    .grow(1)
                    .shrink(1)
                    .marginLeft(8)
                    .marginTop(8)
                
                contentView.flex.layout()
                
                if ad.count == 1{
                    heightConstant = imageView.scaledSize().height
                }
                
                chatContentsView
                    .imageAssetContainer
                    .contentContainer
                    .flex
                    .height(heightConstant)

                contentView.flex.layout()
            }else{
                if i % 2 == 1{
                    let view = UIView()
                    temp = view
                    chatContentsView
                        .imageAssetContainer
                        .flex
                        .addItem(view)
                        .direction(.row)
                        .right(0)
                        .justifyContent(.center)
                        .left(0)
                }
                
                temp
                    .flex
                    .addItem(imageView)
                    .grow(1)
                    .shrink(1)
                    .marginLeft(8)
                    .marginTop(8)
                
                contentView.flex.layout()
                if ad.count == i + 1 && ad.count % 2 == 0{
                    heightConstant = imageView.scaledSize().height
                }
                temp
                    .flex
                    .height(heightConstant)
                
                contentView.flex.layout()
            }
        }
        
    }
    
    private func setOGData(viewModel:ViewModel){
        chatContentsView.ogDataContainer.flex.display(.none)
        guard let ogData = viewModel.ogData else {return}
        chatContentsView.ogDataContainer.flex.display(.flex)
        
        ogData.forEach {
            let ogView = OGView()
            if $0.ogType == "YOUTUBE"{
                ogView.youtubeLabel.text = "YouTube"
                ogView.youtubeLabel.flex.display(.flex)
                ogView.urlLabel.flex.display(.none)
                ogView.titleLabel.flex.marginTop(16)
                ogView.titleLabel.flex.markDirty()
            }else{
                ogView.youtubeLabel.flex.display(.none)
                ogView.urlLabel.flex.display(.flex)
                ogView.titleLabel.flex.marginTop(0)
                ogView.titleLabel.flex.markDirty()
            }
            
            ogView.titleLabel.text = $0.ogTitle
            ogView.titleLabel.flex.markDirty()
            
            ogView.descriptionLabel.text = $0.ogDescription
            ogView.descriptionLabel.flex.markDirty()
            
            ogView.urlLabel.text = $0.ogURL
            ogView.urlLabel.flex.markDirty()
            
            guard let url = URL(string:$0.ogImage) else {return}
            ogView.imageURL = url
            
            chatContentsView.ogDataContainer.flex.addItem(ogView)
            chatContentsView.ogDataContainer.sub.append(ogView)
            
            contentView.flex.layout()
            
            ogView.imageView.tintColor = .label
            ogView.imageView.kf.setImage(with: ogView.imageURL,
                                         placeholder: UIImage(systemName: "video"))
            { receivedSize, totalSize in
                
            } completionHandler: { result in
                switch(result){
                case .success( _):
                    ogView.imageView.flex
                        .height(ogView.imageView.scaledSize().height)
                    ogView.flex.markDirty()
                    self.contentView.flex.layout()
                    break
                case .failure( _):
                    break
                }
            }
        }
        
    }
    
    private func setMessageData(viewModel:ViewModel){
        let messageDataView = chatContentsView.messageDataView
        messageDataView.hide()
        guard let messageData = viewModel.messageData else {
            return
        }
        if messageData.count == 0 {
            return
        }
        messageDataView.show()
        
        messageData.forEach {
            let att = RichTextConverter.shared.convertRichText(bodyBlockskit: $0.bodyBlockskit)
            messageDataView.chatLabel.attributedText = att
            messageDataView.timeLabel.text = DateFormatter.createdFullDateFormat.string(from: $0.created) + " " + $0.wsName
            messageDataView.hashtagLabel.text = "#" + $0.chName
            messageDataView.nameLabel.text = $0.userName
        }
        messageDataView.dirty()
    }
    
    private func setReactionLayout(viewModel:ViewModel){
        let reactionContainer = chatContentsView.reactionContainer
        if let reactions = viewModel.reactions ,reactions.count > 0{
            reactionContainer.flex.display(.flex)
            reactions.forEach{ reaction in
                reactionContainer.flex.define { flex in
                    let button = UIButton()
                    let key = reaction.value
                    
                    var title = EmojiUtils.shared.getEmoji(name: key,size: 22)
                    var num = ("  " + String(reaction.count)).fontSize(16).color(.label)
                    
                    if title.attachment != nil{
                        num = num.baselineOffset(Float((22 - num.fontSize!)))
                    }
                    title = title + num
                    
                    button.setAttributedTitle(title, for: .normal)
                    button.titleLabel?.font = UIFont.regular
                    button.layer.cornerRadius = 4
                    button.layer.borderColor = UIColor.darkGray.cgColor
                    button.layer.borderWidth = 1
                    
                    let textView = UITextView().then {
                        $0.isEditable = true
                        $0.isSelectable = false
                        $0.isScrollEnabled = false
                        $0.attributedText = title
                        $0.backgroundColor = .clear
                        $0.layer.borderColor = UIColor.darkGray.cgColor
                        $0.layer.borderWidth = 1
                        $0.textAlignment = .center
                        $0.layer.cornerRadius = 4
                        $0.sizeToFit()
                    }
                    flex.addItem(textView)
                        .height(35)
                        .marginTop(8)
                        .marginRight(8)
                        .justifyContent(.center)
                }
            }
            reactionContainer.flex.define { flex in
                let button = UIButton()
                
                button.setImage(UIImage(systemName: "plus"), for: .normal)
                button.layer.cornerRadius = 4
                button.layer.borderColor = UIColor.darkGray.cgColor
                button.layer.borderWidth = 1
                
                flex.addItem(button)
                    .height(35)
                    .width(button.intrinsicContentSize.width + 20)
                    .marginTop(8)
                    .marginRight(8)
            }
        }else{
            reactionContainer.flex.display(.none)
        }
    }
    
    private func setCommentLayout(viewModel:ViewModel){
        let commentContainer = chatContentsView.commentContainer
        
        if let msgCmtCnt = viewModel.msgCmtCnt, msgCmtCnt > 0{
            commentContainer.flex.display(.flex)
            commentContainer.flex.addItem().define { flex in
                let button = UIButton()
                button.setAttributedTitle("댓글 ".color(.label) + String(msgCmtCnt).color(.label), for: .normal)
                button.titleLabel?.font = UIFont.regular
                button.layer.cornerRadius = 4
                button.layer.borderColor = UIColor.darkGray.cgColor
                button.layer.borderWidth = 1
                button.titleLabel?.textColor = .label
                
                flex.addItem(button)
                    .height(30)
                    .width(90)
                
                commentContainer.flex.markDirty()
            }
        }else{
            commentContainer.flex.display(.none)
        }
    }
    
    private func setLabelAndImage(viewModel:ViewModel){
        chatContentsView.nameLabel.text = viewModel.userName
        chatContentsView.timeLabel.text = viewModel.created
        chatContentsView.chatLabel.attributedText = viewModel.text
        
        chatContentsView.timaAndNameContainer.dirty()
        chatContentsView.textContentContainer.dirty()
        
        chatContentsView.chatLabel.isEditable = false
        chatContentsView.chatLabel.dataDetectorTypes = .link
        
        //MARK: if same person send a message at the same minute
        if viewModel.userName == nil{
            chatContentsView.profileImage.flex.height(0)
        }else{
            chatContentsView.profileImage.flex.height(48)
        }
        
        chatContentsView.chatLabel.layer.borderWidth = viewModel.isOutcome! ? 0.5 :0
        chatContentsView.chatLabel.flex.markDirty()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    fileprivate func layout() {
        
        chatContentsView.profileImage.flex.markDirty()
        chatContentsView.messageDataView.profileImage.flex.markDirty()
        contentView.flex.layout(mode: .adjustHeight)
        
        renderAnimateEmoji()
    }
    
    private func renderAnimateEmoji(){
        
        let reactionContainer = chatContentsView.reactionContainer
        reactionContainer.subviews.forEach {
            if $0 is UITextView{
                let textView = $0 as? UITextView
                textView!.setAnimationEmoji()
            }
        }
        chatContentsView.chatLabel.setAnimationEmoji()
        chatContentsView.messageDataView.chatLabel.setAnimationEmoji()
    }
    
    private func removeSubviews(_ view:UIView){
        view.subviews.forEach{
            $0.removeFromSuperview()
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        layout()
        return contentView.frame.size
    }
}
