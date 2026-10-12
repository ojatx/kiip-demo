*** Settings ***
Library    SeleniumLibrary    run_on_failure=Capture Page Screenshot
Suite Setup    Open Regression Browser
Suite Teardown    Close All Browsers

*** Variables ***
${BROWSER}    chrome

*** Test Cases ***
Verify Kiip Secondary Elements and Interactive State
    [Tags]    regression
    Go To    ${BASE_URL}
    Set Screenshot Directory    ./logs/screenshots
    
    # Check header / branding
    Page Should Contain    Welcome to Kiip Demo
    
    # Verify interactive mock elements (checking backend status badge)
    Element Should Be Visible    id=status
    ${status_text}=    Get Text    id=status
    Should Not Be Empty    ${status_text}

Verify Simulated User Interaction Flow
    [Tags]    regression    interactive
    Go To    ${BASE_URL}
    Set Screenshot Directory    ./logs/screenshots
    
    # Verify the page title or content structure
    Title Should Be    Kiip Demo App
    Element Should Be Visible    tag=body

*** Keywords ***
Open Regression Browser
    ${options}=    Evaluate    __import__('selenium.webdriver.chrome.options', fromlist=['Options']).Options()
    Evaluate    $options.add_argument('--headless=new')
    Evaluate    $options.add_argument('--no-sandbox')
    Evaluate    $options.add_argument('--disable-dev-shm-usage')
    Open Browser    ${BASE_URL}    ${BROWSER}    options=${options}
