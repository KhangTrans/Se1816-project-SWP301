<%@page import="java.util.List"%>
<%@page import="Model.Account"%>
<%@page import="DAO.UserDao"%>
<%
    UserDao dao = new UserDao();
    List<Account> accounts = dao.getAllAccounts();
%>

<div class="table-container">
    <div class="table-container__header">
        <h2 class="table-container__title">Account List</h2>
        <p class="table-container__description">Manage user accounts</p>
    </div>
    <div class="table-container__content">
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
                    for(Account acc : accounts) {
                %>
                    <tr>
                        <td><%= index++ %></td>
                        <td>
                            <img src="<%=request.getContextPath()%>/AvatarServlet?user=<%= acc.getUsername() %>" alt="Avatar" style="width:40px;height:40px;border-radius:50%;">
                        </td>
                        <td><%= acc.getUsername() %></td>
                        <td><%= acc.getRole() %></td>
                        <td><%= acc.getCreatedAt() %></td>
                        <td>
                            <a href="edit.jsp?id=<%= acc.getAccountId() %>">Edit</a> |
                            <a href="delete.jsp?id=<%= acc.getAccountId() %>">Delete</a>
                        </td>
                    </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
</div>
