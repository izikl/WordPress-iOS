import UIKit

class SiteDetailsViewController: UIViewController, LoginWithLogoAndHelpViewController {

    // MARK: - Properties

    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var stepDescrLabel1: UILabel!
    @IBOutlet weak var stepDescrLabel2: UILabel!
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
        localizedText()
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
    
    private func localizedText() {
        stepLabel.text = NSLocalizedString("STEP 3 OF 4", comment: "Step for view.")
        stepDescrLabel1.text = NSLocalizedString("Tell us more about the site you're creating.", comment: "Site details instruction.")
        stepDescrLabel2.text = NSLocalizedString("What's the title and tagline?", comment: "Site details question.")
        siteTitleField.placeholder = NSLocalizedString("Add title", comment: "Site title placeholder.")
        taglineField.placeholder = NSLocalizedString("Optional tagline", comment: "Site tagline placeholder.")
        tagDescrLabel.text = NSLocalizedString("The tagline is a short line of text shown right below the title in most themes, and acts as site metadata on search engines.", comment: "Tagline description.")
        nextButton.titleLabel?.text = NSLocalizedString("Next", comment: "Next button title.")
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
        let message = "Title: '\(siteTitleField.text!)'\nTagline: '\(taglineField.text ?? "")'\nThis is a work in progress. If you need to create a site, disable the siteCreation feature flag."
        let alertController = UIAlertController(title: nil,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addDefaultActionWithTitle("OK")
        self.present(alertController, animated: true, completion: nil)
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
            var siteTitle = textField.text {
            siteTitle = siteTitle.trimmingCharacters(in: .whitespacesAndNewlines)
            nextButton.isEnabled = (siteTitle.count > 0)
        }
    }

}
