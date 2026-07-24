/* ═══════════════════════════════════════════════════════════════
   SNAPSPOT — animations.js
   Pure animation & visual effects only — zero data validation
═══════════════════════════════════════════════════════════════ */

(function () {
    "use strict";

    /* ─── 1. NAVBAR: shrink on scroll ───────────────────────── */
    const nav = document.getElementById("mainNav");

    window.addEventListener("scroll", function () {
        if (window.scrollY > 40) {
            nav.classList.add("scrolled");
        } else {
            nav.classList.remove("scrolled");
        }
    }, { passive: true });


    /* ─── 2. SCROLL-REVEAL (IntersectionObserver) ────────────── */
    const revealEls = document.querySelectorAll(".reveal-up, .reveal-right");

    const revealObserver = new IntersectionObserver(function (entries) {
        entries.forEach(function (entry) {
            if (!entry.isIntersecting) return;

            const el    = entry.target;
            const delay = parseInt(el.getAttribute("data-delay") || "0", 10);

            setTimeout(function () {
                el.classList.add("visible");
            }, delay);

            revealObserver.unobserve(el);   // animate once
        });
    }, { threshold: 0.15 });

    revealEls.forEach(function (el) {
        revealObserver.observe(el);
    });


    /* ─── 3. COUNTER ANIMATION (stat numbers) ───────────────── */
    const statNumbers = document.querySelectorAll(".stat-number");

    function animateCounter(el) {
        const target   = parseInt(el.getAttribute("data-target"), 10);
        const duration = 1600;   // ms
        const start    = performance.now();

        function tick(now) {
            const elapsed  = now - start;
            const progress = Math.min(elapsed / duration, 1);
            // Ease-out cubic
            const eased    = 1 - Math.pow(1 - progress, 3);
            el.textContent = Math.round(eased * target);
            if (progress < 1) requestAnimationFrame(tick);
        }

        requestAnimationFrame(tick);
    }

    const counterObserver = new IntersectionObserver(function (entries) {
        entries.forEach(function (entry) {
            if (!entry.isIntersecting) return;
            animateCounter(entry.target);
            counterObserver.unobserve(entry.target);
        });
    }, { threshold: 0.5 });

    statNumbers.forEach(function (el) {
        counterObserver.observe(el);
    });


    /* ─── 4. FAKE QR DOT GENERATION ─────────────────────────── */
    const qrDotsContainer = document.getElementById("qrDots");

    if (qrDotsContainer) {
        const COLS      = 10;
        const ROWS      = 10;
        const FILL_PROB = 0.55;   // density of dots

        // Leave corners blank (occupied by .qr-corner elements)
        const cornerMask = new Set([0, 1, 10, 11, 8, 9, 18, 19, 80, 81, 90, 91]);

        for (let i = 0; i < COLS * ROWS; i++) {
            const dot = document.createElement("div");
            if (!cornerMask.has(i) && Math.random() < FILL_PROB) {
                dot.className = "qr-dot";
            }
            qrDotsContainer.appendChild(dot);
        }
    }


    /* ─── 5. PORTAL CARD TILT (subtle 3-D hover) ────────────── */
    const portalCards = document.querySelectorAll(".portal-card");

    portalCards.forEach(function (card) {
        card.addEventListener("mousemove", function (e) {
            const rect   = card.getBoundingClientRect();
            const cx     = rect.left + rect.width  / 2;
            const cy     = rect.top  + rect.height / 2;
            const dx     = (e.clientX - cx) / (rect.width  / 2);   // -1 … +1
            const dy     = (e.clientY - cy) / (rect.height / 2);   // -1 … +1
            const tiltX  = -dy * 5;   // degrees
            const tiltY  =  dx * 5;

            card.style.transform = "translateY(-5px) rotateX(" + tiltX + "deg) rotateY(" + tiltY + "deg)";
        });

        card.addEventListener("mouseleave", function () {
            card.style.transform = "";
        });
    });


    /* ─── 6. STEP CARD STAGGER on first viewport hit ────────── */
    const stepCards = document.querySelectorAll(".step-card");

    const stepObserver = new IntersectionObserver(function (entries) {
        entries.forEach(function (entry) {
            if (!entry.isIntersecting) return;
            const idx = Array.from(stepCards).indexOf(entry.target);
            setTimeout(function () {
                entry.target.style.opacity   = "1";
                entry.target.style.transform = "translateY(0)";
            }, idx * 140);
            stepObserver.unobserve(entry.target);
        });
    }, { threshold: 0.2 });

    stepCards.forEach(function (card) {
        card.style.opacity   = "0";
        card.style.transform = "translateY(24px)";
        card.style.transition = "opacity 0.55s ease, transform 0.55s ease";
        stepObserver.observe(card);
    });


    /* ─── 7. FEATURE PILL POP-IN STAGGER ────────────────────── */
    const featPills = document.querySelectorAll(".feat-pill");

    const pillObserver = new IntersectionObserver(function (entries) {
        entries.forEach(function (entry) {
            if (!entry.isIntersecting) return;
            const idx = Array.from(featPills).indexOf(entry.target);
            setTimeout(function () {
                entry.target.style.opacity   = "1";
                entry.target.style.transform = "scale(1)";
            }, idx * 80);
            pillObserver.unobserve(entry.target);
        });
    }, { threshold: 0.2 });

    featPills.forEach(function (pill) {
        pill.style.opacity   = "0";
        pill.style.transform = "scale(0.94)";
        pill.style.transition = "opacity 0.45s ease, transform 0.45s ease";
        pillObserver.observe(pill);
    });


    /* ─── 8. SMOOTH ACTIVE NAV LINK on scroll ────────────────── */
    const sections    = document.querySelectorAll("section[id]");
    const navLinks    = document.querySelectorAll(".navbar-nav .nav-link");

    window.addEventListener("scroll", function () {
        let currentId = "";
        sections.forEach(function (sec) {
            if (window.scrollY >= sec.offsetTop - 120) {
                currentId = sec.getAttribute("id");
            }
        });

        navLinks.forEach(function (link) {
            link.classList.remove("active");
            if (link.getAttribute("href") === "index.jsp" && currentId === "home") {
                link.classList.add("active");
            }
        });
    }, { passive: true });

}());
