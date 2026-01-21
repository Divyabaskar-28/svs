<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>SVS Sweets - Home</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <style>
            html {
                scroll-behavior: smooth;
            }
            body {
                background-color: #fff8f0;
                font-family: 'Segoe UI', sans-serif;
            }
            .navbar {
                background-color: #DC143C; /* Crimson */
            }
            .nav-link, .navbar-brand {
                color: #fff !important;
                font-weight: 500;
                margin-left: 15px;
                position: relative;
            }
            .nav-link::after {
                content: '';
                position: absolute;
                width: 0%;
                height: 2px;
                background-color: #fff;
                bottom: -5px;
                left: 0;
                transition: width 0.3s ease-in-out;
            }
            .nav-link:hover::after {
                width: 100%;
            }
            .navbar-brand img {
                border-radius: 50%;
                background-color: white;
                padding: 4px;
            }

            .banner {
                background: linear-gradient(to right, #ffcccc, #fff8f0);
                padding: 60px 20px;
            }
            .sweet-card {
                border-radius: 15px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
                transition: transform 0.3s;
            }
            .sweet-card:hover {
                transform: scale(1.03);
            }
            .card-title {
                color: #8B0000;
            }
            .about-section {
                background-color: #fff0f0;
                padding: 40px 20px;
                border-radius: 15px;
                margin-top: 50px;
            }
            footer {
                background-color: #FF6F61; /* Coral red */
                padding: 30px 0;
                color: white;
            }
            footer a {
                color: #fff;
                text-decoration: none;
            }
            footer a:hover {
                text-decoration: underline;
            }
            section, div[id] {
                scroll-margin-top: 100px; /* Adjust based on your navbar height */
            }

        </style>
    </head>
    <body>

        <!-- Header -->
        <nav class="navbar navbar-expand-lg shadow sticky-top">
            <div class="container">
                <a class="navbar-brand fw-bold fs-3 d-flex align-items-center" href="#">
                    <img src="Images/logo.png" alt="SVS Logo" width="50" height="50" class="me-2">
                    SVS Cottage Industry
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse ms-auto" id="navbarNav">
                    <ul class="navbar-nav ms-auto align-items-center">
                        <li class="nav-item"><a class="nav-link" href="#">Home</a></li>
                        <li class="nav-item"><a class="nav-link" href="#specialties">Specialties</a></li>
                        <li class="nav-item"><a class="nav-link" href="#about">About</a></li>
                        <li class="nav-item"><a class="nav-link" href="#contact">Contact</a></li>
                        <li class="nav-item"><a href="Login.jsp" class="btn btn-light ms-3">Login</a></li>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Welcome Banner -->
        <div class="banner text-center">
            <h1 class="text-danger fw-bold">Welcome to SVS Cottage Industry</h1>
<!--            <p class="lead">Taste the tradition in every bite – Peanut Candy, Cashew Candy, Ellu Ball & more!</p>-->
            <img src="Images/banner2.png" alt="Sweets Banner" class="img-fluid mt-4 img-thumbnail" style="max-height: 300px;">
        </div>

        <!-- Product Section -->
        <div id="specialties" class="container mt-5">
            <h2 class="text-center text-danger mb-4">Our Specialties</h2>
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="card sweet-card">
                        <img src="Images/burfi1.jpg" class="card-img-top" alt="Peanut Candy" style="height:280px;">
                        <div class="card-body text-center">
                            <h5 class="card-title">Peanut Candy</h5>
                            <p>Crunchy and sweet, made with roasted peanuts and jaggery – a healthy traditional delight.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card sweet-card">
                        <img src="Images/cashew2.jpg" class="card-img-top" alt="Cashew Candy" style="height:280px;">
                        <div class="card-body text-center">
                            <h5 class="card-title">Cashew Candy</h5>
                            <p>Rich in flavor, packed with premium cashews — perfect for celebrations and gifts. A treat that melts in your mouth with every bite.</p>

                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card sweet-card">
                        <img src="Images/ellu.jpg" class="card-img-top" alt="Ellu Ball" style="height:280px;">
                        <div class="card-body text-center">
                            <h5 class="card-title">Ellu Ball</h5>
                            <p>Traditional sesame balls blended with jaggery – a healthy and energetic sweet loved by all ages.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- About Us -->
        <div id="about" class="container about-section text-center mt-5">
            <h3 class="text-danger fw-bold">About SVS Sweets</h3>
            <p class="mt-3">
                SVS Sweets was founded in 1995 with a simple mission – to share the authentic flavors of traditional Indian sweets 
                made with love and purity. From humble beginnings as a cottage industry, we have grown into a trusted name known 
                for quality, taste, and tradition.
            </p>
            <p>
                Every sweet we make is a celebration of our culture and heritage. We use time-tested recipes and the finest 
                ingredients – handpicked nuts, pure jaggery, and aromatic spices – to craft sweets that are not only delicious but 
                also healthy and energizing.
            </p>
            <p>
                Whether it's a festive occasion, a family gathering, or just a moment of craving, SVS Sweets is here to add 
                sweetness to your life. Our specialties like Peanut Candy, Cashew Burfi, and Ellu Urundai have won hearts across 
                generations.
            </p>
            <p class="fw-bold text-danger">
                Come, experience the tradition of taste – only at SVS Sweets!
            </p>
        </div>

        <!-- Contact Section -->
        <footer id="contact" class="text-center mt-5">
            <div class="container">
                <h5 class="fw-bold mb-3">Contact Us</h5>
                <p class="mb-1">SVS Cottage Industry</p>
                <p class="mb-1">616/1, Vaikunda Samy Nagar, Eachanari, Tamil Nadu 641021</p>
                <p class="mb-1">GST: 33AHTPT5363M1ZH</p>
                <p class="mb-0">Phone: <a href="tel:9442641997" class="fw-bold">9442641997</a></p>
            </div>
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
