<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Welcome to InnoRide</title>
    <link rel="stylesheet" href="{{ asset('css/landingPage.css') }}">
</head>
<body>
    <div class="container">
        <!-- Judul Pindah ke Atas -->
        <div class="title">Welcome To InnoRide</div>

        <!-- Logo dan Box -->
        <div class="box-wrapper">
            <div class="box">
                <div class="logo">
                    <img src="{{ asset('assets/logo.png') }}" alt="Logo">
                </div>

                <a href="{{ route('login') }}" class="button">Sign In</a>
                <a href="{{ route('register') }}" class="button">Sign Up</a>
            </div>
        </div>
    </div>
</body>
</html>
