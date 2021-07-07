*** Settings ***
Library  SeleniumLibrary
Library  XvfbRobot

*** Keywords ***
Begin Web Test
    #open browser  about:blank  gc
    #maximize browser window
    Create A Chrome Instance For Linux

End Web Test
    close all browsers


Create A Chrome Instance For Linux
    start virtual display  850  850
    ${option}  evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys
    call method  ${option}  add_argument  --no-sandbox
    call method  ${option}  add_argument  --disable-setuid-sandbox
    call method  ${option}  add_argument  --headless
    create webdriver  Chrome  chrome_options=${option}
