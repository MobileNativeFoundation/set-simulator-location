import Darwin

var stderrStream = STDErrOutputStream()

struct STDErrOutputStream: TextOutputStream {
    func write(_ string: String) {
        fputs(string, stderr)
    }
}

func exitWithUsage(error: String? = nil) -> Never {
    if let error = error {
        print(error, terminator: "\n\n", to: &stderrStream)
    }

    print("Usage: set-simulator-location [-c 0 0|-q San Francisco|-d] [-s Simulator Name|-u Simulator udid]",
          to: &stderrStream)
    exit(EXIT_FAILURE)
}
