*** Settings ***
Documentation       Smoke: the footer "Contact Us" modal opens, shows its form, and closes.
...                 Does NOT submit the form (that would email the Kiip support team).
Resource            resources/common.resource
Suite Setup         Open Kiip
Suite Teardown      Close Browser    ALL
Test Setup          Go To Kiip Page    /
Test Tags           smoke    contact


*** Test Cases ***
Contact Us Opens Modal With All Fields
    Click    ${CONTACT_BUTTON}
    Element Should Be Visible    ${CONTACT_DIALOG}
    FOR    ${field}    IN    subject    fname    lname    email    message
        Element Should Be Visible    ${CONTACT_DIALOG} >> [name="${field}"]
    END
    Element Should Be Visible    ${CONTACT_DIALOG} >> button >> text="Submit"
    Element Should Be Visible    ${CONTACT_CANCEL}

Cancel Closes Contact Modal
    Click    ${CONTACT_BUTTON}
    Element Should Be Visible    ${CONTACT_DIALOG}
    Click    ${CONTACT_CANCEL}
    Wait For Elements State    ${CONTACT_DIALOG}    detached
    Login Page Should Be Displayed
