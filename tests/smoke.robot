*** Settings ***
Library    Browser

*** Variables ***
${BASE_URL}    http://127.0.0.1:8000

*** Test Cases ***
Verify Kiip Secondary Elements and Interactive State
    [Tags]    regression    smoke
    Open Browser    ${BASE_URL}    Chrome    options=add_argument("--headless=new")
    Set Screenshot Directory    ./logs/screenshots

    # Check header / branding
    Page Should Contain    Welcome to Kiip Demo

    # Verify interactive mock elements (checking backend status badge)
    Element Should Be Visible    id=status
    ${status_text}=    Get Text    id=status
    Should Not Be Empty    ${status_text}
    Close Browser
# trigger build
