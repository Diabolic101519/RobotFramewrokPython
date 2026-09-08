*** Settings ***
Documentation     A test suite for validating a website login page.
Library           SeleniumLibrary
Library           Dialogs
Library           String
Library           LoginPage.py
Variables         Locators.py

*** Variables ***
${LOGIN_URL}      https://github.com/login
${BROWSER}        edge
${USERNAME}       abc@gmail.com
${PASSWORD}       1232
${WRONG_PASSWORD}    definitely_wrong_password

*** Test Cases ***
Successful Login Scenario
    [Documentation]    Test that opens the browser, logs in, and verifies success.
    [Setup]    Open Browser To Login Page
    [Teardown]    Close All Browsers
    Skip    Configure valid GitHub credentials before running the successful-login scenario.
    Submit Credentials    ${USERNAME}    ${PASSWORD}
    Successful Login Should Be Confirmed
    Capture Login Screenshot    successful-login

Unsuccessful Login Scenario
    [Documentation]    Test that invalid credentials show an error and do not log the user in.
    [Setup]    Open Browser To Login Page
    [Teardown]    Close All Browsers
    Go To    ${LOGIN_URL}
    Wait Until Page Contains Element    ${LOGIN_PAGE_USERNAME_FIELD}    timeout=20s
    Submit Credentials    ${USERNAME}    ${WRONG_PASSWORD}
    Unsuccessful Login Should Be Confirmed
    Capture Login Screenshot    unsuccessful-login
    Ask To Continue With Google

Continue With Google Scenario
    [Documentation]    Test that the Google sign-in option starts the Google authentication flow.
    [Setup]    Open Browser To Login Page
    [Teardown]    Close All Browsers
    Go To    ${LOGIN_URL}
    Wait Until Page Contains Element    ${LOGIN_PAGE_GOOGLE_BUTTON}    timeout=20s
    Click Element    ${LOGIN_PAGE_GOOGLE_BUTTON}
    Google Authentication Page Should Be Open

*** Keywords ***
Open Browser To Login Page
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Page Contains Element    ${LOGIN_PAGE_USERNAME_FIELD}    timeout=20s

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
