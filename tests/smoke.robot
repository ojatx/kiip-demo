*** Settings ***
Library    SeleniumLibrary

*** Test Cases ***
Verify Kiip Secondary Elements and Interactive State
    [Tags]    regression    smoke
    Go To    ${BASE_URL}
    Set Screenshot Directory    ./logs/screenshots

    # Check header / branding
    Page Should Contain    Welcome to Kiip Demo

    # Verify interactive mock elements (checking backend status badge)
    Element Should Be Visible    id=status
    ${status_text}=    Get Text    id=status
    Should Not Be Empty    ${status_text}
