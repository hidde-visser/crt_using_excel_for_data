*** Settings ***
Library                         QWeb
Library                         QForce
Library                         String


*** Variables ***
# ${login_url}                    https://YOURDOMAIN.my.salesforce.com                    # Salesforce instance. NOTE: Should be overwritten in CRT variables
${login_url}                    https://slockard-dev-ed.lightning.force.com/                    # Salesforce instance. NOTE: Should be overwritten in CRT variables
${home_url}                     ${login_url}/lightning/page/home
${BROWSER}                      chrome

*** Keywords ***
Setup Browser
    Set Library Search Order    QWeb                        QForce
    Open Browser                about:blank                 ${BROWSER}
    SetConfig                   LineBreak                   ${EMPTY}                    #\ue000
    SetConfig                   DefaultTimeout              20s                         #sometimes salesforce is slow


End suite
    Set Library Search Order    QWeb                        QForce
    Close All Browsers


Login
    # username and password are defined as variables on suite level
    [Documentation]             Login to Salesforce instance
    Set Library Search Order    QWeb                        QForce
    GoTo                        ${login_url}
    TypeText                    Username                    ${username}                 delay=1
    TypeText                    Password                    ${password}
    ClickText                   Log In


Home
    [Documentation]             Navigate to homepage, login if needed
    Set Library Search Order    QWeb                        QForce
    GoTo                        ${home_url}
    ${login_status} =           IsText                      To access this page, you have to log in to Salesforce.    2
    Run Keyword If              ${login_status}             Login
    ClickText                   Home
    VerifyTitle                 Home | Salesforce

Sales App
    [Documentation]             Navigate to the Sales App
    Set Library Search Order    QWeb                        QForce
    LaunchApp                   Sales

    # Example of custom keyword with robot fw syntax
VerifyStage
    Set Library Search Order    QWeb                        QForce
    [Documentation]             Verifies that stage given in ${text} is at ${selected} state; either selected (true) or not selected (false)
    [Arguments]                 ${text}                     ${selected}=true
    VerifyElement               //a[@title\="${text}" and @aria-checked\="${selected}"]


NoData
    Set Library Search Order    QWeb                        QForce
    VerifyNoText                ${data}                     timeout=3                   delay=2

Entering A Lead With Data
    [Arguments]               ${First Name}    ${Last Name}    ${Phone}    ${Company}    ${Website}
    [tags]                    Lead
    Log Variables
    Home
    LaunchApp                 Sales
    LaunchApp                 Sales

    ClickText                 Leads
    VerifyText                Recently Viewed             timeout=120s
    ClickText                 New
    VerifyText                Lead Information
    UseModal                  On                          # Only find fields from open modal dialog

    TypeText                  First Name                  ${First Name}
    TypeText                  Last Name                   ${Last Name}
    Picklist                  Lead Status                 Working
    TypeText                  Phone                       ${Phone}                    First Name
    TypeText                  Company                     ${Company}                  Last Name
    TypeText                  Website                     ${Website}

    ClickText                 Lead Source
    ClickText                 Advertisement
    ClickText                 Save                        partial_match=False
    UseModal                  Off
    Sleep                     1

    #Delete the lead to clean up data
    LaunchApp                 Sales
    ClickText                 Leads
    VerifyText                Recently Viewed             timeout=120s

    ClickText                 ${first Name}
    ClickText                 Delete
    ClickText                 Delete
    VerifyText                Recently Viewed
    VerifyNoText              ${First Name}
    VerifyNoText              ${Last Name}