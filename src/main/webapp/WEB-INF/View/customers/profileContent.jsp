<div class="container-profile" id="profileContent">
    <div>
        <h1 class="header-profile">Profile</h1>
        <form class="form-profile" action="${pageContext.request.contextPath}/profile?action=update" method="post">
            <label for="full-name">Full Name:</label>
            <input type="hidden" name="cusId" value="${customer.customerId}">
            <input type="text" id="full-name" name="name" value="${customer.fullName}">

            <label for="phone">Phone:</label>
            <input type="text" id="phone" name="phone" value="${customer.phone}">

            <label for="address">Address:</label>
            <input type="text" id="address" name="address" value="${customer.address}">

            <label for="email">Email:</label>
            <input type="email" id="email" name="email" value="${customer.email}">

            <button type="submit" class="change-btn">Change</button>
        </form>  
    </div>


</div>

