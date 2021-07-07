*** Settings ***
Documentation  DevOps Application Headless Test with Robot Framework 
Resource  ../Resources/Common.robot
Resource  ../Resources/KovairDevOpsDemoApp.robot


Test Setup  Common.Begin Web Test
Test Teardown  Common.End Web Test

*** Variables ***
${BROWSER} =  gc
#${START_URL} =  http://192.168.11.175:8080/KovairDevOpsDemoApp_Puppet/
${USERNAME} =  admin
${PASSWORD} =  admin

*** Test Cases ***
Check User Name Can Not Be Blank
    Login Page Load
    Enter Blank User
    Click Login

Check Password Can Not Be Blank
    Login Page Load
    Enter Blank User
    Click Login

Check User Can Not Login With Invalid Credential
    Login Page Load
    Enter Invalid User Details

Check User Can Login With Valid Credential
    Login Page Load
    Sign In
    Dashboard Page Loaded

Check User Can Logout From Dashboard
    Login Page Load
    Sign In
    Dashboard Page Loaded
    Logout From Dashboard

