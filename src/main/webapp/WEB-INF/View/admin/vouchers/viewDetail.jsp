<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!-- Voucher Detail Modal -->
<div class="modal" id="viewVoucherModal">
    <div class="modal-content" style="max-width: 700px;">
        <div class="modal-header">
            <h3>Voucher Details</h3>
            <span class="close" onclick="closeModal('viewVoucherModal')">&times;</span>
        </div>
        <div class="modal-body">
            <div id="voucherDetailContent" style="margin-bottom: 20px;">
                <!-- Content will be loaded dynamically -->
                <div class="detail-section">
                    <!--<h4>Voucher Information</h4>-->
                    <table class="detail-table">
<!--                        <tr>
                            <td class="detail-label">Voucher ID:</td>
                            <td id="detail-voucher-id"></td>
                        </tr>
                        <tr>
                            <td class="detail-label">Code:</td>
                            <td id="detail-voucher-code"></td>
                        </tr>
                        <tr>
                            <td class="detail-label">Description:</td>
                            <td id="detail-voucher-description"></td>
                        </tr>-->
                        <tr>
                            <td class="detail-label">Discount Percent:</td>
                            <td id="detail-voucher-discount"></td>
                        </tr>
                        <tr>
                            <td class="detail-label">Max Discount Amount:</td>
                            <td id="detail-voucher-max-discount"></td>
                        </tr>
                        <tr>
                            <td class="detail-label">Usage Limit:</td>
                            <td id="detail-voucher-usage-limit"></td>
                        </tr>
                        <tr>
                            <td class="detail-label">Used Count:</td>
                            <td id="detail-voucher-used-count"></td>
                        </tr>
                        <tr>
                            <td class="detail-label">Minimum Order Amount:</td>
                            <td id="detail-voucher-min-amount"></td>
                        </tr>
                        <tr>
                            <td class="detail-label">Start Date:</td>
                            <td id="detail-voucher-start-date"></td>
                        </tr>
                        <tr>
                            <td class="detail-label">End Date:</td>
                            <td id="detail-voucher-end-date"></td>
                        </tr>
<!--                        <tr>
                            <td class="detail-label">Status:</td>
                            <td id="detail-voucher-status"></td>
                        </tr>-->
                    </table>
                </div>
            </div>
            <!-- Removed the modal-footer div with the Edit and Delete buttons -->
        </div>
    </div>
</div>

<style>
/*    .detail-section {
        margin-bottom: 20px;
        border: 1px solid #ddd;
        border-radius: 5px;
        padding: 15px;
    }*/
    
    .detail-section h4 {
        margin-top: 0;
        margin-bottom: 15px;
        border-bottom: 1px solid #eee;
        padding-bottom: 10px;
        color: #333;
    }
    
    .detail-table {
        width: 100%;
        border-collapse: collapse;
    }
    
    .detail-table td {
        padding: 8px 5px;
        border-bottom: 1px solid #f0f0f0;
    }
    
    .detail-label {
        font-weight: bold;
        width: 40%;
        color: #555;
    }
</style> 