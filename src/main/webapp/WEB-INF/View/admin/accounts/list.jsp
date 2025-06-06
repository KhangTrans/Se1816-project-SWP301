
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Model.Account"%>
<%@page import="DAO.UserDao"%>
<%
    UserDao dao = new UserDao();
    List<Account> accounts = dao.getAllAccounts();
%>
<%@include file="/WEB-INF/View/admin/accounts/create.jsp" %>
<%@include file="/WEB-INF/View/admin/accounts/edit.jsp" %>
<%@include file="/WEB-INF/View/admin/accounts/delete.jsp" %>
<div class="table-container"  id="accountTable"">
    <div class="table-container__header">
        <h2 class="table-container__title">Account List</h2>
        <p class="table-container__description">Manage user accounts</p>
    </div>
    <div class="table-container__content">
        <button class="add-button" onclick="openModal('addAccountModal')">+ Add Account</button>
        <table class="data-table">
            <thead>
                <tr>
                    <th>No</th>
                    <th>Avatar</th>
                    <th>Username</th>
                    <th>Role</th>
                    <th>Created At</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    int index = 1;
                    for (Account acc : accounts) {
                %>
                <tr>
                    <td><%= index++%></td>
                    <td>
                        <img src="${pageContext.request.contextPath}/AvatarServlet?user=<%= acc.getUsername() %>" alt="Avatar" style="width:40px;height:40px;border-radius:50%;">
                    </td>
                    <td><%= acc.getUsername()%></td>
                    <td><%= acc.getRole()%></td>
                    <td><%= acc.getCreatedAt()%></td>
                    <td>
                        <button class="action-buttons__btn action-buttons__btn--edit" 
                                onclick="openEditAccountModal(
                                                '<%= acc.getAccountId()%>',
                                                '<%= acc.getUsername()%>',
                                                '<%= acc.getRole()%>',
                                                '<%= request.getContextPath()%>/AvatarServlet?user=<%= acc.getUsername()%>'
                                                                )">
                            Edit
                        </button>


                        <button class="action-buttons__btn action-buttons__btn--delete" 
                                onclick="openDeleteAccountModal('<%= acc.getAccountId()%>')">Delete</button>
                    </td>

                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
</div>
