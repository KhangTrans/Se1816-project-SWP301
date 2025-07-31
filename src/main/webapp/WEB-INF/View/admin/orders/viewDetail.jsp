<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div id="orderDetailModal" class="modal">
    <div class="modal-content">
        <h2>Order Detail</h2>
        <div class="order-detail">
            <p><strong>Referral Code:</strong> <span id="detailReferralCode"></span></p>
            <hr>
            <h3>Products</h3>
            <table class="detail-table">
                <thead>
                    <tr>
                        <th>Product Name</th>
                        <th>Quantity</th>
                        <th>Price</th>
                    </tr>
                </thead>
                <tbody id="orderDetailProducts">
                    <!-- Product items will be loaded here -->
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="2" style="text-align: right;"><strong>Total:</strong></td>
                        <td><strong><span id="orderDetailTotal"></span></strong></td>
                    </tr>
                </tfoot>
            </table>
        </div>
        <button class="btn" onclick="closeOrderDetailModal()">Close</button>
    </div>
</div>

<style>
    .detail-table {
        width: 100%;
        border-collapse: collapse;
        margin: 20px 0;
    }
    
    .detail-table th, .detail-table td {
        border: 1px solid #ddd;
        padding: 8px;
        text-align: left;
    }
    
    .detail-table th {
        background-color: #f2f2f2;
        font-weight: bold;
    }
    
    .detail-table tfoot {
        font-weight: bold;
    }
    
    .btn {
        background-color: #4CAF50;
        color: white;
        padding: 10px 15px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        float: right;
        margin-top: 15px;
    }
    
    .btn:hover {
        background-color: #45a049;
    }
</style>

<script>
function closeOrderDetailModal() {
    document.getElementById('orderDetailModal').style.display = 'none';
}
</script> 