<div class="container-profile" id="profileContent">
    <div>
        <h1 class="header-content">Profile</h1>
        <form class="form-profile" action="${pageContext.request.contextPath}/profile?action=update" method="post">
            <label for="full-name">Full Name:</label>
            <input type="hidden" name="cusId" value="${customer.customerId}">
            <input type="text" id="full-name" name="name" value="${customer.fullName}" placeholder="Enter your full name">

            <label for="phone">Phone:</label>
            <input type="text" id="phone" name="phone" value="${customer.phone}" placeholder="Enter your phone number">

            <label for="address">Address:</label>
            <input type="text" id="address" name="address" value="${customer.address}" placeholder="Enter your address">

            <label for="email">Email:</label>
            <input type="email" id="email" name="email" value="${customer.email}" placeholder="Enter your email" readonly>

            <button type="submit" class="change-btn">Update Profile</button>
        </form>  
    </div>
</div>

