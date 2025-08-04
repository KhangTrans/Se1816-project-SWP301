<!-- View Product Modal -->
<div class="modal" id="viewProductModal">
    <div class="modal-content">
        <h2>Product Details</h2>
        <div class="product-detail">
            <div id="viewProductImageList" style="text-align: center; margin-bottom: 20px;"></div>

            <table class="detail-table">
                <tbody>
                    <tr>
                        <td><strong>Name:</strong></td>
                        <td><span id="viewProductName"></span></td>
                    </tr>
                    <tr>
                        <td><strong>Price:</strong></td>
                        <td><span id="viewProductPrice"></span></td>
                    </tr>
                    <tr>
                        <td><strong>Category:</strong></td>
                        <td><span id="viewProductCategory"></span></td>
                    </tr>
                    <tr>
                        <td><strong>Stock Quantity:</strong></td>
                        <td><span id="viewProductStock"></span></td>
                    </tr>
                    <tr>
                        <td><strong>Description:</strong></td>
                        <td><span id="viewProductDescription" style="white-space: pre-wrap;"></span></td>
                    </tr>
                </tbody>
            </table>
        </div>
        <button class="btn" onclick="closeModal('viewProductModal')">Close</button>
    </div>
</div>

<style>
    .detail-table {
        width: 100%;
        border-collapse: collapse;
        margin: 20px 0;
    }
    
    .detail-table td {
        border: 1px solid #ddd;
        padding: 8px;
        text-align: left;
    }
    
    .detail-table td:first-child {
        font-weight: bold;
        width: 30%;
        background-color: #f8f9fa;
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
    
    #viewProductModal .modal-content {
        background-color: #fefefe;
        margin: 5% auto;
        padding: 20px;
        border: 1px solid #888;
        width: 70%;
        max-width: 600px;
        border-radius: 8px;
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    }
</style>
