<%
    String username = (String) session.getAttribute("admin_username");
    if (username == null) {
        response.sendRedirect("Login.jsp");
    }
%>
