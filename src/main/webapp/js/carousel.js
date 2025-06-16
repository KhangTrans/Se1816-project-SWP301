document.addEventListener('DOMContentLoaded', function() {
    // Get carousel elements
    const carousel = document.getElementById('carousel');
    const carouselTrack = document.getElementById('carouselTrack');
    const carouselContainer = document.getElementById('carouselContainer');

    // Variables for dragging functionality
    let isDragging = false;
    let startPosition = 0;
    let currentTranslate = 0;
    let prevTranslate = 0;
    let animationID = 0;
    let startTime;
    let velocity = 0;
    let lastPosition = 0;
    let lastTime = 0;
    
    // Calculate slide width
    function getSlideWidth() {
        const slide = document.querySelector('.carousel__item');
        const style = getComputedStyle(slide);
        const width = slide.offsetWidth;
        const marginRight = parseInt(style.marginRight);
        const marginLeft = parseInt(style.marginLeft);
        
        return width + marginLeft + marginRight;
    }
    
    const slideWidth = getSlideWidth();
    let originalSlides = document.querySelectorAll('.carousel__item');
    let slidesCount = originalSlides.length;

    // Clone slides for infinite effect
    function setupInfiniteCarousel() {
        // Get all original slides
        const slides = Array.from(originalSlides);
        
        // Clone each slide and append to carousel
        slides.forEach(slide => {
            const clone = slide.cloneNode(true);
            carouselTrack.appendChild(clone);
        });
        
        // Clone again for smoother infinite effect
        slides.forEach(slide => {
            const clone = slide.cloneNode(true);
            carouselTrack.appendChild(clone);
        });
        
        // Start automatic scrolling
        startAutoScroll();
    }

    // Start automatic scrolling
    function startAutoScroll() {
        // Remove any inline styles
        carouselTrack.style.transition = '';
        carouselTrack.style.transform = '';
        
        // Apply scrolling animation
        setTimeout(() => {
            carouselTrack.classList.add('carousel__track--scrolling');
        }, 50);
    }

    // Stop automatic scrolling
    function stopAutoScroll() {
        carouselTrack.classList.remove('carousel__track--scrolling');
        
        // Get current transform value to continue from current position
        const transform = window.getComputedStyle(carouselTrack).getPropertyValue('transform');
        if (transform !== 'none') {
            const matrix = new DOMMatrixReadOnly(transform);
            prevTranslate = matrix.m41;
            currentTranslate = prevTranslate;
        }
    }

    // Touch and mouse events combined
    function touchStart(event) {
        // Prevent default behavior only for mouse events
        if (event.type === 'mousedown') {
            event.preventDefault();
        }
        
        // Reset velocity tracking
        startTime = new Date().getTime();
        lastPosition = getPositionX(event);
        lastTime = startTime;
        velocity = 0;
        
        stopAutoScroll();
        
        startPosition = getPositionX(event);
        isDragging = true;
        
        // Add visual feedback classes
        carouselTrack.style.transition = 'none';
        carousel.classList.add('carousel--grabbing');
        document.body.classList.add('no-select');
        
        // Stop any ongoing animation
        cancelAnimationFrame(animationID);
    }

    function touchMove(event) {
        if (isDragging) {
            const currentPosition = getPositionX(event);
            const currentTime = new Date().getTime();
            
            // Update velocity calculation
            if (currentTime - lastTime > 20) { // Update velocity every 20ms
                velocity = (currentPosition - lastPosition) / (currentTime - lastTime);
                lastPosition = currentPosition;
                lastTime = currentTime;
            }
            
            // Calculate new position
            currentTranslate = prevTranslate + currentPosition - startPosition;
            setSliderPosition();
        }
    }

    function touchEnd() {
        if (!isDragging) return;
        isDragging = false;
        
        // Remove visual feedback classes
        carousel.classList.remove('carousel--grabbing');
        document.body.classList.remove('no-select');
        
        // Calculate total width of all original slides
        const totalWidth = slideWidth * slidesCount;
        
        // Apply inertia effect based on velocity
        const inertiaDistance = velocity * 200; // Adjust multiplier for desired effect
        
        // Apply transition with momentum
        carouselTrack.style.transition = 'transform 0.8s cubic-bezier(0.25, 1, 0.5, 1)';
        currentTranslate = currentTranslate + inertiaDistance;
        
        // Ensure we wrap around correctly
        if (currentTranslate > totalWidth / 2) {
            // If scrolled too far right
            currentTranslate = -totalWidth;
        } else if (currentTranslate < -totalWidth * 2) {
            // If scrolled too far left
            currentTranslate = -totalWidth;
        }
        
        // Apply final position with smooth transition
        carouselTrack.style.transform = `translateX(${currentTranslate}px)`;
        
        // Store the final position
        prevTranslate = currentTranslate;
        
        // Reset and restart auto-scrolling after transition completes
        setTimeout(() => {
            startAutoScroll();
        }, 1000);
    }

    // Helper functions
    function getPositionX(event) {
        return event.type.includes('mouse') ? event.pageX : event.touches[0].clientX;
    }

    function setSliderPosition() {
        carouselTrack.style.transform = `translateX(${currentTranslate}px)`;
        
        if (isDragging) {
            animationID = requestAnimationFrame(setSliderPosition);
        }
    }

    // Add all event listeners
    function addEventListeners() {
        // Touch events
        carouselTrack.addEventListener('touchstart', touchStart, { passive: true });
        carouselTrack.addEventListener('touchmove', touchMove, { passive: true });
        carouselTrack.addEventListener('touchend', touchEnd);
        carouselTrack.addEventListener('touchcancel', touchEnd);
        
        // Mouse events
        carouselTrack.addEventListener('mousedown', touchStart);
        window.addEventListener('mousemove', touchMove);
        window.addEventListener('mouseup', touchEnd);
        window.addEventListener('mouseleave', touchEnd);
        
        // Prevent context menu
        carouselTrack.addEventListener('contextmenu', e => e.preventDefault());
        
        // Hover behavior
        carouselTrack.addEventListener('mouseenter', () => {
            if (carouselTrack.classList.contains('carousel__track--scrolling')) {
                carouselTrack.style.animationPlayState = 'paused';
            }
        });
        
        carouselTrack.addEventListener('mouseleave', () => {
            if (carouselTrack.classList.contains('carousel__track--scrolling')) {
                carouselTrack.style.animationPlayState = 'running';
            }
        });
    }

    // Initialize
    setupInfiniteCarousel();
    addEventListeners();
});