import SwiftUI

@main
struct MacSetupApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
    }
}

struct ContentView: View {
    @State private var isRunning = false
    @State private var output: String = ""
    @State private var scrollToBottom = false
    @StateObject private var scriptRunner = ScriptRunner()
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 8) {
                Text("Mac Setup")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Interactive Mac application installer")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(NSColor.controlBackgroundColor))
            
            // Terminal output
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 4) {
                        if scriptRunner.output.isEmpty {
                            Text("Click 'Start Setup' to begin...")
                                .foregroundColor(.secondary)
                                .padding()
                        } else {
                            Text(scriptRunner.output)
                                .font(.system(.body, design: .monospaced))
                                .textSelection(.enabled)
                                .padding()
                        }
                        
                        Color.clear
                            .frame(height: 1)
                            .id("bottom")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .background(Color(NSColor.textBackgroundColor))
                .onChange(of: scriptRunner.output) { _ in
                    withAnimation {
                        proxy.scrollTo("bottom", anchor: .bottom)
                    }
                }
            }
            
            // Input field (for interactive prompts)
            if scriptRunner.isWaitingForInput {
                HStack {
                    TextField("Your response (y/N):", text: $scriptRunner.userInput)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit {
                            scriptRunner.submitInput()
                        }
                    
                    Button("Submit") {
                        scriptRunner.submitInput()
                    }
                    .keyboardShortcut(.return)
                }
                .padding()
                .background(Color(NSColor.controlBackgroundColor))
            }
            
            // Control buttons
            HStack {
                if !scriptRunner.isRunning {
                    Button(action: {
                        scriptRunner.startScript()
                    }) {
                        Label("Start Setup", systemImage: "play.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(scriptRunner.isRunning)
                } else {
                    HStack {
                        ProgressView()
                            .scaleEffect(0.8)
                        Text("Running...")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                Button(action: {
                    scriptRunner.clear()
                }) {
                    Label("Clear", systemImage: "trash")
                }
                .buttonStyle(.bordered)
                .disabled(scriptRunner.isRunning)
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
        }
        .frame(width: 700, height: 500)
    }
}

class ScriptRunner: ObservableObject {
    @Published var output: String = ""
    @Published var isRunning: Bool = false
    @Published var isWaitingForInput: Bool = false
    @Published var userInput: String = ""
    
    private var process: Process?
    private var inputPipe: Pipe?
    
    func startScript() {
        output = ""
        isRunning = true
        isWaitingForInput = false
        
        let scriptPath = "/Users/andy/Library/CloudStorage/Dropbox/Scripts/github/mac/setup"
        
        process = Process()
        process?.executableURL = URL(fileURLWithPath: "/bin/zsh")
        process?.arguments = ["-c", scriptPath]
        
        let outputPipe = Pipe()
        inputPipe = Pipe()
        
        process?.standardOutput = outputPipe
        process?.standardError = outputPipe
        process?.standardInput = inputPipe
        
        // Handle output
        outputPipe.fileHandleForReading.readabilityHandler = { [weak self] handle in
            let data = handle.availableData
            if data.count > 0 {
                if let string = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        self?.output += string
                        
                        // Check if waiting for input (looking for question marks or y/N patterns)
                        let lastLine = string.split(separator: "\n").last ?? ""
                        if lastLine.contains("?") || lastLine.contains("(y/N)") || lastLine.contains("(Y/n)") {
                            self?.isWaitingForInput = true
                        }
                    }
                }
            }
        }
        
        // Handle completion
        process?.terminationHandler = { [weak self] _ in
            DispatchQueue.main.async {
                self?.isRunning = false
                self?.isWaitingForInput = false
                self?.output += "\n\n✓ Setup complete!\n"
            }
        }
        
        do {
            try process?.run()
        } catch {
            output = "Error starting script: \(error.localizedDescription)\n"
            isRunning = false
        }
    }
    
    func submitInput() {
        guard let inputPipe = inputPipe else { return }
        
        let input = userInput + "\n"
        if let data = input.data(using: .utf8) {
            inputPipe.fileHandleForWriting.write(data)
        }
        
        userInput = ""
        isWaitingForInput = false
    }
    
    func clear() {
        output = ""
        isWaitingForInput = false
        userInput = ""
    }
}

// Preview provider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
