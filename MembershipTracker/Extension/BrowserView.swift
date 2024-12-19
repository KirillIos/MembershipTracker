import SwiftUI
@preconcurrency import WebKit
struct BrowserView: UIViewRepresentable {
    let url: String
    let viewModel: RemoteViewModel
    private let customUserAgent = generateUserAgent()
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.customUserAgent = customUserAgent
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.showsHorizontalScrollIndicator = false
        
        if let linkURL = URL(string: url) {
            webView.load(URLRequest(url: linkURL))
        }
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: BrowserView
        
        init(_ parent: BrowserView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            handleNavigation(navigationAction)
            decisionHandler(handleNavigationAction(navigationAction))
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            AppRatingManager.shared.checkAndRequestReview()
        }
        
        private func handleNavigation(_ navigationAction: WKNavigationAction) {
            if let navUrl = navigationAction.request.url {
                if navUrl.query?.contains("showAgreebutton") == true {
                    parent.viewModel.hasParameter = true
                } else {
                    saveLinkOrClear(navUrl)
                }
            }
        }
        
        private func saveLinkOrClear(_ navUrl: URL) {
            if !parent.viewModel.hasParameter {
                LocalStorage.shared.savedLink = parent.url
            } else {
                LocalStorage.shared.savedLink = ""
            }
        }
        
        private func handleNavigationAction(_ navigationAction: WKNavigationAction) -> WKNavigationActionPolicy {
            guard let scheme = navigationAction.request.url?.scheme else {
                return .allow
            }
            if ["tel", "mailto", "tg", "phonepe", "paytmmp"].contains(scheme) {
                if let url = navigationAction.request.url {
                    UIApplication.shared.open(url)
                }
                return .cancel
            }
            return .allow
        }
    }
}

private func generateUserAgent() -> String {
    return "Mozilla/5.0 (\(UIDevice.current.model); CPU \(UIDevice.current.model) OS \(UIDevice.current.systemVersion.replacingOccurrences(of: ".", with: "_")) like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/\(UIDevice.current.systemVersion) Mobile/15E148 Safari/604.1"
}
