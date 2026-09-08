# RobotFramewrokPython

Robot Framework browser tests for the GitHub login page, including successful login, failed login, Google authentication navigation, and failure screenshots.

## Project Structure

- `login_test.robot` - Robot Framework test suite and user-facing keywords.
- `test_sample.py` - Pytest sample scenarios covering arithmetic, string concatenation, and list operations.
- `Locators.py` - External Robot Framework variable file containing label-based login page locators.
- `LoginPage.py` - Custom Robot Framework library with Selenium-based login helpers and screenshot support.
- `.venv/` - Workspace Python virtual environment containing the test dependencies.
- `Screenshot/` - Generated screenshots. The directory is created automatically when a screenshot is captured.
- `log.html`, `report.html`, `output.xml` - Robot Framework execution artifacts.

## Requirements

- Python 3.10 or newer
- Robot Framework
- pytest
- SeleniumLibrary
- Selenium WebDriver
- A supported browser: Chrome, Firefox, or Edge

Create and activate a virtual environment, then install the dependencies:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install robotframework robotframework-seleniumlibrary selenium pytest
```

Selenium Manager normally downloads or locates the required browser driver automatically. Make sure the selected browser is installed.

## Run the Tests

From the repository directory:

```powershell
python -m robot login_test.robot
```

Run one test case:

```powershell
python -m robot --test "Unsuccessful Login Scenario" login_test.robot
```

Validate the suite without opening a browser:

```powershell
python -m robot --dryrun login_test.robot
```

Run the pytest sample scenarios:

```powershell
python -m pytest test_sample.py
```

Robot Framework writes the results to `output.xml`, `log.html`, and `report.html`.
The current dry run contains 3 scenarios; the successful-login scenario is skipped until valid GitHub credentials are configured, while the unsuccessful-login and Google-flow scenarios run normally.

## Configuration

Update the variables in `login_test.robot` for the target application and test data:

- `${LOGIN_URL}` - Login page URL.
- `${BROWSER}` - `chrome`, `firefox`, or `edge`.
- `${USERNAME}` and `${PASSWORD}` - Credentials for the success scenario. The sample values are placeholders.
- `${WRONG_PASSWORD}` - Invalid password for the failure scenario.
Page locator variables such as `${LOGIN_PAGE_USERNAME_FIELD}`, `${LOGIN_PAGE_PASSWORD_FIELD}`, and `${LOGIN_PAGE_SUBMIT_BUTTON}` are maintained in `Locators.py`.

The current suite uses Edge and contains example credentials. Replace them before using the repository for real testing. Prefer environment variables or a secrets manager instead of committing credentials to source control.

## Screenshots

The unsuccessful login test captures a screenshot with:

```robot
Capture Login Screenshot    unsuccessful-login
```

The image is saved with a date and time suffix, for example:

```text
Screenshot/unsuccessful-login_2026-09-09_14-30-05-PM.png
```

`LoginPage.py` also captures a timestamped `Screenshot/login-failure_*.png` automatically when one of its custom waits times out.

## Interactive Test Step

`Unsuccessful Login Scenario` asks whether the Google authentication flow should continue. Enter `yes` or `no` when prompted. This step may require an interactive terminal and is not suitable for fully unattended CI runs without modification.

## Repository

[Diabolic101519/RobotFramewrokPython](https://github.com/Diabolic101519/RobotFramewrokPython)
