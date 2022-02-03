//
//  ViewController.swift
//  ChatUIProject
//
//  Created by park kevin on 2021/12/26.
//


import UIKit
import RxKeyboard
import RxFlow
import RxSwift
import RxCocoa
import SnapKit
import RealmSwift
import RichString

//import Nantes
//import TTTAttributedLabel
//import LinkPresentation
import Differ
import DifferenceKit
import Typist

protocol InChatVCDelegate{
    func backTapped()
    func messageTapped()
}

class InChatVC: UIViewController,Stepper {
    var steps: PublishRelay<Step> = PublishRelay<Step>()
    
    var inChatVCDelegate:InChatVCDelegate?
    
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
    
    @objc func back(){
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setToolChainView()
        setMessageInputBar()
        setTableView()
        setKeyboardNotification()
        
        render()
        initKeyCommands()
        
        subscribeViewModel()
        
        let backItem = UIBarButtonItem(image: UIImage(systemName:"chevron.backward"),
                                        style: .done,
                                        target: self,
                                       action: #selector(finish))
        backItem.tintColor = .label
        navigationItem.leftBarButtonItem = backItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
     //   self.tabBarController?.tabBar.isHidden = true
        print("viewModelCount: \(viewModel.count)")

        view.backgroundColor = .chatBackgroundColor
        tableView.backgroundColor = .chatBackgroundColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //print("sadfasdf")
        if self.isMovingFromParent {
          //  inChatVCDelegate?.backTapped()
        }
    }
    
    // MARK: Keyboard Noti Setting
    private func setKeyboardNotification(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        tapGesture.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(tapGesture)

        Typist.shared
            .toolbar(scrollView: tableView)
            .on(event: .willChangeFrame) { [unowned self] options in
                let height = options.endFrame.height
                if self.toolChainView.frame.height != 0 {
                    UIView.animate(withDuration: 0.5) {
                        self.toolChainView.snp.updateConstraints {c in
                            c.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
                                .offset(-height + self.view.safeAreaInsets.bottom)
                        }
                    }
                }
            }.on(event: .willHide) { [unowned self] options in
                UIView.animate(withDuration: options.animationDuration,
                               delay: 0,
                               options: UIView.AnimationOptions(curve: options.animationCurve)) {
                    self.toolChainView.snp.updateConstraints {c in
                    c.height.equalTo(0)
                        c.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
                    }
                }
                
            }.on(event: .willShow) { [unowned self] options in
                let height = options.endFrame.height
                self.toolChainView.snp.updateConstraints {c in
                    UIView.animate(withDuration: options.animationDuration,
                                   delay: 0,
                                   options: UIView.AnimationOptions(curve: options.animationCurve)) {
                        c.height.equalTo(64)
                        c.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
                            .offset(-height + self.view.safeAreaInsets.bottom)
                    }
                    self.tableView.contentOffset.y += height
                }
            }.start()
        
        //TODO: 키보드 높이가 변경될때마다 onNext 가 계속 호출되어야 하지만 키보드가 완전히 나타나거나 완전히 사라질때에만 호출됨 -> 해결
    }
    
    private func subscribeViewModel(){
        chatViewModelService.chatViewModel.observe(on:
                                                    /*MainScheduler.instance*/
                                                   ConcurrentDispatchQueueScheduler(qos: .default))
            .scan([ViewModel]()) {[weak self] in
                guard let self = self else {return $1}

                let diff = $0.extendedDiff($1)
//                let new = $1
//                let old = $0
//                DispatchQueue.main.async {
//                    self.tableView.animateRowChanges(
//                        oldData: old,
//                        newData: new,
//                        deletionAnimation: .middle,
//                        insertionAnimation: .middle)
//                }

                let changeset = StagedChangeset(source: $0, target: $1)

                DispatchQueue.main.async {
                    self.tableView.reload(using: changeset, with: .right) { data in
                        self.viewModel = data
                        diff.elements.forEach{
                            switch($0){
                                
                            case .delete(at: let at):
                                self.tableView.scrollToRow(
                                    at: IndexPath(row: at, section: 0),
                                    at: .bottom, animated: true)
                            
                            case .insert(at: let at):
                                let indexPath = IndexPath(row: at, section: 0)
                                if self.tableView.hasRowAtIndexPath(indexPath: indexPath as NSIndexPath) {
                                    self.tableView.scrollToRow(
                                        at: indexPath,
                                        at: .bottom, animated: true)
                                }
                                
                            
                            default:
                                break
                            }
                           
                        }
                     //   diff.elements.firstIndex(where: )
                    }
                }
                
                return $1
            }
            .subscribe(onNext:{element in
            }).disposed(by: disposeBag)
        chatViewModelService.fetchRepo()
                
//        DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
//            self.tableView.scrollToRow(
//                at: IndexPath(row: self.viewModel.count - 1, section: 0),
//                at: .bottom, animated: true)
//        }
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
        tableView.register(NotiCell.classForCoder(), forCellReuseIdentifier: NotiCell.reuseIdentifier)
        tableView.register(DayCell.classForCoder(), forCellReuseIdentifier: DayCell.reuseIdentifier)
        
        tableView.rowHeight = UITableView.automaticDimension // dynamic cell height 적용
        tableView.separatorColor = .clear
        tableView.allowsMultipleSelection = false
        tableView.keyboardDismissMode = .interactive
        tableView.alwaysBounceVertical = true
    }
    
    private func setToolChainView(){
        view.addSubview(toolChainView)
        
        toolChainView.snp.makeConstraints {
            
            //$0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
//            if #available(iOS 15.0, *) {
//                $0.leading.trailing.equalTo(view.keyboardLayoutGuide)
//                $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-view.safeAreaInsets.bottom)
//                self.view.keyboardLayoutGuide.followsUndockedKeyboard = true
//            } else {
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
           // }
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
    
    @objc func finish() {
        print(#function)
        _ = navigationController?.popViewController(animated: true)
    }
}

// MARK: TableView Extension
extension InChatVC:UITableViewDelegate,UITableViewDataSource{
    func setCell<T:InChatCell>(type: T.Type,indexPath:IndexPath) -> T {
        let cell = tableView.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
        
        let idx = indexPath.row
        
        if idx < viewModel.count {
            cell.configure(viewModel: viewModel[idx])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idx = indexPath.row
        
        let vm = viewModel[idx]
        
        if vm.chatType == "day"{
            return setCell(type: DayCell.self, indexPath: indexPath)
        }else if vm.notiJSON != nil{
            return setCell(type: NotiCell.self, indexPath: indexPath)
        }else{
            return setCell(type: ChatCell.self, indexPath: indexPath)
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        steps.accept(FlowStep.toInChatComment(withMessageID:indexPath.row))
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
            } // 텍스트뷰 컨텐츠에 따라 높이 제약 변경
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
/*
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
*/
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
