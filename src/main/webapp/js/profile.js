document.addEventListener("DOMContentLoaded", function () {
    // Default to 'profileContent' tab on page load
    showTab('profileContent');

    // Add listeners to all tab buttons
    const tabs = document.querySelectorAll('.tab-btn');

    // Add click event listeners for each tab
    tabs.forEach(function (tab) {
        tab.addEventListener('click', function (event) {
            event.preventDefault();
            
            // Remove active class from all tabs
            tabs.forEach(tab => tab.classList.remove('active'));

            // Add active class to clicked tab
            this.classList.add('active');

            // Get tab name and show corresponding content
            const tabName = this.getAttribute('data-tab');
            showTab(tabName);
            
            // If packages tab, load membership data
            if (tabName === 'packages') {
                loadMembershipBlock();
            }
        });
    });

    // Check URL for tab parameter
    const urlParams = new URLSearchParams(window.location.search);
    const tabParam = urlParams.get('tab');
    if (tabParam) {
        showTab(tabParam);
        
        // Update active tab
        const activeTab = document.querySelector(`.tab-btn[data-tab="${tabParam}"]`);
        if (activeTab) {
            tabs.forEach(tab => tab.classList.remove('active'));
            activeTab.classList.add('active');
        }
    }
});

// Function to load membership data
function loadMembershipBlock() {
    fetch('MembershipServlet')
            .then(response => response.text())
            .then(html => {
                document.getElementById('membership-block').innerHTML = html;
        })
        .catch(error => {
            console.error('Error loading membership data:', error);
        });
}

// Function to show selected tab content
function showTab(tabName) {
    // Hide all tab contents
    document.querySelectorAll('.tab-content').forEach(function (tabContent) {
        tabContent.style.display = 'none';
    });

    // Show selected tab content
    const targetTab = document.getElementById(tabName);
    if (targetTab) {
        targetTab.style.display = 'block';
    }
    
    // Update URL without refreshing the page
    const url = new URL(window.location.href);
    url.searchParams.set('tab', tabName);
    window.history.replaceState({}, '', url);
}
