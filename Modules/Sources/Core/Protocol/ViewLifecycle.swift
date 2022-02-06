public protocol ViewLifecycle {
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
    func viewWillDisappear()
    func viewDidDisappear()
    func viewDidDeinit()
}

extension ViewLifecycle {
    public func viewDidLoad() {}
    public func viewWillAppear() {}
    public func viewDidAppear() {}
    public func viewWillDisappear() {}
    public func viewDidDisappear() {}
    public func viewDidDeinit() {}
}
