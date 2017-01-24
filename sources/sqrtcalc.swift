
@IBAction func SquareRootButtonPressed(sender: UIButton) {
        currentInput = sqrt(currentInput)
    }

    @IBAction func closeCalc(sender: UIButton) {
        self.presentingViewController?.dismissViewControllerAnimated(false, completion: {})
    }