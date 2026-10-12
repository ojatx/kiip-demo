*** Settings ***
Library     Browser

*** Variables ***
${BASE_URL}     http://127.0.0.1:8000

*** Test Cases ***
Verify Kiip Secondary Elements and Interactive State
    [Tags]    regression
    New Browser    chromium    headless=True
    New Page    ${BASE_URL}

    # Check header / branding
    Get Text    body    contains    Welcome to Kiip Demo

    # Verify interactive mock elements (checking backend status badge)
    Get Element States    id=status    validate    value & visible
    ${status_text}=    Get Text    id=status
    Should Not Be Empty    ${status_text}
    Close Browser
