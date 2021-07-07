*** Settings ***
Documentation  Kovair DevOps Demo Application BVT
Resource  PO/Login.robot
Resource  PO/Dashboard.robot


*** Keywords ***
Login Page Load
    Login.Load
    sleep  10s

Enter Blank User
    Login.Focus Out UserName TextBox
    Login.UserName Validation Shown


Enter Blank Password
    Login.Focus Out Password Box
    Login.Password Validation Shown


Enter Invalid User Details
    Login.Invalid Login Validation Shown


Enter Valid User Details And Login
    Login.Sign In


Dashboard Page Loaded
    Dashboard.Load
    sleep  5s

Logout From Dashboard
    Dashboard.Click On Logout
    sleep  10s
    Login Page Load

Click Login
    Login.Click Login Button
