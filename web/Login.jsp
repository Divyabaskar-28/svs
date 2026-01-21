<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Login - SVS Sweets</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body {
            background-color: #fff8f0;
            font-family: 'Segoe UI', sans-serif;
        }
        .login-box {
            margin-top: 150px;
            padding: 30px;
            border-radius: 15px;
            background-color: #ffffff;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        h2 {
            color: #DC143C;
        }
        .btn-danger {
            background-color: #DC143C;
            border-color: #B22222;
        }
        .error-msg {
            color: red;
        }
    </style>
    <script>
        function validateLogin() {
            var username = document.loginForm.username.value.trim();
            var password = document.loginForm.password.value.trim();
            if (username === "" || password === "") {
                document.getElementById("msg").innerText = "Both fields are required!";
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
    <div class="container d-flex justify-content-center">
        <div class="col-md-5 login-box text-center">
            <h2>Admin Login</h2>
            <form name="loginForm" action="AdminLoginServlet" method="post" onsubmit="return validateLogin();">
                <div class="form-group mt-4">
                    <input type="text" name="username" class="form-control" placeholder="Enter Username">
                </div>
                <div class="form-group mt-3">
                    <input type="password" name="password" class="form-control" placeholder="Enter Password">
                </div>
                <div class="error-msg mt-2" id="msg"></div>
                <button type="submit" class="btn btn-danger w-100 mt-3">Login</button>
            </form>
        </div>
    </div>
</body>
</html>
