*** Settings ***
Documentation  DevOpsDemo Application Login Page Object
Library  SeleniumLibrary


*** Keywords ***
Load
    go to  ${START_URL}
    page should contain image  images/KovairLogo-trans.png

Sign In
    input text  txtUserId  ${USERNAME}
    input password  txtPassword  ${PASSWORD}
    click button  btnClick
    sleep  10s

Focus Out UserName TextBox
    click element  txtUserId
    click element  css:div.panel-heading

Focus Out Password Box
    click element  txtPassword
    click element  css:div.panel-heading

UserName Validation Shown
    element should be visible  css:span[data-ng-show="loginform.userName.$error.required"]

Password Validation Shown
    element should be visible  css:span[data-ng-show="loginform.password.$error.required"]


Invalid Login Validation Shown
    input text  txtUserId  invalid
    input password  txtPassword  invalid
    click button  btnClick
    sleep  5s
    element should be visible  css:span[data-ng-show="inValidLogin"]

Click Login Button
    click button  btnClick
    sleep  10s

