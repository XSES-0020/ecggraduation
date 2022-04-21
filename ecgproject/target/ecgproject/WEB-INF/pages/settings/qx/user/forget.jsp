<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>

<head>
    <base href = "<%=basePath%>">
    <meta charset="UTF-8">
    <link rel="stylesheet" href="static/forget.css">
</head>
<body>
    <div align="center">
        若忘记密码，请联系管理员重置密码，联系电话：13127246840
    </div>
</body>
</html>