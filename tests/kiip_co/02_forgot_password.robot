*** Settings ***
Documentation       Smoke: the Reset Password page renders. Does NOT submit a reset request.
Resource            resources/common.resource
Suite Setup         Open Kiip    /forgot-password
Suite Teardown      Close Browser    ALL
Test Setup          Go To Kiip Page    /forgot-password
Test Tags           smoke    forgot-password


*** Test Cases ***
Forgot Password Page Loads Directly
    Get Url    ==    ${BASE_URL}/forgot-password
    Element Should Be Visible    ${FORGOT_H1}
    Get Text    body    *=    send you a link to reset your password

Reset Form Elements Are Present
    Element Should Be Visible    ${FORGOT_EMAIL}
    Element Should Be Visible    ${FORGOT_SUBMIT}
    Get Attribute    ${FORGOT_EMAIL}    type    ==    email
    Get Property    ${FORGOT_EMAIL}    required    ==    ${TRUE}

Empty Reset Submit Is Blocked Client Side
    Click    ${FORGOT_SUBMIT}
    Get Property    ${FORGOT_EMAIL}    validationMessage    !=    ${EMPTY}
    Get Url    ==    ${BASE_URL}/forgot-password

Back Returns To Login
    [Documentation]    The Back button calls history.back() (it ignores its href="/"), so it returns to
    ...                the PREVIOUS page. Arrive from the login page like a real user would; opening
    ...                /forgot-password directly makes Back go to about:blank in a fresh browser tab.
    Go To Kiip Page    /
    Click    ${FORGOT_LINK}
    Wait For Elements State    ${FORGOT_H1}    visible
    Click    ${FORGOT_BACK}
    Login Page Should Be Displayed

Back From Directly Opened Reset Page Returns To Login
    [Documentation]    KNOWN BUG (low severity): the Back button sits inside <a href="/"> but also calls
    ...                history.back(), so when /forgot-password is opened directly (new tab, bookmark,
    ...                link from elsewhere) Back goes to the previous history entry (blank page or
    ...                another site) instead of the login page.
    ...                Expected behaviour matches e.g. Roku's reset page, whose Cancel always goes to sign-in.
    ...                Excluded by default via the `known-issue` tag. Run it with the run script's --known-issues flag.
    ...                When Kiip fixes the bug, remove the known-issue tag so it becomes a regular check.
    [Tags]    known-issue    bug
    New Page    ${BASE_URL}/forgot-password    # fresh page = no history behind it
    Wait For Page Ready
    Click    ${FORGOT_BACK}
    Login Page Should Be Displayed
    [Teardown]    Close Page
