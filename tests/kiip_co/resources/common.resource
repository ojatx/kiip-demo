*** Settings ***
Documentation       Shared variables, locators and keywords for the kiip.co smoke suite.
Library             Browser    timeout=15s    auto_closing_level=SUITE
Library             OperatingSystem
Library             Collections


*** Variables ***
${BASE_URL}             https://www.kiip.co
${APEX_URL}             https://kiip.co
${BROWSER}              chromium
${HEADLESS}             ${TRUE}
# Debug recording (off by default). Turn on with -v TRACE:True and/or -v VIDEO:True
${TRACE}                ${FALSE}
${VIDEO}                ${FALSE}

# --- Login page -----------------------------------------------------------
${LOGIN_H1}             h1 >> text="Log in to Case Management"
${LOGIN_EMAIL}          input[placeholder="Email"]
${LOGIN_PASSWORD}       input#password
${PW_TOGGLE}            [id="password-right-group"] >> button[role="switch"]
${LOGIN_SUBMIT}         form >> button[type="submit"] >> text="Log in"
${FORGOT_LINK}          a[href="/forgot-password"]
${SIGNUP_LINK}          a[href="/create-account"]
${PERSONAL_LINK}        a[href="https://www.kiip.io"]

# --- Forgot password -----------------------------------------------------
${FORGOT_H1}            h1 >> text="Reset Password"
${FORGOT_EMAIL}         input[placeholder="Enter email address"]
${FORGOT_SUBMIT}        button[type="submit"] >> text="Reset Password"
${FORGOT_BACK}          a[href="/"] >> text="Back"

# --- Create account ------------------------------------------------------
${SIGNUP_H1}            h1 >> text="Create your Kiip account"
${SIGNUP_EMAIL}         input#email
${SIGNUP_NEXT}          button >> text="Next"
${SIGNUP_LOGIN_LINK}    a[href="/"] >> text="Log In"

# --- Footer / Contact modal ----------------------------------------------
${CONTACT_BUTTON}       footer >> button >> text="Contact Us"
${CONTACT_DIALOG}       [role="dialog"]
${CONTACT_CANCEL}       [role="dialog"] >> button >> text="Cancel"


*** Keywords ***
Open Kiip
    [Documentation]    Fresh browser + context for the suite, landing on ${path}.
    [Arguments]    ${path}=/
    New Browser    ${BROWSER}    headless=${HEADLESS}
    New Kiip Context    desktop    viewport=${{ {'width': 1280, 'height': 800} }}
    New Page    ${BASE_URL}${path}
    Wait For Page Ready

New Kiip Context
    [Documentation]    New Context that adds Playwright tracing / video recording when TRACE / VIDEO are on.
    ...                Traces land in results/traces/<suite>_<name>.zip; videos are embedded in log.html.
    [Arguments]    ${name}=main    &{options}
    IF    ${TRACE}
        ${slug}=    Evaluate    re.sub(r'\\W+', '_', $SUITE_NAME + '_' + $name).strip('_')    modules=re
        Set To Dictionary    ${options}    tracing=${OUTPUT DIR}/traces/${slug}.zip
    END
    IF    ${VIDEO}
        Set To Dictionary    ${options}    recordVideo=${{ {'dir': 'videos'} }}
    END
    New Context    &{options}

Go To Kiip Page
    [Arguments]    ${path}
    Go To    ${BASE_URL}${path}
    Wait For Page Ready

Wait For Page Ready
    [Documentation]    The app renders client-side, so "loaded" = its <h1> is on screen.
    ...                (Not networkidle: analytics/RUM beacons keep the network busy indefinitely.)
    Wait For Elements State    css=h1 >> nth=0    visible

Login Page Should Be Displayed
    Get Url    ==    ${BASE_URL}/
    Wait For Elements State    ${LOGIN_H1}    visible
    Get Title    ==    Kiip

Element Should Be Visible
    [Arguments]    ${locator}
    Wait For Elements State    ${locator}    visible

Footer Link Should Point To
    [Arguments]    ${text}    ${expected_href}
    Get Attribute    footer >> a >> text="${text}"    href    ==    ${expected_href}

Credentials Are Configured
    [Documentation]    Returns True when KIIP_EMAIL and KIIP_PASSWORD env vars are both set.
    ${email}=    Get Environment Variable    KIIP_EMAIL    ${EMPTY}
    ${pw}=    Get Environment Variable    KIIP_PASSWORD    ${EMPTY}
    RETURN    ${{ bool($email) and bool($pw) }}
