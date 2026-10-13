*** Settings ***
Documentation       Smoke: the Case Management login page renders and behaves.
...                 Read-only — nothing is sent to the auth backend.
Resource            resources/common.resource
Suite Setup         Open Kiip
Suite Teardown      Close Browser    ALL
Test Setup          Go To Kiip Page    /
Test Tags           smoke    login


*** Test Cases ***
Apex Domain Redirects To WWW Login Page
    Go To    ${APEX_URL}
    Login Page Should Be Displayed

Login Form Elements Are Present
    Element Should Be Visible    ${LOGIN_EMAIL}
    Element Should Be Visible    ${LOGIN_PASSWORD}
    Element Should Be Visible    ${LOGIN_SUBMIT}
    Element Should Be Visible    ${FORGOT_LINK}
    Element Should Be Visible    ${SIGNUP_LINK}
    Get Attribute    ${LOGIN_EMAIL}    type    ==    email
    Get Attribute    ${LOGIN_PASSWORD}    type    ==    password

Email And Password Are Required
    Get Property    ${LOGIN_EMAIL}    required    ==    ${TRUE}
    Get Property    ${LOGIN_PASSWORD}    required    ==    ${TRUE}

Empty Submit Is Blocked Client Side
    [Documentation]    HTML5 validation should stop the submit; we stay on the login page.
    Click    ${LOGIN_SUBMIT}
    Get Property    ${LOGIN_EMAIL}    validationMessage    !=    ${EMPTY}
    Login Page Should Be Displayed

Malformed Email Is Flagged Client Side
    Fill Text    ${LOGIN_EMAIL}    not-an-email
    Fill Text    ${LOGIN_PASSWORD}    placeholder-pw
    Click    ${LOGIN_SUBMIT}
    ${mismatch}=    Evaluate JavaScript    ${LOGIN_EMAIL}    (el) => el.validity.typeMismatch
    Should Be True    ${mismatch}
    Login Page Should Be Displayed

Password Show Hide Toggle Works
    Fill Text    ${LOGIN_PASSWORD}    secret123
    Get Text    ${PW_TOGGLE}    ==    Show
    Click    ${PW_TOGGLE}
    Get Attribute    ${LOGIN_PASSWORD}    type    ==    text
    Get Text    ${PW_TOGGLE}    ==    Hide
    Click    ${PW_TOGGLE}
    Get Attribute    ${LOGIN_PASSWORD}    type    ==    password

Forgot Password Link Navigates
    Click    ${FORGOT_LINK}
    Get Url    ==    ${BASE_URL}/forgot-password
    Element Should Be Visible    ${FORGOT_H1}

Sign Up Link Navigates
    Click    ${SIGNUP_LINK}
    Get Url    ==    ${BASE_URL}/create-account
    Element Should Be Visible    ${SIGNUP_H1}

Personal Account Link Points To Kiip.io
    Get Attribute    ${PERSONAL_LINK}    href    ==    https://www.kiip.io

Footer Links Are Correct
    Footer Link Should Point To    FAQ    https://go.kiipco.com/kiip
    Footer Link Should Point To    Privacy Policy    https://www.findhelp.org/legal/privacy
    Footer Link Should Point To    EULA    https://organizations.findhelp.com/customer-terms-for-organizations/
    Get Text    footer    *=    Kiip, PBC

Login Page Renders On Mobile
    [Tags]    smoke    login    mobile
    ${device}=    Get Device    iPhone 13
    New Kiip Context    mobile    &{device}
    New Page    ${BASE_URL}/
    Login Page Should Be Displayed
    Element Should Be Visible    ${LOGIN_EMAIL}
    Element Should Be Visible    ${LOGIN_SUBMIT}
    [Teardown]    Close Context
