# RATextField
This library is designed for code programmatically. It can work with UIStoryboard but doesn't support IBDesignable.

## Installation
- Copy the src folder to your project
- Open Info.plist as Source code and paste the code below
```
<key>UIAppFonts</key>
	<array>
        <string>OpenSans-Bold.ttf</string>
        <string>OpenSans-Light.ttf</string>
        <string>OpenSans-Regular.ttf</string>
        <string>OpenSans-SemiBold.ttf</string>
	</array>
```


## How to use
1. Initialization
```
let titleTextField = RATextField(label: "Username")
let prefixTextField = RATextField(prefix: "+84")
let suffixTextField = RATextField(suffix: "CUR")
let leftIconTextField = RATextField(leftIcon: UIImage(named: "mail")!)
let rightIconTextField = RATextField(rightIcon: UIImage(named: "check-mark")!)
let textLinkTextField = RATextField(label: "Hello text link", textLink: "See more")
```

By default, the a `FormatOption` is sent with the init function, you can customize the textfield UI by sending your `FormatOption`
```
let titleWithFormatTextField = RATextField(label: "Username",
                                           option: RATextField.FormatOption(
                                                titleColor: UIColor.blue,
                                                iconColor: UIColor.brown))
```

2. Error state
```
errorTextField.setError(visible: true, content: "Your username was registered")
errorTextField.setError(visible: false)
```

3. Show helper text

```
helperTextField.setHelper(visible: true, content: "Password must have 8 letters at least")
helperTextField.setHelper(visible: false)
```

4. Set static state
```
prefixTextField.setStatic(isEnabled: true)
```

Helper text is optional

5. Delegate

Please use `raDelegate: RATextFieldDelegate` instead of `delegate`
