<%-- 
    Document   : navbar
    Created on : 27 Jun 2026, 9:33:08 pm
    Author     : vilva
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

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
                        <a class="nav-link" href="checker/scan.jsp">
                            <i class="bi bi-upc-scan me-1"></i>Ticket Checker
                        </a>
                    </li>
                    <li class="nav-item ms-lg-2">
                        <a class="nav-link btn-nav-cta" href="user/portal.jsp">
                            <i class="bi bi-person-circle me-1"></i>Users
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
