<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SNAPSPOT — QR Based Parking System</title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;600;700&family=Inter:wght@300;400;500&display=swap" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <!-- ═══════════════════════════  NAVBAR  ═══════════════════════════ -->
    <nav class="navbar navbar-expand-lg fixed-top" id="mainNav">
        <div class="container-xl">

            <!-- Brand -->
            <a class="navbar-brand d-flex align-items-center gap-2" href="index.jsp">
                <div class="brand-icon">
                    <i class="bi bi-qr-code-scan"></i>
                </div>
                <span class="brand-text">SNAP<span class="brand-accent">SPOT</span></span>
            </a>

            <!-- Toggler -->
            <button class="navbar-toggler" type="button"
                    data-bs-toggle="collapse" data-bs-target="#navbarNav"
                    aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="toggler-bar"></span>
                <span class="toggler-bar"></span>
                <span class="toggler-bar"></span>
            </button>

            <!-- Nav Links -->
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-lg-center gap-lg-1">
                    <li class="nav-item">
                        <a class="nav-link active" href="index.jsp">
                            <i class="bi bi-house me-1"></i>Home
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="admin/dashboard.jsp">
                            <i class="bi bi-shield-lock me-1"></i>Administrator
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="ticket-checker/dashboard.jsp">
                            <i class="bi bi-upc-scan me-1"></i>Ticket Checker
                        </a>
                    </li>
                    <li class="nav-item ms-lg-2">
                        <a class="nav-link btn-nav-cta" href="user/user.jsp">
                            <i class="bi bi-person-circle me-1"></i>Users
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- ═══════════════════════════  HERO  ═══════════════════════════ -->
    <section class="hero-section" id="home">
        <!-- Animated grid backdrop -->
        <div class="hero-grid" aria-hidden="true"></div>
        <!-- Floating orbs -->
        <div class="orb orb-1" aria-hidden="true"></div>
        <div class="orb orb-2" aria-hidden="true"></div>

        <div class="container-xl position-relative">
            <div class="row align-items-center min-vh-hero">

                <!-- Left copy -->
                <div class="col-lg-6 hero-copy">
                    <span class="eyebrow-tag reveal-up" data-delay="0">
                        <i class="bi bi-qr-code"></i>&nbsp; QR-Powered Parking
                    </span>
                    <h1 class="hero-title reveal-up" data-delay="100">
                        Park Smart.<br>
                        <span class="gradient-text">Scan. Done.</span>
                    </h1>
                    <p class="hero-sub reveal-up" data-delay="200">
                        SNAPSPOT automates parking ticket booking and verification
                        through instant QR codes — zero queues, zero paperwork.
                    </p>
                    <div class="hero-actions reveal-up" data-delay="300">
                        <a href="user/user.jsp" class="btn btn-primary-snap">
                            Book a Ticket &nbsp;<i class="bi bi-arrow-right"></i>
                        </a>
                        <a href="#how-it-works" class="btn btn-ghost-snap">
                            See How It Works
                        </a>
                    </div>
                </div>

<!--                 Right QR graphic 
                <div class="col-lg-6 d-flex justify-content-center hero-graphic reveal-right" data-delay="200">
                    <div class="qr-card">
                        <div class="qr-card-inner">
                             Simulated QR 
                            <div class="fake-qr" id="fakeQR" aria-label="Sample QR code graphic">                            
                                <div class="qr-corner tl"></div>
                                <div class="qr-corner tr"></div>
                                <div class="qr-corner bl"></div>
                                <div class="qr-dots" id="qrDots"></div>
                            </div>
                           
                                
                            <div class="qr-card-label">
                                <span class="qr-id">TKT-2024-00471</span>
                                <span class="qr-status"><i class="bi bi-patch-check-fill"></i> Valid</span>
                            </div>
                             Scan line animation 
                            <div class="scan-line" aria-hidden="true"></div>
                        </div>
                    </div>
                </div>-->

            </div>
        </div>

        <!-- Scroll cue -->
        <a href="#stats" class="scroll-cue" aria-label="Scroll down">
            <i class="bi bi-chevron-compact-down"></i>
        </a>
    </section>

    <!-- ═══════════════════════════  HOW IT WORKS  ═══════════════════════════ -->
    <section class="section-pad" id="how-it-works">
        <div class="container-xl">
            <div class="section-header text-center reveal-up">
                <span class="section-eyebrow">The Process</span>
                <h2 class="section-title">Three steps to a hassle-free park</h2>
            </div>

            <div class="row g-4 mt-2 justify-content-center">

                <div class="col-md-4 reveal-up" data-delay="0">
                    <div class="step-card">
                        <div class="step-icon-wrap">
                            <i class="bi bi-calendar2-check"></i>
                        </div>
                        <div class="step-num">01</div>
                        <h3 class="step-title">Book Online</h3>
                        <p class="step-desc">
                            Choose your parking zone, date, and slot through the
                            user portal in under a minute.
                        </p>
                    </div>
                </div>

                <div class="col-md-4 reveal-up" data-delay="150">
                    <div class="step-card step-card--accent">
                        <div class="step-icon-wrap">
                            <i class="bi bi-qr-code-scan"></i>
                        </div>
                        <div class="step-num">02</div>
                        <h3 class="step-title">Get Your QR</h3>
                        <p class="step-desc">
                            A unique encrypted QR ticket is generated instantly and
                            sent to your registered account.
                        </p>
                    </div>
                </div>

                <div class="col-md-4 reveal-up" data-delay="300">
                    <div class="step-card">
                        <div class="step-icon-wrap">
                            <i class="bi bi-barrier"></i>
                        </div>
                        <div class="step-num">03</div>
                        <h3 class="step-title">Scan & Enter</h3>
                        <p class="step-desc">
                            The checker scans your QR at the gate — barrier lifts
                            in under 3 seconds. No manual checks needed.
                        </p>
                    </div>
                </div>

            </div>
        </div>
    </section>

    <!-- ═══════════════════════════  PORTAL CARDS  ═══════════════════════════ -->
    <section class="section-pad section-dark" id="portals">
        <div class="container-xl">
            <div class="section-header text-center reveal-up">
                <span class="section-eyebrow">Access Portals</span>
                <h2 class="section-title">Who are you?</h2>
            </div>

            <div class="row g-4 mt-2">

                <!-- Admin -->
                <div class="col-md-4 reveal-up" data-delay="0">
                    <a href="admin/login.jsp" class="portal-card portal-card--admin text-decoration-none">
                        <div class="portal-icon"><i class="bi bi-shield-lock"></i></div>
                        <h3 class="portal-name">Administrator</h3>
                        <p class="portal-desc">Manage zones, users, reports and system settings from a unified dashboard.</p>
                        <span class="portal-arrow"><i class="bi bi-arrow-right-circle-fill"></i></span>
                    </a>
                </div>

                <!-- Ticket Checker -->
                <div class="col-md-4 reveal-up" data-delay="150">
                    <a href="ticket-checker/login.jsp" class="portal-card portal-card--checker text-decoration-none">
                        <div class="portal-icon"><i class="bi bi-upc-scan"></i></div>
                        <h3 class="portal-name">Ticket Checker</h3>
                        <p class="portal-desc">Instantly verify QR tickets at entry gates with one tap on any device.</p>
                        <span class="portal-arrow"><i class="bi bi-arrow-right-circle-fill"></i></span>
                    </a>
                </div>

                <!-- User -->
                <div class="col-md-4 reveal-up" data-delay="300">
                    <a href="user/user.jsp" class="portal-card portal-card--user text-decoration-none">
                        <div class="portal-icon"><i class="bi bi-person-circle"></i></div>
                        <h3 class="portal-name">User Portal</h3>
                        <p class="portal-desc">Book tickets, view your parking history, and download QR passes anytime.</p>
                        <span class="portal-arrow"><i class="bi bi-arrow-right-circle-fill"></i></span>
                    </a>
                </div>

            </div>
        </div>
    </section>

    <!-- ═══════════════════════════  FEATURES  ═══════════════════════════ -->
    <section class="section-pad" id="features">
        <div class="container-xl">
            <div class="row align-items-center g-5">

                <div class="col-lg-5 reveal-up">
                    <span class="section-eyebrow">Why SNAPSPOT</span>
                    <h2 class="section-title">Built for speed,<br>designed for scale</h2>
                    <p class="section-body">
                        Traditional parking management wastes hours. SNAPSPOT replaces
                        paper tickets and manual checks with a fully digital, QR-driven
                        workflow that fits any lot size.
                    </p>
                </div>

                <div class="col-lg-7">
                    <div class="row g-3">
                        <div class="col-sm-6 reveal-up" data-delay="0">
                            <div class="feat-pill">
                                <i class="bi bi-lightning-charge-fill feat-icon"></i>
                                <div>
                                    <strong>Instant Verification</strong>
                                    <span>QR scan completes in under 3 seconds</span>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6 reveal-up" data-delay="100">
                            <div class="feat-pill">
                                <i class="bi bi-lock-fill feat-icon"></i>
                                <div>
                                    <strong>Tamper-Proof Tickets</strong>
                                    <span>Encrypted unique codes per booking</span>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6 reveal-up" data-delay="200">
                            <div class="feat-pill">
                                <i class="bi bi-phone-fill feat-icon"></i>
                                <div>
                                    <strong>Mobile-First</strong>
                                    <span>Book and present QR from any device</span>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6 reveal-up" data-delay="300">
                            <div class="feat-pill">
                                <i class="bi bi-bar-chart-line-fill feat-icon"></i>
                                <div>
                                    <strong>Live Analytics</strong>
                                    <span>Admin dashboard with real-time reports</span>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6 reveal-up" data-delay="400">
                            <div class="feat-pill">
                                <i class="bi bi-clock-history feat-icon"></i>
                                <div>
                                    <strong>Booking History</strong>
                                    <span>Full log of every user transaction</span>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6 reveal-up" data-delay="500">
                            <div class="feat-pill">
                                <i class="bi bi-diagram-3-fill feat-icon"></i>
                                <div>
                                    <strong>Multi-Zone Support</strong>
                                    <span>Manage unlimited parking locations</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </section>

    <!-- ═══════════════════════════  CTA BANNER  ═══════════════════════════ -->
    <section class="cta-banner">
        <div class="container-xl text-center reveal-up">
            <h2 class="cta-title">Ready to park smarter?</h2>
            <p class="cta-sub">Join thousands of drivers who've ditched the paper ticket for good.</p>
            <a href="user/user.jsp" class="btn btn-primary-snap btn-lg mt-3">
                Get Started &nbsp;<i class="bi bi-arrow-right"></i>
            </a>
        </div>
    </section>

    <!-- ═══════════════════════════  FOOTER  ═══════════════════════════ -->
    <footer class="site-footer">
        <div class="container-xl">
            <div class="row align-items-center gy-3">
                <div class="col-md-4">
                    <a class="footer-brand d-flex align-items-center gap-2 text-decoration-none" href="index.jsp">
                        <div class="brand-icon brand-icon--sm">
                            <i class="bi bi-qr-code-scan"></i>
                        </div>
                        <span class="brand-text">SNAP<span class="brand-accent">SPOT</span></span>
                    </a>
                    <p class="footer-tag mt-2">QR Based Parking System</p>
                </div>
                <div class="col-md-4 text-md-center">
                    <nav class="footer-nav d-flex justify-content-md-center gap-3 flex-wrap">
                        <a href="index.jsp">Home</a>
                        <a href="admin/login.jsp">Administrator</a>
                        <a href="ticket-checker/login.jsp">Ticket Checker</a>
                        <a href="user/user.jsp">Users</a>
                    </nav>
                </div>
                <div class="col-md-4 text-md-end">
                    <p class="footer-copy">&copy; 2024 SNAPSPOT. All rights reserved.</p>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Custom Animations JS -->
    <script src="js/animations.js"></script>
</body>
</html>
