# Service Pre-Deployment Check
This project provides a simple Bash-based pre-deployment checker for microservices.  
It reads a **manifest file** containing service paths, extracts metadata, and verifies the corresponding build artifacts.

## 📂 Project Structure
```bash
├── check.sh        # Main entry script
├── helper.sh       # Helper functions (e.g., manifest reading, name extraction)
├── service.sh      # Service-specific utilities (e.g., artifact check)
├── services.txt    # Example manifest file (list of services)
└── test.sh         # Test file
````

## ⚙️ Usage
```bash
./check.sh <manifest-file>
````

Example:
```bash
./check.sh services.txt
```

## 🧪 Test Suite
Here’s your test suite summarized in a clean **table format** ✅📋:

| #  | Function                    | Input / Case                   | Expected Output            | Description                                                  |
| -- | --------------------------- | ------------------------------ | -------------------------- | ------------------------------------------------------------ |
| 1  | `check_artifact`            | ("unknown-service", "unknown") | `n/a`                      | Version unknown of unknown-service should return `[n/a]`.    |
| 2  | `check_artifact`            | ("user-service", "1.2.3")      | `available`                | Version 1.2.3 of user-service should return `[available]`.   |
| 3  | `check_artifact`            | ("user-service", "2.0.0")      | `unavailable`              | Version 2.0.0 of user-service should return `[unavailable]`. |
| 4  | `check_artifact`            | ("edge-case-service", "")      | `error_checking_artifact`  | Empty version should return `[error_checking_artifact]`.     |
| 5  | `extract_service_name`      | "app/user-service"             | `user-service`             | Extract service name from `app/user-service`.                |
| 6  | `extract_service_name`      | "app/product-service"          | `product-service`          | Extract service name from `app/product-service`.             |
| 7  | `extract_service_name`      | "app/common-utils"             | `common-utils`             | Extract service name from `app/common-utils`.                |
| 8  | `extract_version_from_path` | "app/user-service"             | `1.2.3`                    | Version from `app/user-service`.                             |
| 9  | `extract_version_from_path` | "app/product-service"          | `0.5.0`                    | Version from `app/product-service`.                          |
| 10 | `extract_version_from_path` | "lib/common-utils"             | `unknown`                  | Version from `lib/common-utils`.                             |
| 11 | `read_manifest`             | "file-not-found.txt"           | exit code `1`              | File not found should return an error.                       |
| 12 | `read_manifest`             | "services.txt"                 | List of services (3 lines) | Should read manifest and return listed services.             |

👉 Total: **12 tests** across **4 functions**.

## 📑 Manifest File
The manifest file should contain one service path per line, for example:
```bash
app/user-service
app/product-service
lib/common-utils
```

## ✅ What the Script Does
1. **Validations**
   * Checks if an argument was provided.
   * Checks if the manifest file exists.
   * Checks if the manifest file is not empty.
   * Ensures each manifest entry is valid (no malformed lines).

2. **Processing**
   * Reads all services listed in the manifest.
   * Extracts the service name from the path.
   * Extracts the version from `version.txt` or `package.json`.
   * Verifies if an artifact exists for the given service and version.

## ⚠️ Error Handling
The script exits with an error message if:

* No manifest file argument is provided.
* The manifest file does not exist.
* The manifest file is empty.
* A manifest entry is malformed.
* A manifest entry with missing service directory

## Example Output:

```bash
Service Pre-Deployment Check Report:
====================================
Service: user-service
Version: 1.2.3
Artifact: available
------------------------------------
Service: product-service
Version: 0.5.0
Artifact: unavailable
------------------------------------
Service: common-utils
Version: unknown
Artifact: n/a
====================================
```