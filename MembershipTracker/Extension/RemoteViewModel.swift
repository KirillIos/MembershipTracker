import FirebaseRemoteConfig
import Network

@MainActor
final class RemoteViewModel: ObservableObject {
    @Published var currentState: ViewState = .main
    @Published var displayAlert: Bool = false
    @Published var redirectLink: String?
    @Published var hasParameter = false
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    init() {
        setupNetworkMonitoring()
    }
    
    private func setupNetworkMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if path.status == .unsatisfied {
                    self.displayAlert = true
                    self.currentState = .main
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    func retrieveRemoteData() async -> URL? {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        do {
            let fetchStatus = try await remoteConfig.fetchAndActivate()
            if fetchStatus == .successFetchedFromRemote || fetchStatus == .successUsingPreFetchedData {
                let link = remoteConfig["privacyLink"].stringValue ?? ""
                return URL(string: link)
            }
        } catch {
            await MainActor.run {
                currentState = .main
                displayAlert = true
            }
        }
        return nil
    }
    
    deinit {
        monitor.cancel()
    }
}
