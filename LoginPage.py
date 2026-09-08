import os
from pathlib import Path

from robot.api.deco import keyword, library
from robot.libraries.BuiltIn import BuiltIn
from selenium import webdriver
from selenium.common.exceptions import TimeoutException
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as expected
from selenium.webdriver.support.ui import WebDriverWait

@library
class LoginKeywords:
    def __init__(self):
        self.driver = None
        self.wait = None
        self.selenium_library = BuiltIn().get_library_instance("SeleniumLibrary")

    @keyword("Verify Login Result")
    def verify_login_result(self, expected_result: str):
        error_message = "The email or mobile number you entered isn’t connected"
        error_visible = self.selenium_library.run_keyword_and_return_status(
            "Page Should Contain",
            error_message,
        )

        if expected_result.lower() == "success":
            if error_visible:
                raise AssertionError("Login failed: invalid username or password")
            self.selenium_library.wait_until_page_contains_element(
                "xpath://div[@role='navigation']",
                timeout=20,
            )
            return

        if expected_result.lower() == "failure":
            if not error_visible:
                raise AssertionError("Expected login failure message, but no error was shown")
            return

        raise ValueError("expected_result must be 'success' or 'failure'")

    @keyword("Open Login Browser")
    def open_login_browser(self, url: str):
        if not url:
            raise ValueError("LOGIN_APP_URL must be set before running the suite")

        self.driver = self._create_driver()
        self.wait = WebDriverWait(self.driver, 15)
        self.driver.get(url)

    @keyword("Submit Login")
    def submit_login(
        self,
        username: str,
        password: str,
        username_selector: str,
        password_selector: str,
        submit_selector: str,
    ):
        self._required_value(username, "LOGIN_USERNAME")
        self._required_value(password, "LOGIN_PASSWORD")
        self._required_value(username_selector, "LOGIN_USERNAME_SELECTOR")
        self._required_value(password_selector, "LOGIN_PASSWORD_SELECTOR")
        self._required_value(submit_selector, "LOGIN_SUBMIT_SELECTOR")

        self._find(username_selector).send_keys(username)
        self._find(password_selector).send_keys(password)
        self._find(submit_selector).click()

    @keyword("Login Should Succeed")
    def login_should_succeed(self, success_selector: str):
        self._required_value(success_selector, "LOGIN_SUCCESS_SELECTOR")
        self._wait_for(success_selector)

    @keyword("Login Should Fail")
    def login_should_fail(self, error_selector: str):
        self._required_value(error_selector, "LOGIN_ERROR_SELECTOR")
        self._wait_for(error_selector)


    @keyword("Capture Login Screenshot")
    def capture_login_screenshot(self, name: str = "login-failure"):
        driver = self.driver or self.selenium_library.driver
        if driver is None:
            raise RuntimeError("The login browser is not open")
        output_dir = Path("Screenshot")
        output_dir.mkdir(parents=True, exist_ok=True)
        driver.save_screenshot(str(output_dir / f"{name}.png"))

    @keyword("Close Login Browser")
    def close_login_browser(self):
        if self.driver is not None:
            self.driver.quit()
            self.driver = None
            self.wait = None

    def _find(self, selector: str):
        if self.driver is None:
            raise RuntimeError("The login browser is not open")
        return self.wait.until(
            expected.presence_of_element_located((By.CSS_SELECTOR, selector))
        )

    @staticmethod
    def _create_driver():
        browser = os.getenv("BROWSER", "chrome").lower()
        headless = os.getenv("HEADLESS", "true").lower() in {"1", "true", "yes"}

        if browser == "chrome":
            options = webdriver.ChromeOptions()
            if headless:
                options.add_argument("--headless=new")
            options.add_argument("--window-size=1440,1000")
            return webdriver.Chrome(options=options)

        if browser == "firefox":
            options = webdriver.FirefoxOptions()
            if headless:
                options.add_argument("-headless")
            options.add_argument("--width=1440")
            options.add_argument("--height=1000")
            return webdriver.Firefox(options=options)

        if browser == "edge":
            options = webdriver.EdgeOptions()
            if headless:
                options.add_argument("--headless=new")
            options.add_argument("--window-size=1440,1000")
            return webdriver.Edge(options=options)

        raise ValueError("BROWSER must be one of: chrome, firefox, edge")

    def _wait_for(self, selector: str):
        try:
            self.wait.until(expected.visibility_of_element_located((By.CSS_SELECTOR, selector)))
        except TimeoutException as error:
            self.capture_login_screenshot()
            raise AssertionError(f"Expected login state was not visible: {selector}") from error

    @staticmethod
    def _required_value(value: str, variable_name: str):
        if not value:
            raise ValueError(f"{variable_name} must be set before running the suite")
