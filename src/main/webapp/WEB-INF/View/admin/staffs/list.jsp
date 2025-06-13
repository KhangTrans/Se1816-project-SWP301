<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Model.Staff"%>
<%@page import="DAO.UserDao"%>

<%
    UserDao d = new UserDao();
    List<Staff> staffList = d.getAllStaffs();
%>

<%@include file="/WEB-INF/View/admin/staffs/create.jsp" %>
<%@include file="/WEB-INF/View/admin/staffs/edit.jsp" %>
<%@include file="/WEB-INF/View/admin/staffs/delete.jsp" %>

<div class="table-container" id="staffsTable">
    <div class="table-container__header">
        <h2 class="table-container__title">Staff List</h2>
        <p class="table-container__description">Manage staff information</p>
    </div>
    <div class="table-container__content" style="overflow-x: auto;">
        <button class="add-button" onclick="openModal('addStaffModal')">+ Add Staff</button>
        <table class="data-table">
            <thead>
                <tr>
                    <th>No</th>
                    <th>Avatar</th>
                    <th>Username</th>
                    <th>Full Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Position</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    int indexx = 1;
                    for (Staff s : staffList) {
                        String username = (s.getAccount() != null) ? s.getAccount().getUsername() : "N/A";
                %>
                <tr>
                    <td><%= indexx++ %></td>
                    <td>
                        <img src="${pageContext.request.contextPath}/AvatarServlet?user=<%= username %>" alt="Avatar" style="width:40px;height:40px;border-radius:50%; margin-top: 5px">
                    </td>
                    <td><%= username %></td>
                    <td><%= s.getFullName() %></td>
                    <td><%= s.getEmail() %></td>
                    <td><%= s.getPhone() %></td>
                    <td><%= s.getPosition() %></td>
                    <td><%= s.getStatus() %></td>
                    <td>
                        <button class="action-buttons__btn action-buttons__btn--edit" 
                                onclick="openEditStaffModal(
                                                '<%= s.getStaffId()%>',
                                                '<%= username %>',
                                                '<%= s.getFullName()%>',
                                                '<%= s.getEmail()%>',
                                                '<%= s.getPhone()%>',
                                                '<%= s.getPosition()%>',
                                                '<%= s.getStatus()%>',
                                                '<%= request.getContextPath()%>/AvatarServlet?user=<%= username %>'
                                                )">
                            Edit
                        </button>
                        <button class="action-buttons__btn action-buttons__btn--delete"
                                onclick="openDeleteStaffModal('<%= s.getStaffId()%>')">
                            Delete
                        </button>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
</div>
