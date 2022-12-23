*** Settings ***
Resource                      ../resources/common.robot
Library                       DataDriver    reader_class=TestDataApi    name=Leads.csv    #iterates through the Leads csv
Suite Setup                   Setup Browser
Suite Teardown                End suite
Test Template                 Entering A Lead With Data

*** Test Cases ***
Entering A Lead With Data with ${First Name}    ${Last Name}    ${Phone}    ${Company}    ${Website}    
    [Tags]                    AllData

Entering A Lead With Data
    Entering A Lead With Data    ${First Name}    ${Last Name}    ${Phone}    ${Company}    ${Website}
