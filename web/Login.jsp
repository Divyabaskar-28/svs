<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Login - SVS Sweets</title>

    <!-- ✅ Important for Responsive Design -->
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #fff1eb, #ffd6d6);
            font-family: 'Segoe UI', sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 15px; /* ✅ prevents overflow on small devices */
        }

        /* 🔥 Login Card */
        .login-box {
            width: 100%;
            max-width: 420px;
            padding: 35px 30px;
            border-radius: 18px;
            background: #ffffff;
            box-shadow: 0 20px 40px rgba(220,20,60,0.25);
            animation: slideFade 0.8s ease;
        }

        @keyframes slideFade {
            from {
                opacity: 0;
                transform: translateY(40px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        h2 {
            color: #DC143C;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .sub-text {
            color: #777;
            font-size: 14px;
            margin-bottom: 25px;
        }

        /* 🔴 Input Fields */
        .form-control {
            height: 45px;
            border-radius: 10px;
            border: 1px solid #ddd;
            transition: 0.3s;
            font-size: 14px;
        }

        .form-control:focus {
            border-color: #DC143C;
            box-shadow: 0 0 0 3px rgba(220,20,60,0.15);
        }

        /* 🔥 Login Button */
        .btn-danger {
            background: linear-gradient(135deg, #DC143C, #B22222);
            border: none;
            border-radius: 10px;
            height: 45px;
            font-weight: 600;
            transition: 0.3s;
        }

        .btn-danger:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(220,20,60,0.4);
        }

        /* ⚠ Error Message */
        .error-msg {
            color: red;
            font-size: 14px;
            min-height: 18px;
        }

        /* 🍬 Logo Circle */
        .logo-circle {
            width: 70px;
            height: 70px;
            margin: 0 auto 15px;
            border-radius: 50%;
            background: linear-gradient(135deg, #DC143C, #B22222);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 28px;
            font-weight: bold;
            box-shadow: 0 8px 20px rgba(220,20,60,0.4);
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { box-shadow: 0 0 0 0 rgba(220,20,60,0.5); }
            70% { box-shadow: 0 0 0 15px rgba(220,20,60,0); }
            100% { box-shadow: 0 0 0 0 rgba(220,20,60,0); }
        }

        /* ✅ Extra Small Devices */
        @media (max-width: 576px) {

            .login-box {
                padding: 25px 20px;
            }

            h2 {
                font-size: 22px;
            }

            .sub-text {
                font-size: 13px;
            }

            .logo-circle {
                width: 60px;
                height: 60px;
                font-size: 22px;
            }

            .form-control {
                height: 42px;
            }

            .btn-danger {
                height: 42px;
            }
        }

        /* ✅ Tablets */
        @media (min-width: 577px) and (max-width: 992px) {
            .login-box {
                max-width: 450px;
            }
        }

        /* ✅ Large Screens */
        @media (min-width: 1200px) {
            .login-box {
                max-width: 420px;
            }
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

    <div class="login-box text-center">

        <div class="logo-circle">SVS</div>

        <h2>Admin Login</h2>
        <div class="sub-text">Welcome back! Please login to continue</div>

        <form name="loginForm" action="AdminLoginServlet" method="post" onsubmit="return validateLogin();">

            <div class="mb-3">
                <input type="text" name="username" class="form-control" placeholder="Username">
            </div>

            <div class="mb-2">
                <input type="password" name="password" class="form-control" placeholder="Password">
            </div>

            <div class="error-msg mb-2" id="msg"></div>

            <button type="submit" class="btn btn-danger w-100 mt-2">
                Login
            </button>

        </form>

    </div>

</body>
</html>