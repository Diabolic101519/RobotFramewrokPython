from pathlib import Path

from LoginPage import LoginKeywords


class FakeDriver:
    def save_screenshot(self, path):
        Path(path).write_bytes(b"fake screenshot")


def create_login_keywords():
    keywords = LoginKeywords.__new__(LoginKeywords)
    keywords.driver = FakeDriver()
    keywords.selenium_library = None
    return keywords


def test_capture_screenshot_uses_scenario_name_and_timestamp(tmp_path, monkeypatch):
    monkeypatch.chdir(tmp_path)

    screenshot_path = create_login_keywords().capture_login_screenshot(
        "Unsuccessful Login Scenario"
    )

    assert Path(screenshot_path).exists()
    assert Path(screenshot_path).parent.name == "Screenshot"
    assert Path(screenshot_path).name.startswith("Unsuccessful-Login-Scenario_")
    assert Path(screenshot_path).suffix == ".png"


def test_capture_screenshot_replaces_same_scenario_only(tmp_path, monkeypatch):
    monkeypatch.chdir(tmp_path)
    screenshot_dir = tmp_path / "Screenshot"
    screenshot_dir.mkdir()
    old_screenshot = screenshot_dir / "Unsuccessful-Login-Scenario_old.png"
    other_screenshot = screenshot_dir / "Successful-Login-Scenario_old.png"
    default_screenshot = screenshot_dir / "selenium-screenshot-6.png"
    old_screenshot.touch()
    other_screenshot.touch()
    default_screenshot.touch()

    screenshot_path = create_login_keywords().capture_login_screenshot(
        "Unsuccessful Login Scenario"
    )

    assert Path(screenshot_path).exists()
    assert not old_screenshot.exists()
    assert other_screenshot.exists()
    assert not default_screenshot.exists()
