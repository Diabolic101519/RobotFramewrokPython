"""Label-based locators for the GitHub login page."""

#Label-based locators for login page.
LOGIN_PAGE_USERNAME_LABEL = "xpath://label[normalize-space()='Username or email address']"
LOGIN_PAGE_PASSWORD_LABEL = "xpath://label[normalize-space()='Password']"
LOGIN_PAGE_USERNAME_FIELD = "xpath://label[normalize-space()='Username or email address']/following::input[@id='login_field'][1]"
LOGIN_PAGE_PASSWORD_FIELD = "xpath://label[normalize-space()='Password']/following::input[@id='password'][1]"
LOGIN_PAGE_SUBMIT_BUTTON = "xpath://button[normalize-space()='Sign in'] | //input[@type='submit' and @value='Sign in']"
LOGIN_PAGE_GOOGLE_BUTTON = "xpath://button[contains(normalize-space(.), 'Continue with Google')] | //a[contains(normalize-space(.), 'Continue with Google')]"

#Valid login credentials for testing purposes.
GOOGLE_EMAIL_FIELD = "xpath://input[@type='email' or @id='identifierId']"
GOOGLE_EMAIL_NEXT_BUTTON = "xpath://button[.//span[normalize-space()='Next']] | //button[normalize-space()='Next']"
GOOGLE_PASSWORD_FIELD = "xpath://input[@type='password']"
GOOGLE_PASSWORD_NEXT_BUTTON = "xpath://button[.//span[normalize-space()='Next']] | //button[normalize-space()='Next']"
LOGIN_PAGE_ERROR = "Incorrect username or password."