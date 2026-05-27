/**
 * ================================
 * OPENASSISTANT WEBSITE JAVASCRIPT
 * ================================
 * Enhanced interactions and animations for the OpenAssistant documentation website
 * Built with modern JavaScript and optimized for performance
 */

// ================================
// NAVIGATION & SCROLLING
// ================================

/**
 * Smooth scrolling for internal navigation links
 * Provides smooth page transitions when clicking anchor links
 * Enhanced Safari compatibility with fallback
 */
document.querySelectorAll('a[href^="#"]').forEach(function(anchor) {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            // Account for fixed navbar height
            const navbar = document.querySelector('.navbar');
            const navbarHeight = navbar ? navbar.offsetHeight : 70;
            const targetPosition = target.offsetTop - navbarHeight - 20;
            
            // Try modern smooth scrolling first
            if ('scrollBehavior' in document.documentElement.style) {
                window.scrollTo({
                    top: targetPosition,
                    behavior: 'smooth'
                });
            } else {
                // Fallback for Safari and older browsers
                const startPosition = window.pageYOffset;
                const distance = targetPosition - startPosition;
                const duration = 800;
                let start = null;
                
                function step(timestamp) {
                    if (!start) start = timestamp;
                    const progress = timestamp - start;
                    const progressPercentage = Math.min(progress / duration, 1);
                    
                    // Easing function for smooth animation
                    const ease = progressPercentage < 0.5 
                        ? 2 * progressPercentage * progressPercentage 
                        : 1 - Math.pow(-2 * progressPercentage + 2, 2) / 2;
                    
                    window.scrollTo(0, startPosition + distance * ease);
                    
                    if (progress < duration) {
                        window.requestAnimationFrame(step);
                    }
                }
                
                window.requestAnimationFrame(step);
            }
        }
    });
});

/**
 * Mobile navigation toggle functionality
 * Handles hamburger menu interactions and mobile navigation
 * Enhanced for Safari compatibility
 */
const hamburger = document.querySelector('.hamburger');
const navMenu = document.querySelector('.nav-menu');

if (hamburger && navMenu) {
    // Add click event listener with proper error handling
    hamburger.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        
        hamburger.classList.toggle('active');
        navMenu.classList.toggle('active');
        
        // Prevent body scroll when menu is open - Safari compatible
        if (navMenu.classList.contains('active')) {
            document.body.style.overflow = 'hidden';
            document.body.style.position = 'fixed';
            document.body.style.width = '100%';
        } else {
            document.body.style.overflow = '';
            document.body.style.position = '';
            document.body.style.width = '';
        }
    });

    // Close mobile menu when clicking on a link
    document.querySelectorAll('.nav-menu a').forEach(function(link) {
        link.addEventListener('click', function() {
            hamburger.classList.remove('active');
            navMenu.classList.remove('active');
            document.body.style.overflow = '';
            document.body.style.position = '';
            document.body.style.width = '';
        });
    });
    
    // Close mobile menu when clicking outside
    document.addEventListener('click', function(e) {
        if (!hamburger.contains(e.target) && !navMenu.contains(e.target)) {
            hamburger.classList.remove('active');
            navMenu.classList.remove('active');
            document.body.style.overflow = '';
            document.body.style.position = '';
            document.body.style.width = '';
        }
    });
}

// ================================
// SCROLL EFFECTS & ANIMATIONS
// ================================

/**
 * Dynamic navbar styling based on scroll position
 * Enhances navbar appearance as user scrolls down
 */
let ticking = false;

const updateNavbar = () => {
    const navbar = document.querySelector('.navbar');
    if (!navbar) return;
    
    if (window.scrollY > 50) {
        navbar.style.background = 'rgba(255, 255, 255, 0.98)';
        navbar.style.boxShadow = '0 2px 20px rgba(0, 0, 0, 0.1)';
    } else {
        navbar.style.background = 'rgba(255, 255, 255, 0.95)';
        navbar.style.boxShadow = 'none';
    }
    ticking = false;
};

window.addEventListener('scroll', () => {
    if (!ticking) {
        requestAnimationFrame(updateNavbar);
        ticking = true;
    }
});

/**
 * Intersection Observer for scroll-triggered animations
 * Provides smooth entrance animations for page elements
 */
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
};

const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.style.opacity = '1';
            entry.target.style.transform = 'translateY(0)';
            
            // Add staggered animation delay for grouped elements
            const siblings = Array.from(entry.target.parentNode.children);
            const index = siblings.indexOf(entry.target);
            entry.target.style.transitionDelay = `${index * 0.1}s`;
        }
    });
}, observerOptions);

// Apply intersection observer to animated elements
document.querySelectorAll('.overview-card, .feature-card, .tech-card, .flow-step').forEach(el => {
    el.style.opacity = '0';
    el.style.transform = 'translateY(30px)';
    el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
    observer.observe(el);
});

// ================================
// INTERACTIVE ENHANCEMENTS
// ================================

/**
 * Subtle phone mockup animation for visual appeal
 * Creates a floating effect to draw attention to the app preview
 */
const phoneMockup = document.querySelector('.phone-mockup');
if (phoneMockup) {
    phoneMockup.style.transition = 'transform 2s ease-in-out';
    
    const animatePhone = () => {
        phoneMockup.style.transform = 'translateY(-10px) rotate(1deg)';
        setTimeout(() => {
            phoneMockup.style.transform = 'translateY(0) rotate(0deg)';
        }, 2000);
    };
    
    // Start animation after page load, then repeat
    setTimeout(animatePhone, 2000);
    setInterval(animatePhone, 6000);
}

/**
 * Enhanced button interactions with ripple effect
 * Provides visual feedback for user interactions
 */
document.querySelectorAll('.btn').forEach(button => {
    button.addEventListener('click', function(e) {
        // Prevent multiple ripples
        const existingRipple = this.querySelector('.ripple');
        if (existingRipple) existingRipple.remove();
        
        const ripple = document.createElement('span');
        const rect = this.getBoundingClientRect();
        const size = Math.max(rect.width, rect.height);
        const x = e.clientX - rect.left - size / 2;
        const y = e.clientY - rect.top - size / 2;
        
        ripple.style.width = ripple.style.height = size + 'px';
        ripple.style.left = x + 'px';
        ripple.style.top = y + 'px';
        ripple.classList.add('ripple');
        
        this.appendChild(ripple);
        
        setTimeout(() => {
            ripple.remove();
        }, 600);
    });
});

// ================================
// DYNAMIC STYLES & EFFECTS
// ================================

/**
 * Inject dynamic CSS for enhanced interactions
 * Adds styles that work in conjunction with JavaScript animations
 */
const injectDynamicStyles = () => {
    const style = document.createElement('style');
    style.textContent = `
        /* Enhanced button interactions */
        .btn {
            position: relative;
            overflow: hidden;
            transform: translateY(0);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }
        
        .btn:active {
            transform: translateY(0);
        }
        
        /* Ripple effect animation */
        .ripple {
            position: absolute;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.6);
            transform: scale(0);
            animation: ripple-animation 0.6s linear;
            pointer-events: none;
        }
        
        @keyframes ripple-animation {
            to {
                transform: scale(4);
                opacity: 0;
            }
        }
        
        /* Enhanced mobile navigation */
        .nav-menu.active {
            display: flex;
            position: fixed;
            top: 70px;
            left: 0;
            width: 100%;
            height: calc(100vh - 70px);
            flex-direction: column;
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(20px);
            box-shadow: 0 2px 20px rgba(0, 0, 0, 0.1);
            padding: 50px 20px 20px;
            z-index: 999;
            animation: slideInFromRight 0.3s ease-out;
        }
        
        @keyframes slideInFromRight {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
        
        /* Enhanced hamburger animation */
        .hamburger {
            transition: all 0.3s ease;
        }
        
        .hamburger span {
            transition: all 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55);
        }
        
        .hamburger.active span:nth-child(1) {
            transform: rotate(-45deg) translate(-5px, 6px);
        }
        
        .hamburger.active span:nth-child(2) {
            opacity: 0;
            transform: scale(0);
        }
        
        .hamburger.active span:nth-child(3) {
            transform: rotate(45deg) translate(-5px, -6px);
        }
        
        /* Responsive design adjustments */
        @media (max-width: 768px) {
            .nav-menu {
                display: none;
            }
            
            .hamburger {
                display: flex;
            }
        }
        
        /* Focus styles for accessibility */
        .btn:focus,
        .nav-menu a:focus {
            outline: 2px solid #007AFF;
            outline-offset: 2px;
        }
        
        /* Smooth scroll behavior */
        html {
            scroll-behavior: smooth;
        }
        
        /* Enhanced card hover effects */
        .overview-card,
        .feature-card,
        .tech-card {
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        .overview-card:hover,
        .feature-card:hover,
        .tech-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
        }
    `;
    document.head.appendChild(style);
};

// ================================
// PERFORMANCE OPTIMIZATIONS
// ================================

/**
 * Optimize scroll performance with throttling
 * Prevents excessive scroll event firing
 */
const throttle = (func, limit) => {
    let inThrottle;
    return function() {
        const args = arguments;
        const context = this;
        if (!inThrottle) {
            func.apply(context, args);
            inThrottle = true;
            setTimeout(() => inThrottle = false, limit);
        }
    };
};

/**
 * Add parallax effect to hero background
 * Creates subtle depth and visual interest
 */
const addParallaxEffect = throttle(() => {
    const hero = document.querySelector('.hero');
    if (!hero) return;
    
    const scrolled = window.pageYOffset;
    const parallax = scrolled * 0.3;
    hero.style.backgroundPosition = `center ${parallax}px`;
}, 16); // ~60fps

window.addEventListener('scroll', addParallaxEffect);

// ================================
// IMAGE SIZING FALLBACKS
// ================================

/**
 * Enhanced image sizing fallback for cross-browser compatibility
 * Handles edge cases where CSS solutions may not work
 */
function ensureProperImageSizing() {
    const screenshots = document.querySelectorAll('.app-screenshot');
    
    screenshots.forEach(img => {
        // Function to properly size the image
        const sizeImage = () => {
            const container = img.closest('.app-preview');
            if (!container) return;
            
            const containerRect = container.getBoundingClientRect();
            const maxWidth = containerRect.width;
            const maxHeight = containerRect.height;
            
            // Set explicit dimensions
            img.style.width = '100%';
            img.style.height = '100%';
            img.style.maxWidth = maxWidth + 'px';
            img.style.maxHeight = maxHeight + 'px';
            img.style.objectFit = 'cover';
            img.style.objectPosition = 'center';
            
            // Fallback for browsers that don't support object-fit
            if (!CSS.supports('object-fit', 'cover')) {
                img.style.width = maxWidth + 'px';
                img.style.height = maxHeight + 'px';
                
                // Hide img and use background on container
                img.style.opacity = '0';
                img.style.position = 'absolute';
                
                container.style.backgroundImage = `url(${img.src})`;
                container.style.backgroundSize = 'cover';
                container.style.backgroundPosition = 'center';
                container.style.backgroundRepeat = 'no-repeat';
            }
        };
        
        // Apply sizing when image loads
        if (img.complete) {
            sizeImage();
        } else {
            img.addEventListener('load', sizeImage);
            img.addEventListener('error', () => {
                console.warn('Failed to load app screenshot');
                // Provide a fallback or placeholder
                const container = img.closest('.app-preview');
                if (container) {
                    container.style.background = 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)';
                    container.innerHTML = '<div style="color: white; text-align: center; font-size: 14px; padding: 20px;">App Preview</div>';
                }
            });
        }
        
        // Re-apply sizing on window resize
        const resizeHandler = throttle(sizeImage, 250);
        window.addEventListener('resize', resizeHandler);
    });
}

/**
 * Handle viewport changes that might affect image sizing
 */
function handleViewportChanges() {
    const phoneMockups = document.querySelectorAll('.phone-mockup');
    
    phoneMockups.forEach(mockup => {
        const updateMockupSize = () => {
            const viewportWidth = window.innerWidth;
            const viewportHeight = window.innerHeight;
            
            // Dynamic sizing based on viewport
            if (viewportWidth <= 360) {
                mockup.style.width = Math.min(220, viewportWidth * 0.7) + 'px';
                mockup.style.height = Math.min(440, viewportHeight * 0.55) + 'px';
            } else if (viewportWidth <= 480) {
                mockup.style.width = Math.min(250, viewportWidth * 0.75) + 'px';
                mockup.style.height = Math.min(500, viewportHeight * 0.6) + 'px';
            } else if (viewportWidth <= 768) {
                mockup.style.width = Math.min(280, viewportWidth * 0.7) + 'px';
                mockup.style.height = Math.min(560, viewportHeight * 0.65) + 'px';
            } else {
                // Use CSS defaults for larger screens
                mockup.style.width = '';
                mockup.style.height = '';
            }
        };
        
        updateMockupSize();
        window.addEventListener('resize', throttle(updateMockupSize, 250));
        window.addEventListener('orientationchange', () => {
            setTimeout(updateMockupSize, 100); // Small delay for orientation change
        });
    });
}

// ================================
// INITIALIZATION
// ================================

/**
 * Initialize all website functionality when DOM is ready
 */
document.addEventListener('DOMContentLoaded', () => {
    // Dynamic styles are now handled in CSS file for better Safari compatibility
    // injectDynamicStyles();
    
    // Add loading class to body for initial animations
    document.body.classList.add('loaded');
    
    // Ensure body is visible
    document.body.style.opacity = '1';
    
    // Initialize image sizing fallbacks
    ensureProperImageSizing();
    handleViewportChanges();
    
    // Initialize any additional features
    console.log('OpenAssistant website initialized successfully');
});

// Also set loaded on window load as fallback
window.addEventListener('load', () => {
    document.body.classList.add('loaded');
    document.body.style.opacity = '1';
});

/**
 * Handle page visibility changes for performance
 * Pause animations when page is not visible
 */
document.addEventListener('visibilitychange', () => {
    if (document.hidden) {
        // Pause expensive operations
        document.body.style.animationPlayState = 'paused';
    } else {
        // Resume operations
        document.body.style.animationPlayState = 'running';
    }
});
