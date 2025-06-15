<%@ page import="java.util.List" %>
<%@ page import="Model.Account" %>

<%
    List<Account> accountList = (List<Account>) request.getAttribute("availableAccounts");
%>

<div class="modal" id="addCustomerModal" style="display: none;">
    <div class="modal-content">
        <h2>Create New Member</h2>
        <form method="post"
              action="${pageContext.request.contextPath}/admin/customers"
              onsubmit="return submitFormAjax(this, 'resultAddCustomer')">

            <input type="hidden" name="action" value="create">

            <label>Choose Username (with role = customer):</label>
            <select name="accountId" required>
                <option value="">-- Select Account --</option>
                <% for (Account acc : accountList) {%>
                <option value="<%= acc.getAccountId()%>"><%= acc.getUsername()%></option>
                <% }%>
            </select>
            <br><br>

            <label>Full Name:</label>
            <input type="text" name="fullName" required><br><br>

            <label>Email:</label>
            <input type="email" name="email" required><br><br>

            <label>Phone:</label>
            <input type="text" name="phone" required><br><br>

            <label>Customer Code:</label>
            <input type="text" name="customerCode" required><br><br>

            <label>Address:</label>
            <input type="text" name="address"><br><br>

            <button type="submit">Create</button>
            <button type="button" onclick="closeModal('addCustomerModal')">Cancel</button>
        </form>
        <div id="resultAddCustomer" style="margin-top:10px;"></div>
    </div>
</div>
