*** Settings ***
Library    SeleniumLibrary    run_on_failure=Capture Page Screenshot

*** Test Cases ***
Verify Kiip Smoke Page
    [Tags]    smoke
    ${options}=    Evaluate    __import__('selenium.webdriver.chrome.options', fromlist=['Options']).Options()
    Evaluate    $options.add_argument('--headless=new')
    Evaluate    $options.add_argument('--no-sandbox')
    Evaluate    $options.add_argument('--disable-dev-shm-usage')
    
    Open Browser    ${BASE_URL}    chrome    options=${options}
    Set Screenshot Directory    ./logs/screenshots
    
    Page Should Contain    Welcome to Kiip Demo
    Element Should Be Visible    id=status
    Close Browser
