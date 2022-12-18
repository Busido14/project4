import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    
    
    var websites: [String]!
    var selectedWebsite: Int!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        let back = UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack ))
        
        navigationItem.backBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: webView, action: #selector(webView.goForward))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //        создает новый элемент кнопки которую нельзя нажать?
        
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        //        создает кнопку обновление страницы
        let forward = UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward))
        progressView = UIProgressView(progressViewStyle: .default)
        //        показывает степерь заполненности прогресса
        
        progressView.sizeToFit()
        //        говорит чтобы автоматически подогнал размеры заркужеченого макета
        
        let progressButton = UIBarButtonItem(customView: progressView)
        //         показывает строку загрузки(прогресс) (заворачивает UIProgressView на UIBattonItem чтобы макет мог попасть на панель инструментов).
        toolbarItems = [progressButton, spacer, refresh, forward, back]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        print(selectedWebsite!)
        print(websites!)
        let url = URL(string: "https://" + websites[selectedWebsite])!
        
        //        изменяет изначальную страницу чтобы она не была жестко запрограммирована
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    @objc func openTapped() {
        let ac  = UIAlertController(title: "Open page...", message: nil,
                                    preferredStyle:  .actionSheet)
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default,
                                       handler: openPage))
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        ac.popoverPresentationController?.barButtonItem =
        navigationItem.rightBarButtonItem
        
        present(ac, animated: true)
        //        добавляет кнопку Cancel а так же
    }
    
    func openPage (action: UIAlertAction) {
        guard let actionTitle = action.title else { return }
        
        guard let url = URL(string: "https://" + actionTitle) else { return }
        webView.load(URLRequest(url: url))
        //        берет title соединяет с https для безопасности и создает URL не как String
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
        // обновляет title чтобы стать заголовком на веб странице
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                    //                    проверяет  URL в безопастном списке или нет
                }
            }
        }
        let dd = UIAlertController(title: "This site is blocked!", message: nil , preferredStyle: .alert)
        dd.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(dd, animated: true)
        decisionHandler(.cancel)
    }
}
