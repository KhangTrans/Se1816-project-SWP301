<%@page contentType="text/html" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/payment-modal.css">

<div id="paymentModal" class="modal-container" style="display: none;">
    <div class="payment-modal">
        <div class="modal-header">
            <h2>Payment method</h2>
        </div>
        <div class="modal-body">
            <div class="payment-info">
                <div id="customerName"></div>
                <div id="packageName" style="font-weight: bold; margin-top: 10px;"></div>
                <div id="paymentAmount" class="amount"></div>
            </div>
            
            <div class="payment-method-section">
                <h3>Select payment method</h3>
                <div class="payment-method-options">
                    <div class="payment-option selected" onclick="selectPaymentMethod(this, 'offline')">
                        <input type="radio" id="directPayment" name="modalPaymentMethod" value="offline" checked>
                        <label for="directPayment" class="payment-option-label">
                            <i class="fas fa-money-bill-wave payment-icon"></i>
                            <span>Pay in person (Direct payment)</span>
                        </label>
                    </div>
                    <div class="payment-option disabled" onclick="selectPaymentMethod(this, 'online')">
                        <input type="radio" id="onlinePayment" name="modalPaymentMethod" value="online" disabled>
                        <label for="onlinePayment" class="payment-option-label">
                            <i class="fas fa-credit-card payment-icon"></i>
                            <span>Online payment (unsupported)</span>
                        </label>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <button class="btn-cancel" onclick="closePaymentModal()">Cancel</button>
            <button class="btn-confirm" onclick="confirmPayment()">Confirm</button>
        </div>
    </div>
</div>

<script>
    let paymentPackageId = null;
    let paymentAmount = 0;
    let selectedPaymentMethod = 'offline';
    let isRenewal = false;
    
    // Open payment modal with package details
    function openPaymentModal(packageId, packageName, amount, username, isRenew = false) {
        paymentPackageId = packageId;
        paymentAmount = amount;
        isRenewal = isRenew;
        
        // Set modal content
        document.getElementById('customerName').innerHTML = 'Hello, ' + username + '!';
        document.getElementById('packageName').innerHTML = packageName;
        document.getElementById('paymentAmount').innerHTML = amount.toLocaleString() + ' VND';
        
        // Show modal
        document.getElementById('paymentModal').style.display = 'flex';
        
        // Force scrolling to the top to ensure modal is visible
        window.scrollTo(0, 0);
        
        // Disable scrolling on body when modal is open
        document.body.style.overflow = 'hidden';
    }
    
    // Close payment modal
    function closePaymentModal() {
        document.getElementById('paymentModal').style.display = 'none';
        
        // Re-enable scrolling on body
        document.body.style.overflow = 'auto';
    }
    
    // Select payment method
    function selectPaymentMethod(element, method) {
        if (element.classList.contains('disabled')) {
            return;
        }
        
        // Remove selected class from all options
        const options = document.querySelectorAll('.payment-option');
        options.forEach(option => {
            option.classList.remove('selected');
        });
        
        // Add selected class to clicked option
        element.classList.add('selected');
        
        // Set selected radio button
        element.querySelector('input[type="radio"]').checked = true;
        
        // Update selected payment method
        selectedPaymentMethod = method;
    }
    
    // Confirm payment
    function confirmPayment() {
        // Create form and submit
        const form = document.createElement('form');
        form.method = 'post';
        form.action = 'payment';
        
        // Add package ID
        const cardIdInput = document.createElement('input');
        cardIdInput.type = 'hidden';
        cardIdInput.name = 'cardId';
        cardIdInput.value = paymentPackageId;
        form.appendChild(cardIdInput);
        
        // Add payment method
        const paymentMethodInput = document.createElement('input');
        paymentMethodInput.type = 'hidden';
        paymentMethodInput.name = 'paymentMethod';
        paymentMethodInput.value = selectedPaymentMethod;
        form.appendChild(paymentMethodInput);
        
        // Add renewal flag if needed
        if (isRenewal) {
            const renewInput = document.createElement('input');
            renewInput.type = 'hidden';
            renewInput.name = 'renew';
            renewInput.value = '1';
            form.appendChild(renewInput);
        }
        
        // Add form to body and submit
        document.body.appendChild(form);
        form.submit();
    }

    // Add event listener for escape key to close modal
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            closePaymentModal();
        }
    });
    
    // Close modal when clicking outside
    document.addEventListener('click', function(event) {
        const modal = document.getElementById('paymentModal');
        if (event.target === modal) {
            closePaymentModal();
        }
    });
</script> 