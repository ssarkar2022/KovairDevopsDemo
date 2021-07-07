*** Settings ***
Documentation  DevOpsDemo Application Login Page Object
Library  SeleniumLibrary

*** Keywords ***

Load
    page should contain image  images/Kovair_logo_transp-white-Employee-Management.png
    page should contain element  css:div[ui-grid-row="row"]

Click On Logout
    click link  logoutClick
