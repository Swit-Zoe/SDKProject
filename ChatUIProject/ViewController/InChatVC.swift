//
//  ViewController.swift
//  ChatUIProject
//
//  Created by park kevin on 2021/12/26.
//


import UIKit
import RxKeyboard
import RxSwift
import RxCocoa
import SnapKit
import RealmSwift
import RichString
import SwiftUI
import Nantes
import TTTAttributedLabel
import LinkPresentation
import Differ
import DifferenceKit

class InChatVC: UIViewController {

    
    
    // MARK: View
    let tableView:UITableView = UITableView()
    let messageInputBar = MessageInputBar(frame: .zero)
    let toolChainView:ToolChainView = ToolChainView()
    
    // MARK: Model
    
    var keyboardH:CGFloat = 0
    let disposeBag = DisposeBag()
  //  let realm = try! Realm()
    var chatViewModelService = ChatViewModelService()
    var viewModel = [ViewModel]()

    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chat Control"

        setToolChainView()
        setMessageInputBar()
        setTableView()
        setKeyboardNotification()
        
        render()
        initKeyCommands()
        
        chatViewModelService.chatViewModel.observe(on:
                                                        /*MainScheduler.instance*/
                                                      ConcurrentDispatchQueueScheduler(qos: .default))
            .scan([ViewModel]()) {[weak self] in
                guard let self = self else {return $1}
//                self.tableView.animateRowChanges(
//                    oldData: oldValue,
//                    newData: self.chatList!.data,
//                    deletionAnimation: .middle,
//                    insertionAnimation: .middle)

                let changeset = StagedChangeset(source: $0, target: $1)

                DispatchQueue.main.async {
                    self.tableView.reload(using: changeset, with: .right) { data in
                        self.viewModel = data
                    }
                }
                  return $1
               }
            .subscribe(onNext:{element in
            }).disposed(by: disposeBag)
        chatViewModelService.fetchRepo()

      //  tableView.reloadData()
    }

    // MARK: Keyboard Noti Setting
    private func setKeyboardNotification(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        tapGesture.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(tapGesture)
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                print("keyboard : \(keyboardVisibleHeight)")
                guard let `self` = self else { return }
                self.toolChainView.snp.updateConstraints {
                    if self.keyboardH >= keyboardVisibleHeight{
                        $0.height.equalTo(0)
                        if #available(iOS 15.0, *){}else {
                            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-keyboardVisibleHeight)
                        }
                        //self.tableView.contentOffset.y -= self.keyboardH
                    }else{
                        $0.height.equalTo(64)
                        if #available(iOS 15.0, *){}else {
                            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-keyboardVisibleHeight + self.view.safeAreaInsets.bottom)
                        }
                        self.tableView.contentOffset.y += keyboardVisibleHeight + self.view.safeAreaInsets.bottom
                    }
                }
                
                self.keyboardH = keyboardVisibleHeight
                
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            })
            .disposed(by: self.disposeBag)
        //TODO: ????????? ????????? ?????????????????? onNext ??? ?????? ??????????????? ????????? ???????????? ????????? ??????????????? ????????? ?????????????????? ?????????
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        messageInputBar.textView.resignFirstResponder()
    }
    
    // MARK: View Setting
    private func setTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(messageInputBar.snp.top)
        }
        
        tableView.register(ChatCell.classForCoder(), forCellReuseIdentifier: ChatCell.reuseIdentifier)
        
        tableView.rowHeight = UITableView.automaticDimension // dynamic cell height ??????
        tableView.separatorColor = .clear
        tableView.allowsMultipleSelection = false
        tableView.keyboardDismissMode = .interactive
        tableView.alwaysBounceVertical = true
    }
    
    private func setToolChainView(){
        view.addSubview(toolChainView)
        
        toolChainView.snp.makeConstraints {
            
            //$0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            if #available(iOS 15.0, *) {
                $0.leading.trailing.equalTo(view.keyboardLayoutGuide)
                $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-view.safeAreaInsets.bottom)
                self.view.keyboardLayoutGuide.followsUndockedKeyboard = true
            } else {
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }
            $0.height.equalTo(0)
        }
        toolChainView.textButton.addTarget(self, action: #selector(toolChainFontViewSet), for: .touchUpInside)
        toolChainView.rightArrowButton.addTarget(self, action: #selector(toolChainFontViewSet), for: .touchUpInside)
        
        toolChainView.boldButton.addTarget(self, action: #selector(fontSet), for: .touchUpInside)
        toolChainView.italicButton.addTarget(self, action: #selector(fontSet), for: .touchUpInside)
        toolChainView.lineButton.addTarget(self, action: #selector(fontSet), for: .touchUpInside)
        toolChainView.backColorButton.addTarget(self, action: #selector(fontSet), for: .touchUpInside)
        toolChainView.linkButton.addTarget(self, action: #selector(fontSet), for: .touchUpInside)
    }
    
    private func setMessageInputBar(){
        messageInputBar.textView.delegate = self
        
        view.addSubview(messageInputBar)
        
        messageInputBar.snp.makeConstraints {
            $0.bottom.equalTo(toolChainView.snp.top)
            $0.leading.equalToSuperview().offset(-3)
            $0.trailing.equalToSuperview().offset(3)
            $0.height.equalTo(48)
        }
        messageInputBar.sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
    }
    // MARK: add Key Commands
    private func initKeyCommands() {
        KeyCommands.allCases.forEach { keyCommand in
            addKeyCommand(keyCommand.command)
        }
    }
    
    // MARK: SendMessage
    @objc func sendMessage() {
        
//        let chatModel = ChatModel()
//        chatModel.name = chatViewModel.ns[Int.random(in: 0..<5)]
//        chatModel.time = Date()
//        chatModel.content = messageInputBar.textView.attributedText.attributedStringToRtf
//        print(chatModel.content!)
//
//        realm.beginWrite()
//        realm.add(chatModel)
//        try! realm.commitWrite()
        
        messageInputBar.textView.text = nil
        messageInputBar.textView.attributedText = nil
        messageInputBar.placeHolerLabel.isHidden = false
        messageInputBar.sendButton.isEnabled = false
        
        messageInputBar.snp.updateConstraints{
            $0.height.equalTo(MessageInputBar.Size.minHeight)
        }
        
 //       chatViewModel.add(chatModel:chatModel)
        tableView.reloadData()
        
   //     print(chatViewModel.CI!.count)
        
   //     tableView.scrollToRow(at: IndexPath(row: chatViewModel.CI!.count - 1, section: 0), at: .bottom, animated: true)
    }
    // MARK: toolChainFontSet
    @objc func toolChainFontViewSet() {
        toolChainView.setFontView(toolChainView.fontView.isHidden)
    }
    
    @objc func fontSet(sender : UIButton) {
        sender.isSelected = !sender.isSelected
        let selected = sender.isSelected
        
        if sender != toolChainView.linkButton{
            if selected{
                sender.backgroundColor = .systemGray5
            }else{
                sender.backgroundColor = .clear
            }
        }else{
            sender.backgroundColor = .systemGray5
            linkAlert()
        }
       
        if selected{
            switch(sender){
            case toolChainView.boldButton:
                toolChainView.fontType.font = UIFont.bold
                break
            case toolChainView.italicButton:
                toolChainView.fontType.italic = 0.3
                break
            case toolChainView.lineButton:
                toolChainView.fontType.line = toolChainView.fontType.fontColor
                break
            case toolChainView.backColorButton:
                toolChainView.fontType.backColor = .darkGray
                toolChainView.fontType.fontColor = .systemRed
                if toolChainView.fontType.line != .clear{
                    toolChainView.fontType.line = toolChainView.fontType.fontColor
                }
                break
            default:
                break
            }
        }else{
            switch(sender){
            case toolChainView.boldButton:
                toolChainView.fontType.font = UIFont.regular
                break
            case toolChainView.italicButton:
                toolChainView.fontType.italic = 0.0
                break
            case toolChainView.lineButton:
                toolChainView.fontType.line = .clear
                break
            case toolChainView.backColorButton:
                toolChainView.fontType.backColor = .clear
                toolChainView.fontType.fontColor = .labelColor
                if toolChainView.fontType.line != .clear{
                    toolChainView.fontType.line = toolChainView.fontType.fontColor
                }
                break
            default:
                break
            }
        }
      
        
        setSelectedCursorFont(messageInputBar.textView)
    }
    //MARK: setSelectedCursorFont
    func setSelectedCursorFont(_ textView:UITextView){
        let range = textView.selectedRange
        
        if range.length > 0{
            let attM = NSMutableAttributedString(attributedString: textView.attributedText)
            
            let s1 = attM.attributedSubstring(
                from:NSRange(location: range.lowerBound, length: range.length)
            ).backgroundColor(toolChainView.fontType.backColor)
                .font(toolChainView.fontType.font)
                .color(toolChainView.fontType.fontColor)
                .obliqueness(toolChainView.fontType.italic)
                .strikeThrough(style: .single)
                .strikeThrough(color: toolChainView.fontType.line)
     
            attM.replaceCharacters(in: range, with: s1)
            textView.attributedText = attM
            textView.selectedRange = range
        }
        
    }
    
    func render(){
        
//        let chatModels = realm.objects(ChatModel.self)
//
//        for cm in chatModels{
//            chatViewModel.add(chatModel: cm)
//        }
//
//
//        tableView.reloadData()
//
//        if chatViewModel.CI!.count > 0 {
//            tableView.scrollToRow(at: IndexPath(row: chatViewModel.CI!.count - 1, section: 0), at: .bottom, animated: true)
//        }
    }
    
    // MARK: Alert Control
    private func showTooLongAlert(){
        let controller = UIAlertController(title: "It's too long", message: "Up to \(MessageInputBar.Size.maxLength) character can be entered.", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default)
        controller.addAction(confirmAction)
        
        self.present(controller, animated: true, completion: nil)
    }
    
    // MARK: Alert Control
    private func linkAlert(){
        let controller = UIAlertController(title: "Add link", message: nil, preferredStyle: .alert)
        controller.addTextField { textField in
            textField.layer.cornerRadius = 4
            textField.placeholder = "text"
        }
        controller.addTextField { textField in
            textField.layer.cornerRadius = 4
            textField.placeholder = "link"
        }
        let confirmAction = UIAlertAction(title: "Confirm", style: .default){_ in
            guard let urlString = controller.textFields?[1].text else {
                return
            }
            guard let url = NSURL(string:urlString) else{
                return
            }

            guard let linkString = controller.textFields?[0].text?.link(url: url).fontSize(16).underline(style: .single).underline(color: .linkColor) else {return}
            let attM = NSMutableAttributedString(attributedString: self.messageInputBar.textView.attributedText)
            attM.insert(linkString, at: self.messageInputBar.textView.selectedRange.lowerBound)
            
            self.messageInputBar.textView.attributedText = attM
            self.messageInputBar.textView.delegate?.textViewDidChange!(self.messageInputBar.textView)
            self.toolChainView.linkButton.backgroundColor = .clear
            
        }
        controller.addAction(confirmAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel ){_ in
            self.toolChainView.linkButton.backgroundColor = .clear
        }
        controller.addAction(cancelAction)
        
        self.present(controller, animated: true, completion: nil)
    }
}

// MARK: TableView Extension
extension InChatVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.reuseIdentifier, for: indexPath) as! ChatCell
        
        //cell.prepareForReuse()
        let idx = indexPath.row
       // let pc = idx > 0 ? viewModel[idx - 1]:nil
        cell.configure(viewModel: viewModel[idx])
        
//        cell.chatLabel.detectLink{
//            cell.linkPreviewContainer.flex.addItem($0)
//            cell.linkPreviewContainer.flex.markDirty()
//           // self.tableView.reloadData()
//            print("asdf")
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}

// MARK: TextView Extension
extension InChatVC:UITextViewDelegate{
    func textViewDidEndEditing(_ textView: UITextView) {
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        messageInputBar.placeHolerLabel.isHidden = !textView.text.isEmpty
        messageInputBar.sendButton.isEnabled = !textView.text.isEmpty
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {

    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.isSingleEmoji{

        }else{
            let attM = NSMutableAttributedString(attributedString: textView.attributedText)

         
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01){
                    attM.replaceCharacters(in: range, with: self.setFont(text))
                    textView.attributedText = attM
                    textView.selectedRange = NSRange(location: range.lowerBound + text.count, length: 0)

                }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
                self.messageInputBar.previousLength = self.messageInputBar.textView.text.count
            }
        }
        return true
    }
    
    func setFont(_ s:String) -> NSAttributedString{
        
        let result = s
            .backgroundColor(toolChainView.fontType.backColor)
            .font(toolChainView.fontType.font)
            .color(toolChainView.fontType.fontColor)
            .obliqueness(toolChainView.fontType.italic)
            .strikeThrough(style: .single)
            .strikeThrough(color: toolChainView.fontType.line)
        return result
    }
    
    func getRange(_ textView:UITextView) -> UITextRange{
        
        let begin = textView.beginningOfDocument
        let start = textView.position(from: begin, offset: textView.selectedRange.location)
        let end = textView.position(from: textView.position(from: start!, offset: 0)!, offset: -1)
        let range = textView.textRange(from: start!, to: end!)
        return range!
    }

    
    func textViewDidChange(_ textView: UITextView) {
        var height = MessageInputBar.Size.minHeight
        if textView.contentSize.height <= MessageInputBar.Size.minHeight {
            height = MessageInputBar.Size.minHeight
        } else if textView.contentSize.height >= MessageInputBar.Size.maxHeight {
            height = MessageInputBar.Size.maxHeight
        } else {
            height = textView.contentSize.height
        }
        switch textView{
        case messageInputBar.textView :
            messageInputBar.snp.updateConstraints{
                $0.height.equalTo(height)
            } // ???????????? ???????????? ?????? ?????? ?????? ??????
        default :
            break
        }
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
        
        messageInputBar.placeHolerLabel.isHidden = !textView.text.isEmpty
        messageInputBar.sendButton.isEnabled = !textView.text.isEmpty
        
        if textView.text.count > MessageInputBar.Size.maxLength{
//            let startIdx = textView.text.startIndex
//            let endIdx = textView.text.index(startIdx, offsetBy: MessageInputBar.Size.maxLength)
//            textView.text = String(textView.text[startIdx..<endIdx])
            
            //self.showTooLongAlert()
            messageInputBar.sendButton.isEnabled = false
        }else{
            messageInputBar.sendButton.isEnabled = true
        }
        
        print("textViewChanged")
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        print(URL)
        return true
    }
    
    
}
extension InChatVC:NantesLabelDelegate{
    func attributedLabel(_ label: NantesLabel, didSelectAddress addressComponents: [NSTextCheckingKey : String]) {
        
    }
    
    func attributedLabel(_ label: NantesLabel, didSelectDate date: Date, timeZone: TimeZone, duration: TimeInterval) {
        
    }
    
    func attributedLabel(_ label: NantesLabel, didSelectLink link: URL) {
        print("Tapped link: \(link)")
    }
    
    func attributedLabel(_ label: NantesLabel, didSelectPhoneNumber phoneNumber: String) {
        
    }
    
    func attributedLabel(_ label: NantesLabel, didSelectTextCheckingResult result: NSTextCheckingResult) {
        
    }
    
    func attributedLabel(_ label: NantesLabel, didSelectTransitInfo transitInfo: [NSTextCheckingKey : String]) {
        
    }
}

extension InChatVC:TTTAttributedLabelDelegate{
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        print("Tapped link: \(url)")
    }
}

// MARK: - KeyCommandActionProtocol

extension InChatVC: KeyCommandActionProtocol {
    func pressEnter() {
        sendMessage()
        print("Enter Pressed")
    }
    
    func pressNewLine() {
        //textView.insertText("\n")
        print("New Line")
    }
    func dummy(){}
}
