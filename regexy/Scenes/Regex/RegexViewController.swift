//
//  RegexViewController.swift
//  regexy
//
//  Created by Augusto Avelino on 19/03/24.
//

import UIKit
import RegexBuilder

class RegexViewController: DSViewController {
    
    // MARK: Properties
    
    let dao: RegexDAOProtocol
    let regex = RegexEvaluator()
    var content: String { contentTextView.text }
    
    private var isSliderHidden: Bool = true
    private var sliderTopConstraint: NSLayoutConstraint?
    
    // MARK: UI
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16.0
        return stackView
    }()
    let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8.0
        return stackView
    }()
    let regexTextField = RegexTextField()
    let contentTextView = RegexTextView()
    let copyButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "doc.on.doc")
        configuration.buttonSize = .small
        return UIButton(configuration: configuration)
    }()
    let sliderView = DSSliderView(initialValue: 0.5)
    
    // MARK: - Life cycle
    
    init(dao: RegexDAOProtocol) {
        self.dao = dao
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // TODO: Remove lorem ipsum
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTextView.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec consequat libero tellus, in aliquet ligula aliquet vitae. Cras ullamcorper nisl arcu, vitae ornare massa tristique dictum. Cras neque sapien, porta nec mauris vel, imperdiet dignissim erat. Nam semper ut nisl in sodales. Vestibulum placerat tellus et felis tincidunt bibendum. Duis condimentum lorem eget est bibendum elementum. Aliquam at maximus mauris, vitae imperdiet massa. Nullam id maximus velit, id efficitur augue. Suspendisse potenti. Proin sodales eget turpis sit amet tempus. Vestibulum mollis erat in lacus hendrerit facilisis. In euismod ipsum aliquam, fermentum lacus quis, elementum diam. In elementum facilisis convallis. Aenean non eros et libero efficitur laoreet.\n\nMauris vulputate erat massa, sed dignissim risus semper id. Nunc bibendum, nisi non posuere bibendum, justo nibh viverra tortor, id faucibus lectus erat sodales magna. Morbi quis blandit risus. Quisque sed ultrices diam, vitae pellentesque lacus. Etiam quis ultrices ante. In eleifend ex sit amet rutrum porta. Cras eu dapibus sapien. Curabitur aliquet rutrum eros. Donec sollicitudin felis cursus, feugiat lacus rhoncus, vulputate purus. Maecenas hendrerit placerat velit, in eleifend odio consequat sollicitudin. Fusce euismod velit ipsum, ultricies tincidunt enim finibus a. Quisque vel purus elit. Vestibulum porta ac dolor sit amet viverra. Donec dignissim turpis quis odio semper, a laoreet nisl vehicula. Suspendisse placerat vitae libero at elementum. Aenean scelerisque mi ex, at pellentesque metus facilisis vitae.\n\nQuisque ex lacus, interdum nec leo sed, consequat lacinia mi. Interdum et malesuada fames ac ante ipsum primis in faucibus. Integer a lectus ac est cursus porta. Vestibulum turpis eros, ultrices vel augue sit amet, accumsan dictum nisl. Duis scelerisque auctor arcu nec ullamcorper. Mauris id tempor magna. In hac habitasse platea dictumst. Nam sed iaculis nisl. Vestibulum eros libero, tristique ut est vel, congue molestie felis. Ut nec malesuada magna, non vestibulum velit. Nullam ipsum augue, semper at euismod at, consequat sed sem.\n\nDuis commodo lorem ac tincidunt ornare. Maecenas a consectetur justo. Aenean in sapien hendrerit, vestibulum nisl in, egestas nunc. Fusce suscipit, dolor eget semper fermentum, urna augue blandit odio, eget lacinia erat lectus eu metus. Vivamus sodales pretium orci, ac efficitur nunc. Sed in sollicitudin felis. Maecenas nisi turpis, finibus ut sodales sed, vulputate id leo. Curabitur vel eleifend metus. Suspendisse potenti. Integer sed placerat nulla. In hac habitasse platea dictumst. Maecenas tempor nunc et massa iaculis, tempus hendrerit libero tincidunt. Etiam luctus urna eget ex facilisis pretium. Phasellus condimentum nibh metus, sed pharetra nunc ornare fringilla.\n\nClass aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Interdum et malesuada fames ac ante ipsum primis in faucibus. Praesent tempus nulla arcu, ac imperdiet sem fringilla vitae. Proin elementum aliquam neque, ut accumsan arcu rutrum non. Nulla rutrum at lectus non mollis. Nullam id ante eu ex placerat dictum. Praesent nulla ex, dignissim in fringilla condimentum, sodales quis lectus."
    }
    
    // MARK: - Setup
    
    override func setupUI() {
        setupNavigationBar()
        setupStackView()
        setupInputEvents()
        setupCopyAction()
        setupSliderView()
    }
    
    private func setupNavigationBar() {
        title = "Regexy"
        setupLeftBarButton()
        navigationItem.setRightBarButton(
            UIBarButtonItem(image: UIImage(systemName: "textformat.size"), style: .plain, target: self, action: #selector(didTapFormatText)),
            animated: false)
    }
    
    private func setupLeftBarButton() {
        let saveItem = UIAction(title: "Save Pattern", image: UIImage(systemName: "tray.and.arrow.down.fill")) { [weak self] _ in
            guard let self = self else { return }
            self.didTapSavePattern()
        }
        let loadItem = UIAction(title: "Load Pattern", image: UIImage(systemName: "tray.and.arrow.up.fill")) { [weak self] _ in
            guard let self = self else { return }
            self.didTapLoadPattern()
        }
        navigationItem.setLeftBarButton(
            UIBarButtonItem(image: UIImage(systemName: "tray.full.fill"), menu: UIMenu(children: [
                saveItem,
                loadItem
            ])),
            animated: false)
    }
    
    private func setupStackView() {
        view.addSubview(stackView)
        stackView.constraintToFill(useSafeArea: true, horizontalPadding: 20.0)
        stackView.addArrangedSubview(topStackView)
        topStackView.addArrangedSubview(regexTextField)
        topStackView.addArrangedSubview(copyButton)
        stackView.addArrangedSubview(contentTextView)
    }
    
    private func setupInputEvents() {
        contentTextView.delegate = self
        regexTextField.delegate = self
        regexTextField.addTarget(self, action: #selector(textFieldDidChangeValue), for: .valueChanged)
        regexTextField.addTarget(self, action: #selector(textFieldDidChangeValue), for: .editingChanged)
    }
    
    private func setupCopyAction() {
        copyButton.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            UIPasteboard.general.string = self.regexTextField.text
            self.showToast(withMessage: "Copied pattern to clipboard")
        }, for: .touchUpInside)
    }
    
    private func setupSliderView() {
        view.addSubview(sliderView)
        sliderTopConstraint = sliderView.constraint(
            top: (view.safeAreaLayoutGuide.topAnchor, -12.0),
            trailing: (view.safeAreaLayoutGuide.trailingAnchor, -16.0)
        ).top
        sliderView.alpha = 0.0
        sliderView.isUserInteractionEnabled = false
        sliderView.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    }
    
    private func updateHighlights() {
        do {
            let ranges = try regex.ranges(in: content)
            contentTextView.highlightRanges(ranges)
        } catch {
            print("=== MATCH ERROR ===")
            debugPrint(error)
            print()
        }
    }
    
    // MARK: - Actions
    
    @objc func textFieldDidChangeValue(_ sender: UITextField) {
        regex.setPattern(sender.text)
        updateHighlights()
    }
    
    private func didTapSavePattern() {
        let alert = UIAlertController(title: "Save Pattern", message: "Choose a name", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addTextField { [weak alert] textField in
            let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [weak self, weak textField, weak alert] _ in
                guard let self = self, let textField = textField else { return }
                self.savePattern(withName: textField.text)
                alert?.dismiss(animated: true)
            }
            confirmAction.isEnabled = false
            alert?.addAction(confirmAction)
            textField.addAction(UIAction(handler: { [weak confirmAction, weak textField] _ in
                guard let action = confirmAction, let textField = textField else { return }
                action.isEnabled = !(textField.text?.isEmpty ?? true)
            }), for: .editingChanged)
        }
        present(alert, animated: true)
    }
    
    private func didTapLoadPattern() {
        let destinationBM = SavedPatternsBusinessModel(dao: dao)
        let destinationVM = SavedPatternsViewModel(businessModel: destinationBM)
        let destinationVC = SavedPatternsViewController(viewModel: destinationVM)
        destinationVC.delegate = self
        present(UINavigationController(rootViewController: destinationVC), animated: true)
    }
    
    @objc func didTapFormatText(_ sender: UIBarButtonItem) {
        sender.image = isSliderHidden ? UIImage(systemName: "chevron.up") : UIImage(systemName: "textformat.size")
        isSliderHidden ? showSlider() : hideSlider()
    }
    
    @objc func sliderValueChanged(_ sender: DSSliderView) {
        let value = sender.value - 0.5
        let modifier = 16.0 * value
        contentTextView.fontSize = 16.0 + CGFloat(modifier)
    }
    
    private func showSlider() {
        animateSlider(constant: 0.0, alpha: 1.0, options: .curveEaseOut) { [weak self] _ in
            self?.setSliderState(false)
        }
    }
    
    private func hideSlider() {
        animateSlider(constant: -12.0, alpha: 0.0, options: .curveEaseIn) { [weak self] _ in
            self?.setSliderState(true)
        }
    }
    
    private func animateSlider(constant: CGFloat, alpha: CGFloat, options: UIView.AnimationOptions, completion: @escaping ((Bool) -> Void)) {
        sliderTopConstraint?.constant = constant
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
            self.sliderView.alpha = alpha
        }, completion: completion)
    }
    
    private func setSliderState(_ hidden: Bool) {
        isSliderHidden = hidden
        sliderView.isUserInteractionEnabled = !hidden
    }
    
    private func savePattern(withName patternName: String?) {
        do {
            try dao.create(named: patternName ?? "Untitled", pattern: regexTextField.text ?? "")
            showToast(withMessage: "Pattern saved")
        } catch {
            showToast(withMessage: "Error saving pattern")
            debugPrint(error)
        }
    }
}

// MARK: - SavedPatternsViewControllerDelegate

extension RegexViewController: SavedPatternsViewControllerDelegate {
    func didSelectPattern(_ pattern: String, named name: String) {
        regexTextField.text = pattern
        regexTextField.sendActions(for: .valueChanged)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.showToast(withMessage: "Loaded \"\(name)\"")
        }
    }
}

// MARK: - UITextFieldDelegate

extension RegexViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

// MARK: - UITextViewDelegate

extension RegexViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateHighlights()
    }
}
