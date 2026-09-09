# RobotFramewrokPython

Robot Framework browser tests for the GitHub login page, including successful login, failed login, Google authentication with email and password steps, browser reuse, and timestamped screenshots.

## Project Structure

- `login_test.robot` - Robot Framework test suite and user-facing keywords.
- `test_sample.py` - Pytest coverage for scenario-based screenshot naming, cleanup, and retention without opening a browser.
- `Locators.py` - External Robot Framework variable file containing label-based login page locators.
- `LoginPage.py` - Custom Robot Framework library with Selenium-based login helpers, dynamic locator support, and screenshot support.
- `.venv/` - Workspace Python virtual environment containing the test dependencies.
- `Screenshot/` - Central directory for SeleniumLibrary and custom login screenshots. It is created automatically when a screenshot is captured.
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
The suite contains 3 scenarios. The successful-login scenario is skipped during a real run until valid GitHub credentials are configured. The unsuccessful-login scenario can optionally continue into Google authentication, and the dedicated Google scenario runs the email, `Next`, password, and `Next` steps. Browser sessions remain open between scenarios and are reused when the current page is not already the login URL.
The pytest screenshot checks cover sanitized scenario names, timestamped filenames, same-scenario replacement, preservation of other scenarios, and removal of numbered Selenium screenshots.

## Configuration

Update the variables in `login_test.robot` for the target application and test data:

- `${LOGIN_URL}` - Login page URL.
- `${BROWSER}` - `chrome`, `firefox`, or `edge`.
- `${USERNAME}` and `${PASSWORD}` - Credentials for the success scenario. The sample values are placeholders.
- `${WRONG_PASSWORD}` - Invalid password for the failure scenario.
- `${GOOGLE_EMAIL}` - Gmail address used by the Google authentication flow.
- `${GOOGLE_PASSWORD}` - Gmail password used by the Google authentication flow.
- `${SCREENSHOT_DIR}` - Shared directory for all Selenium and custom screenshots.
Page locator variables such as `${LOGIN_PAGE_USERNAME_FIELD}`, `${LOGIN_PAGE_PASSWORD_FIELD}`, and `${LOGIN_PAGE_SUBMIT_BUTTON}` are maintained in `Locators.py`.

### Locator Syntax

The custom keywords in `LoginPage.py` accept SeleniumLibrary-style locator prefixes. Use the prefix that matches the locator strategy:

```robot
xpath://input[@id='login_field']
id:login_field
name:username
css:input[type='email']
class:login-button
tag:button
```

Unprefixed values are treated as CSS selectors for backward compatibility:

```robot
#login_field
input[type='password']
```

The same locator format can be passed to `Submit Login`, `Login Should Succeed`, and `Login Should Fail`. Keep locator values in `Locators.py` when they are shared across tests.

The current suite uses Edge and contains credentials in the Robot variables section for local testing. Replace them before using the repository for real testing, and do not commit real Gmail or GitHub credentials. Use environment variables or a secrets manager instead.

`Open Browser To Login Page` reuses an already-open browser and navigates to `${LOGIN_URL}` only when the current page differs. The scenarios do not close the browser between tests.

## Screenshots

All scenarios capture screenshots with:

```robot
Capture Screenshot    ${TEST NAME}
```

Robot Framework passes the current scenario name to the screenshot keyword. Spaces and unsafe filename characters are replaced with hyphens, and a date and time suffix is added. Examples:

```text
Screenshot/Successful-Login-Scenario_2026-09-09_14-30-05-PM.png
Screenshot/Unsuccessful-Login-Scenario_2026-09-09_14-30-05-PM.png
Screenshot/Continue-With-Google-Scenario_2026-09-09_14-30-05-PM.png
```

`Capture Screenshot` saves directly to `${SCREENSHOT_DIR}` using the executed scenario name and timestamp. Before saving, it removes old `selenium-screenshot-*.png` files and older screenshots for the same scenario, so numbered fallback files such as `selenium-screenshot-6.png` are not retained. Each scenario keeps only its latest screenshot; screenshots from different scenarios remain together in the same folder. The unsuccessful-login scenario also verifies both the scenario name and the existence of its screenshot file.

The suite-level `Test Teardown` captures a scenario-named screenshot whenever a test fails before reaching its explicit capture step. This includes failures during the Google authentication flow.

## Interactive Test Step

`Unsuccessful Login Scenario` asks whether the Google authentication flow should continue. Enter `yes` or `no` when prompted. This step may require an interactive terminal and is not suitable for fully unattended CI runs without modification. Configure `${GOOGLE_EMAIL}` and `${GOOGLE_PASSWORD}` before running the Google flow.

## Repository

[Diabolic101519/RobotFramewrokPython](https://github.com/Diabolic101519/RobotFramewrokPython)
