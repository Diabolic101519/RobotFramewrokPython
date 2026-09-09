*** Settings ***
Documentation     A test suite for validating a website login page.
Library           SeleniumLibrary
Library           Dialogs
Library           String
Library           OperatingSystem
Library           LoginPage.py
Variables         Locators.py
Test Teardown     Capture Scenario Screenshot On Failure

*** Variables ***
${LOGIN_URL}      https://github.com/login
${BROWSER}        edge
${USERNAME}       abc@gmail.com
${PASSWORD}       1232
${WRONG_PASSWORD}    definitely_wrong_password
${GOOGLE_EMAIL}    dad@gmail.com
${GOOGLE_PASSWORD}    12314
${SCREENSHOT_DIR}    Screenshot

*** Test Cases ***
Successful Login Scenario
    [Documentation]    Test that opens the browser, logs in, and verifies success.
    [Setup]    Prepare Successful Login
    Submit Credentials    ${USERNAME}    ${PASSWORD}
    Successful Login Should Be Confirmed
    Capture Screenshot    ${TEST NAME}

Unsuccessful Login Scenario
    [Documentation]    Test that invalid credentials show an error and do not log the user in.
    [Setup]    Open Browser To Login Page
    Submit Credentials    ${USERNAME}    ${WRONG_PASSWORD}
    Unsuccessful Login Should Be Confirmed
    ${screenshot_path}=    Capture Screenshot    ${TEST NAME}
    Should Contain    ${screenshot_path}    Unsuccessful-Login-Scenario
    File Should Exist    ${screenshot_path}
    Ask To Continue With Google

Continue With Google Scenario
    [Documentation]    Test that the Google sign-in option starts the Google authentication flow.
    [Setup]    Open Browser To Login Page
    Continue With Google

*** Keywords ***
Capture Scenario Screenshot On Failure
    Run Keyword If Test Failed    Capture Screenshot    ${TEST NAME}

Prepare Successful Login
    ${username}=    Get Environment Variable    LOGIN_USERNAME    ${EMPTY}
    ${password}=    Get Environment Variable    LOGIN_PASSWORD    ${EMPTY}
    ${credentials_configured}=    Evaluate    bool($username and $password)
    Run Keyword If    not ${credentials_configured}
    ...    Skip    Set LOGIN_USERNAME and LOGIN_PASSWORD before running the successful-login scenario.
    Set Test Variable    ${USERNAME}    ${username}
    Set Test Variable    ${PASSWORD}    ${password}
    Open Browser To Login Page

Open Browser To Login Page
    ${browser_open}=    Run Keyword And Return Status    Get Location
    Run Keyword If    not ${browser_open}    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Run Keyword If    ${browser_open}    Use Existing Login Browser
    Set Screenshot Directory    ${SCREENSHOT_DIR}
    Maximize Browser Window
    Wait Until Page Contains Element    ${LOGIN_PAGE_USERNAME_FIELD}    timeout=20s

Use Existing Login Browser
    ${current_url}=    Get Location
    Run Keyword If    '${current_url}' != '${LOGIN_URL}'    Go To    ${LOGIN_URL}

Submit Credentials
    [Arguments]    ${user}    ${pass}
    Input Text        ${LOGIN_PAGE_USERNAME_FIELD}    ${user}
    Input Password    ${LOGIN_PAGE_PASSWORD_FIELD}    ${pass}
    Wait Until Page Contains Element    ${LOGIN_PAGE_SUBMIT_BUTTON}    timeout=20s
    Click Element    ${LOGIN_PAGE_SUBMIT_BUTTON}

Successful Login Should Be Confirmed
    ${login_failed}=    Run Keyword And Return Status
    ...    Wait Until Page Contains    ${LOGIN_PAGE_ERROR}    timeout=10s
    Run Keyword If    ${login_failed}
    ...    Fail    Login failed: invalid username or password
    Wait Until Location Does Not Contain    /login    timeout=20s

Unsuccessful Login Should Be Confirmed
    Wait Until Page Contains    ${LOGIN_PAGE_ERROR}    timeout=20s
    Page Should Contain Element    ${LOGIN_PAGE_USERNAME_FIELD}

Google Authentication Page Should Be Open
    Wait Until Location Contains    accounts.google.com    timeout=20s

Ask To Continue With Google
    ${continue}=    Get Value From User    Login was unsuccessful. Continue with Google? (yes/no):
    ${should_continue}=    Convert To Lower Case    ${continue}
    Run Keyword If    '${should_continue}' == 'yes'
    ...    Continue With Google

Continue With Google
    Go To    ${LOGIN_URL}
    Wait Until Page Contains Element    ${LOGIN_PAGE_GOOGLE_BUTTON}    timeout=20s
    Click Element    ${LOGIN_PAGE_GOOGLE_BUTTON}
    Google Authentication Page Should Be Open
    Input Text    ${GOOGLE_EMAIL_FIELD}    ${GOOGLE_EMAIL}
    Click Element    ${GOOGLE_EMAIL_NEXT_BUTTON}
    Wait Until Page Contains Element    ${GOOGLE_PASSWORD_FIELD}    timeout=20s
    Input Password    ${GOOGLE_PASSWORD_FIELD}    ${GOOGLE_PASSWORD}
    Click Element    ${GOOGLE_PASSWORD_NEXT_BUTTON}
    Google Authentication Page Should Be Open
    Capture Screenshot    ${TEST NAME}
