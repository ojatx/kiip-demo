*** Settings ***
Documentation       Smoke: the sign-up wizard's first step renders. Does NOT create an account.
Resource            resources/common.resource
Suite Setup         Open Kiip    /create-account
Suite Teardown      Close Browser    ALL
Test Setup          Go To Kiip Page    /create-account
Test Tags           smoke    signup


*** Test Cases ***
Create Account Page Loads Directly
    Get Url    ==    ${BASE_URL}/create-account
    Element Should Be Visible    ${SIGNUP_H1}

Wizard Steps Are Listed
    Get Text    h2 >> text="Getting Started"    ==    Getting Started
    Element Should Be Visible    h3 >> text="Create your account"
    Element Should Be Visible    h3 >> text="Set up your organization"
    Element Should Be Visible    h3 >> text="Set up programs"

First Step Shows Email Field And Next Button
    Element Should Be Visible    ${SIGNUP_EMAIL}
    Element Should Be Visible    ${SIGNUP_NEXT}
    Get Text    body    *=    Use the email address associated with the organization

Log In Link Returns To Login
    Click    ${SIGNUP_LOGIN_LINK}
    Login Page Should Be Displayed
