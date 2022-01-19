# 겪은 문제

## 1. pod install 에러
- pod install 명령어를 실행하였지만 아래와 같은 에러 발생
```
parkkevin@parkui-MacBookPro ChatUIProject % pod install

[!] Invalid `Podfile` file: syntax error, unexpected tCONSTANT, expecting end
  pod 'RxCocoa'
       ^~~~~~~
/Users/parkkevin/Desktop/ChatUIProject/Podfile:12: syntax error, unexpected tCONSTANT, expecting end-of-input
  pod 'RxSwift'
       ^~~~~~~.

 #  from /Users/parkkevin/Desktop/ChatUIProject/Podfile:11
 #  -------------------------------------------
 #    pod 'RxKeyboard
 >    pod 'RxCocoa'
 #    pod 'RxSwift'
 #  -------------------------------------------
parkkevin@parkui-MacBookPro ChatUIProject % vi podfile
parkkevin@parkui-MacBookPro ChatUIProject % vi podfile
parkkevin@parkui-MacBookPro ChatUIProject % pod install
Analyzing dependencies
/Library/Ruby/Gems/2.6.0/gems/ffi-1.15.4/lib/ffi/library.rb:275: [BUG] Bus Error at 0x0000000100594000
ruby 2.6.8p205 (2021-07-07 revision 67951) [universal.arm64e-darwin21]

-- Crash Report log information --------------------------------------------
   See Crash Report log file under the one of following:                    
     * ~/Library/Logs/DiagnosticReports                                     
     * /Library/Logs/DiagnosticReports                                      
   for more details.                                                        
Don't forget to include the above Crash Report log file in bug reports.     

-- Control frame information -----------------------------------------------
.
.
.
.
.
.
  632 /Library/Ruby/Gems/2.6.0/gems/ffi-1.15.4/lib/ffi/variadic.rb
  633 /Library/Ruby/Gems/2.6.0/gems/ffi-1.15.4/lib/ffi/enum.rb
  634 /Library/Ruby/Gems/2.6.0/gems/ffi-1.15.4/lib/ffi/version.rb
  635 /Library/Ruby/Gems/2.6.0/gems/ffi-1.15.4/lib/ffi/ffi.rb
  636 /Library/Ruby/Gems/2.6.0/gems/ffi-1.15.4/lib/ffi.rb

[NOTE]
You may have encountered a bug in the Ruby interpreter or extension libraries.
Bug reports are welcome.
For details: https://www.ruby-lang.org/bugreport.html

[IMPORTANT]
Don't forget to include the Crash Report log file under
DiagnosticReports directory in bug reports.

```

### 해결
- 원인 : M1 과의 호환성 문제로 인해 ffi 를 재설치하고   arm 아키텍쳐에 맞는 명령어실행
```
parkkevin@parkui-MacBookPro ChatUIProject % sudo arch -x86_64 gem install ffi
Password:
Building native extensions. This could take a while...
Successfully installed ffi-1.15.4
Parsing documentation for ffi-1.15.4
Done installing documentation for ffi after 3 seconds
1 gem installed
parkkevin@parkui-MacBookPro ChatUIProject % arch -x86_64 pod install
```
## 참조
https://ondemand.tistory.com/340



## 2. RxKeyboard 적용중 키보드를 움직일 시 실시간으로 OnNext가 호출되지 않는 문제

``` swift
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                print(keyboardVisibleHeight)
                guard let `self` = self else { return }
                self.toolChainView.snp.updateConstraints {
                    if self.keyboardH > keyboardVisibleHeight{
                        $0.height.equalTo(0)
                        $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-keyboardVisibleHeight)
                        self.tableView.contentOffset.y -= self.keyboardH
                        
                    }else{
                        $0.height.equalTo(64)
                        $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-keyboardVisibleHeight + self.view.safeAreaInsets.bottom)
                        self.tableView.contentOffset.y += keyboardVisibleHeight
                    }
                }
                
                self.keyboardH = keyboardVisibleHeight
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            })
            .disposed(by: self.disposeBag)
        // 키보드 높이가 변경될때마다 onNext 가 계속 호출되어야 하지만 키보드가 완전히 나타나거나 완전히 사라질때에만 호출됨
        // 추후 수정해야함
```

### 해결
- 원인 : ??
- 임시해결 : Ios15 버전 이상부터 view.keyboardLayout 의 Top Anchor 와 Toolbar의   
bottom Anchor 를 일치시킴
