<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Index</title>
<script src="scripts/angular.js"></script>
<link rel="stylesheet" href="css/bootstrap.css" type="text/css" />
<link rel="stylesheet" href="css/LoginPage.css" type="text/css" />
<script src="http://ui-grid.info/docs/grunt-scripts/csv.js"></script>
<script src="http://ui-grid.info/docs/grunt-scripts/pdfmake.js"></script>
<script src="http://ui-grid.info/docs/grunt-scripts/vfs_fonts.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/angular-ui-grid/4.0.6/ui-grid.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/angular-ui-grid/4.0.6/ui-grid.css"  type="text/css"/>
<script src="js/app.js"></script>
<script src="js/controller.js"></script>
<script src="js/service.js"></script>
</head>
<body data-ng-app="DevOpsDemoApp">
  <div class="wrapper">
    <div class="content">
      <div class="container-fluid">
     
       <div class="col-md-6 col-md-offset-3">
       <div class="login-div" data-ng-controller="homeController" >
        <div style="text-align: center; padding-bottom: 25px">
        	<img alt="" src="images/KovairLogo-trans.png" height="20">
        </div>
          <div class="panel panel-primary" style="">
            <div class="panel-heading"><span><img src="images/key_PNG1174.png" height="20" width="20"/></span><b>Employee Management</b></div>
            <div class="panel-body" style="padding-top: 27px">
              <form class="form-horizontal" name="loginform" role="form">
                <div class="form-group">
                  <label class="control-label col-sm-4" for="UserId">User ID:</label>
                  <div class="col-sm-6">
                    <input type="text" class="form-control" data-ng-model="user.userName" id="txtUserId" name="userName" required alphabatic-character alphaspace-Character placeholder="Enter User Id Here" maxlength="30" />
                    <span style="color:red" data-ng-show="(loginform.userName.$dirty || loginform.userName.$touched) && loginform.userName.$invalid">
                        <span data-ng-show="loginform.userName.$error.required">User Name is required.</span>
                        <span data-ng-show="loginform.userName.$error.alphabaticalError" data-ng-hide="loginform.userName.$error.nameError || loginform.userName.$error.required">User Name should only contain alphabetic characters.</span>
                        <span data-ng-show="loginform.userName.$error.nameError">User Name should not contain whitespace.</span>
                     </span>
                  </div>
                </div>
                <div class="form-group">
                  <label class="control-label col-sm-4" for="Password">Password:</label>
                  <div class="col-sm-6">
                    <input type="password" class="form-control" data-ng-model="user.password" id="txtPassword" name="password" required placeholder="Enter Password Here" maxlength="20" />
					<span style="color:red" data-ng-show="(loginform.password.$dirty || loginform.password.$touched) && loginform.password.$invalid">
                        <span data-ng-show="loginform.password.$error.required">Password is required.</span>
                     </span>
                  </div>
                </div>
                <div class="form-group">
                  <div class="col-sm-offset-4 col-sm-8">
                    <div class="checkbox">
                      <label>
                        <input type="checkbox" />Keep me logged in</label>
                    </div>
                  </div>
                </div>
                <div class="form-group">
                  <div class="col-sm-offset-4 col-sm-8">
                    <button id="btnClick" type="submit" class="btn btn-primary btn-md" data-ng-click="login()">Login</button>
                  </div>
                  <span style="color:red">
                       <span data-ng-show="inValidLogin">{{errorMsg}}</span>
                   </span>
                </div>
              </form>
            </div>
          </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</body>
</html>
