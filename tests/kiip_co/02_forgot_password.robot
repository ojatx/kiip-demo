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
    Click    ${FORGOT_BACK}
    Login Page Should Be Displayed
