# MemViz

### Visualize. Monitor. Understand Your Memory.

**MemViz** is a lightweight Linux memory-monitoring utility written in Bash. It aims to make system memory usage easier to inspect directly from the terminal, using Linux system information and command-line tools.

The project is an exploration of Linux system monitoring, shell scripting, process management, and the `/proc` filesystem.

## Overview

Understanding how a Linux system uses RAM and swap is an important part of system administration and performance analysis. MemViz aims to provide a simple interface for inspecting memory statistics without requiring a heavyweight monitoring application.

The project is being developed with a focus on simplicity, transparency, and learning how Linux exposes system-level information.

## Features

- **Memory Monitoring** — Inspect system memory usage.
- **Terminal-Based Interface** — Work directly from the Linux command line.
- **Lightweight Implementation** — Built with Bash and standard Linux utilities.
- **Linux System Information** — Explore memory statistics exposed by the operating system.
- **Learning-Oriented Design** — Understand shell scripting and Linux system monitoring through a practical project.

## Tech Stack

| Technology | Purpose |
|---|---|
| Bash | Main scripting language |
| Linux `/proc` filesystem | Access to kernel-exposed system information, if used by the script |
| GNU/Linux command-line utilities | Retrieve and display system statistics |
| Git and GitHub | Version control and project hosting |

## Requirements

- A Linux operating system
- Bash
- Standard command-line utilities used by the script


## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/rootaashu/memviz.git
```

### 2. Enter the project directory

```bash
cd memviz
```

### 3. Make the script executable

```bash
chmod +x memviz.sh
```

### 4. Run MemViz

```bash
./memviz.sh
```

Alternatively, run the script through Bash:

```bash
bash memviz.sh
```

## How It should work 

MemViz is designed around the Linux command-line environment.

Linux exposes a variety of system statistics through interfaces such as `/proc/meminfo`. Shell scripts can read this information and process it to present useful memory statistics.

A typical memory-monitoring workflow involves:

1. Retrieving system memory information.
2. Processing the relevant values.
3. Calculating or identifying useful memory statistics.
4. Displaying the results in a readable terminal format.

The exact workflow depends on the implementation of `memviz.sh`.

## Expected Output


```text
MemTotal:        16384000 kB
MemFree:          2500000 kB
MemAvailable:     9000000 kB
SwapTotal:        4194304 kB
SwapFree:         4194304 kB
```

These values are illustrative examples, not output captured from MemViz.i

## Project Structure

```text
memviz/
├── memviz.sh
├── README.md
└── .gitignore
```

## Learning Objectives

This project provides practical experience with:

- Bash scripting and command-line execution.
- Linux memory statistics and system interfaces.
- Understanding RAM and swap utilization.
- Processing text-based system information.
- Building lightweight Linux utilities.
- Version control and maintaining a public software project.

## Roadmap

Potential future improvements include:

- [ ] Display RAM usage as percentages.
- [ ] Add swap-memory statistics.
- [ ] Introduce continuously refreshed monitoring.
- [ ] Improve terminal formatting and readability.
- [ ] Add configurable refresh intervals.
- [ ] Display the processes consuming the most memory.
- [ ] Add threshold-based memory alerts.
- [ ] Improve error handling and input validation.
- [ ] Add usage instructions and example screenshots.

These are possible future enhancements, not claims about existing functionality.

## Contributing

Contributions, suggestions, and bug reports are welcome.

If you want to contribute:

1. Fork the repository.
2. Create a feature branch.
3. Make your changes.
4. Test your changes on Linux.
5. Submit a pull request describing your improvements.

## Disclaimer

MemViz is a learning-oriented Linux utility. Its output and capabilities depend on the current implementation and the system on which it runs.

