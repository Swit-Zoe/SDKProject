
import UIKit
import FlexLayout
import SnapKit
import TTTAttributedLabel
import Nantes
import RichString


class ChatCell: UITableViewCell {
    static let reuseIdentifier = "ChatCellView"
    fileprivate let padding: CGFloat = 10
    fileprivate let nameLabel = UILabel()
    //    fileprivate let chatLabel2 : NantesLabel = .init(frame: .zero)
    let chatLabel = UITextView()
    
    fileprivate let timeLabel = UILabel()
    fileprivate let timeNameContainer = UIView()
    fileprivate let textContentContainer = UIView()
    fileprivate let reactionContainer = UIView()
    fileprivate let commentContainer = UIView()
    fileprivate let dayChangeView = UIView()
    fileprivate let dayChangeLabel : UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    fileprivate let notiView = UIView()
    fileprivate let notiViewLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        
        return label
    }()
    
    let linkPreviewContainer = UIView()
    fileprivate let profileImage:UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 24
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    fileprivate let imageDic = [true:UIImage(named: "profile"),false:UIImage(named: "profile")]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        selectionStyle = .default
        setFlex()
        layout()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .default
        selectedBackgroundView = UIView().then{
            $0.backgroundColor = .clear
        }
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
        
        setFlex()
        layout()
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
    
    fileprivate func setFlex(){
        dayChangeView.subviews.forEach{
            $0.removeFromSuperview()
        }
        commentContainer.subviews.forEach{
            $0.removeFromSuperview()
        }
        reactionContainer.subviews.forEach{
            $0.removeFromSuperview()
        }
        contentView.subviews.forEach{
            $0.removeFromSuperview()
        }
        
        
        contentView.flex
            .paddingHorizontal(16)
            .direction(.column)
            .paddingVertical(8)
            .define { (flex) in
                flex.addItem(dayChangeView)
                    .direction(.row)
                    .height(16)
                    .marginTop(16)
                    .justifyContent(.center)
                    .backgroundColor(.clear)
                    .define{ flex in
                        
                        flex.addItem()
                            .direction(.row)
                            .height(1)
                            .width(3000)
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
                            .width(3000)
                            .backgroundColor(.systemGray5)
                            .alignSelf(.center)
                            .define{ flex in}
                    }
                
                flex.addItem(notiView)
                    .marginTop(0)
                    //.height(30)
                    .left(0).right(0)
                    .direction(.row)
                    .alignSelf(.center)
                    .justifyContent(.center)
                    .backgroundColor(.systemGray5)
                    .define{ flex in
                        flex.addItem(notiViewLabel)
                            .width(110%)
                            .padding(2)
                            .direction(.row)
                            .backgroundColor(.clear)
                            .alignSelf(.center)
                            .define{ flex in}
                    }

                
                flex.addItem()
                    .direction(.row)
                    .right(0)
                    .marginTop(8)
                    .left(0)
                    .define { flex in
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
                                
                                flex.addItem(commentContainer)
                                    .direction(.row)
                                    .marginTop(16)
                                    .marginRight(16)
                                    .height(20)
                                    .backgroundColor(.clear)
                                    .define { flex in}
                                
                                flex.addItem(reactionContainer)
                                    .direction(.row)
                                    .wrap(.wrap)
                                    .marginTop(16)
                                    .marginRight(16)
                                    .backgroundColor(.clear)
                                    .define { flex in}
                            }
                    }
            }
    }
    
    func configure(viewModel:ViewModel) {
        selectionStyle = .default
        showAllContents()
        setLabelAndImage(viewModel:viewModel)
        setLayoutHidden(viewModel:viewModel)
        setReactionLayout(viewModel:viewModel)
        setCommentLayout(viewModel:viewModel)
        layout()
    }
    
    private func setReactionLayout(viewModel:ViewModel){
        if let reactions = viewModel.reactions ,reactions.count > 0{
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
                    
                    // button.setTitle(title, for: .normal)
                    button.setAttributedTitle(title, for: .normal)
                    button.titleLabel?.font = UIFont.regular
                    button.layer.cornerRadius = 4
                    button.layer.borderColor = UIColor.darkGray.cgColor
                    button.layer.borderWidth = 1
                    
                    let textView = UITextView().then {
                        $0.isEditable = true
                        $0.isSelectable = false
                        $0.isScrollEnabled = false
                        $0.attributedText = title//NSAttributedString(string: ":partycat:").fontSize(22) + num
                        $0.backgroundColor = .clear
                        $0.layer.borderColor = UIColor.darkGray.cgColor
                        $0.layer.borderWidth = 1
                        $0.textAlignment = .center
                        $0.layer.cornerRadius = 4
                        $0.sizeToFit()
                    }
                    textView.setNeedsLayout()
                    
                    flex.addItem(textView)
                        .height(35)
                        //.width(textView.intrinsicContentSize.width + 20)
                        .marginTop(8)
                        .marginRight(8)
                        .justifyContent(.center)
                    textView.setLottieEmoji()
                    //textView.layoutIfNeeded()
                    //textView.convertGif()
                  //  textView.configureEmojis(EmojiUtils.exampleEmojis,rendering: .highestQuality)
                    
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
        if let msgCmtCnt = viewModel.msgCmtCnt, msgCmtCnt > 0{
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
            }
        }else{
            commentContainer.flex.display(.none)
        }
    }
    
    private func setLayoutHidden(viewModel:ViewModel){
        //MARK: day change label - 날짜바뀜 표시
        if viewModel.chatType == "day"{
            // dayChangeView.isHidden = false
            dayChangeView.flex.display(.flex)
            dayChangeLabel.flex.display(.flex)
            
            notiView.flex.display(.none)
            notiViewLabel.flex.display(.none)
            
            dayChangeLabel.text = viewModel.bodyText
            dayChangeLabel.flex.markDirty()
            
            hideTextContentContainer()
            selectionStyle = .none
            layout()
            return
        }else{
            dayChangeLabel.flex.display(.none)
            dayChangeView.flex.display(.none)
        }
        
        //MARK: noti label - 누가누가 입장, 퇴장
        if viewModel.notiJSON != nil {
            dayChangeView.flex.display(.none)
            dayChangeLabel.flex.display(.none)
            
            notiView.flex.display(.flex)
            notiViewLabel.flex.display(.flex)
            
            notiViewLabel.text = viewModel.bodyText
            notiViewLabel.flex.markDirty()
            
            hideTextContentContainer()
            selectionStyle = .none
        }else{
            notiView.flex.display(.none)
            notiViewLabel.flex.display(.none)
        }
    }
    
    private func hideTextContentContainer(){
        nameLabel.flex.display(.none)
        timeLabel.flex.display(.none)
        
        textContentContainer.flex.display(.none)
        profileImage.flex.display(.none)
        
    }
    
    private func showAllContents(){
        nameLabel.flex.display(.flex)
        timeLabel.flex.display(.flex)
        textContentContainer.flex.display(.flex)
        profileImage.flex.display(.flex)
        dayChangeLabel.flex.display(.flex)
        notiViewLabel.flex.display(.flex)
        reactionContainer.flex.display(.flex)
        commentContainer.flex.display(.flex)
    }
    
    private func setLabelAndImage(viewModel:ViewModel){
        nameLabel.text = viewModel.userName
        nameLabel.flex.markDirty()
        
        timeLabel.text = viewModel.created
        timeLabel.flex.markDirty()
        
        chatLabel.attributedText = viewModel.text
        chatLabel.flex.markDirty()
        
        chatLabel.isEditable = false
        chatLabel.dataDetectorTypes = .link
        
        profileImage.image = imageDic[true]!
        
        //MARK: if same person send a message at the same minute
        if viewModel.userName == nil{
            profileImage.flex.height(0)
        }else{
            profileImage.flex.height(48)
        }
        
        chatLabel.setLottieEmoji()
      //  chatLabel.configureEmojis(EmojiUtils.exampleEmojis)
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
