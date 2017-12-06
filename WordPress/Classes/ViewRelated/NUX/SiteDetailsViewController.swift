import UIKit

class SiteDetailsViewController: UIViewController, LoginWithLogoAndHelpViewController {

    // MARK: - Properties

    @IBOutlet weak var siteTitleField: LoginTextField!
    @IBOutlet weak var taglineField: LoginTextField!
    @IBOutlet weak var tagDescrLabel: UILabel!
    @IBOutlet weak var nextButton: LoginButton!

    private var helpBadge: WPNUXHelpBadgeLabel!
    private var helpButton: UIButton!

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    private func configureView() {
        navigationItem.title = NSLocalizedString("Create New Site", comment: "Create New Site title.")
        let (helpButtonResult, helpBadgeResult) = addHelpButtonToNavController()
        helpButton = helpButtonResult
        helpBadge = helpBadgeResult
        WPStyleGuide.configureColors(for: view, andTableView: nil)
        tagDescrLabel.textColor = WPStyleGuide.greyDarken20()
        nextButton.isEnabled = false
        siteTitleField.becomeFirstResponder()
    }

    // MARK: - LoginWithLogoAndHelpViewController

    func handleHelpButtonTapped(_ sender: AnyObject) {
        displaySupportViewController(sourceTag: .wpComCreateSiteDetails)
    }

    func handleHelpshiftUnreadCountUpdated(_ notification: Foundation.Notification) {
        let count = HelpshiftUtils.unreadNotificationCount()
        helpBadge.text = "\(count)"
        helpBadge.isHidden = (count == 0)
    }

    // MARK: - Field Validation

    fileprivate func validateForm() {
    }

    // MARK: - Button Handling

    @IBAction func nextButtonPressed(_ sender: Any) {
    }

    // MARK: - Misc

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension SiteDetailsViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == siteTitleField {
            taglineField.becomeFirstResponder()
        } else if textField == taglineField {
            view.endEditing(true)
            validateForm()
        }

        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == siteTitleField,
            let siteTitle = textField.text {
            siteTitleField.text = siteTitle.trimmingCharacters(in: .whitespacesAndNewlines)
            nextButton.isEnabled = (siteTitle.count > 0)
        }
    }

}
