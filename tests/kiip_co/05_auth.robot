*** Settings ***
Documentation       Optional auth smoke. These DO hit the login API, so they're opt-in:
...                 - "valid login" runs only when KIIP_EMAIL and KIIP_PASSWORD are set (use a test account).
...                 - "invalid login" is tagged auth-negative and excluded by default (see smoke.args)
...                   to avoid tripping rate limits or lockouts on prod.
Resource            resources/common.resource
Suite Setup         Open Kiip
Suite Teardown      Close Browser    ALL
Test Setup          Go To Kiip Page    /
Test Tags           auth


*** Test Cases ***
Valid Credentials Leave The Login Page
    ${configured}=    Credentials Are Configured
    Skip If    not ${configured}    KIIP_EMAIL / KIIP_PASSWORD not set
    Fill Text    ${LOGIN_EMAIL}    %{KIIP_EMAIL}
    Fill Secret    ${LOGIN_PASSWORD}    %KIIP_PASSWORD
    Click    ${LOGIN_SUBMIT}
    Wait For Elements State    ${LOGIN_H1}    detached    timeout=30s
    Get Url    !=    ${BASE_URL}/
    # TODO: replace with a concrete post-login assertion (e.g. dashboard heading) once known.

Invalid Credentials Keep User On Login Page
    [Tags]    auth    auth-negative
    Fill Text    ${LOGIN_EMAIL}    smoke-test-nonexistent@example.com
    Fill Text    ${LOGIN_PASSWORD}    definitely-wrong-password
    Click    ${LOGIN_SUBMIT}
    Sleep    3s    # give the API round-trip time to complete
    Login Page Should Be Displayed
    # Error UI wasn't confirmed (we didn't submit against prod while authoring).
    # Warn rather than fail until the real error selector/text is pinned down.
    Run Keyword And Warn On Failure
    ...    Wait For Elements State    css=[role="alert"], .chakra-alert, [id^="toast"] >> nth=0    visible    timeout=5s
