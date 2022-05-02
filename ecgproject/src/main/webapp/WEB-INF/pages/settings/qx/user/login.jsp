<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>

<head>
    <base href = "<%=basePath%>">
    <meta http-equiv="content-type" content="text/html; charset=utf-8">

    <link rel="stylesheet" href="static/login.css">
    <script type="text/javascript" src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <script type="text/javascript">
        $(function () {
            //给整个浏览器窗口添加键盘按下事件
            $(window).keydown(function (event) {
               //js 回车 登陆
               if(event.keyCode==13){
                   //收集参数
                   var loginAct=$.trim($("#loginAct").val());
                   var loginPwd=$.trim($("#loginPwd").val());

                   //表单验证
                   if(loginAct==""){
                       alert("用户名不能为空");
                       return;
                   }
                   if(loginPwd==""){
                       alert("密码不能为空");
                       return;
                   }

                   //发送请求
                   $.ajax({
                       url:'settings/qx/user/login.do',
                       data:{
                           loginAct:loginAct,
                           loginPwd:loginPwd
                       },
                       type:'post',
                       dataType:'json',
                       success:function (data){
                           if(data.code=="1"){
                               //登陆成功，跳转到业务主页面
                               window.location.href="workbench/index.do";
                           }else{
                               //提示信息
                               $("#msg").text(data.message);
                           }
                       },
                       beforeSend:function () {
                           //true执行ajax，false不执行
                           //显示正在验证
                           $("#msg").text("正在验证中……");
                           return true;
                       }
                   });
               }
            });

            //给登陆按钮添加单击事件
            $("#loginBtn").click(function () {
                //收集参数
                var loginAct=$.trim($("#loginAct").val());
                var loginPwd=$.trim($("#loginPwd").val());

                //表单验证
                if(loginAct==""){
                    alert("用户名不能为空");
                    return;
                }
                if(loginPwd==""){
                    alert("密码不能为空");
                    return;
                }

                //发送请求
                $.ajax({
                    url:'settings/qx/user/login.do',
                    data:{
                        loginAct:loginAct,
                        loginPwd:loginPwd
                    },
                    type:'post',
                    dataType:'json',
                    success:function (data){
                        if(data.code=="1"){
                            //登陆成功，跳转到业务主页面
                            var role = data.role;
                            if(role=="0"){
                                window.location.href="workbench/index.do";
                            }else{
                                $("#msg").text("跳到管理员界面");
                            }

                        }else{
                            //提示信息
                            $("#msg").text(data.message);
                        }
                    },
                    beforeSend:function () {
                        //true执行ajax，false不执行
                        //显示正在验证
                        $("#msg").text("正在验证中……");
                        return true;
                    }
                });
            });
        });
    </script>
    <!-- 不知道为什么这里用../../的方式引用不了 -->
</head>

<body>
<div class="container">
    <div class="logo">
        <img class="icon" src="image/logo.png" />
    </div>

    <div class="title">心电综合系统</div>

    <div class="inputs">
        <form action="action=workbench/index.jsp" class="form-horizontal" role="form">
            <div class="form-group form-group-lg">
                <div>
                    <label>USERNAME</label>
                    <input class="form-control" type="text" id="loginAct" placeholder="201826010527" />
                </div>
                <div>
                    <label>PASSWORD</label>
                    <input class="form-control" type="password" id="loginPwd" placeholder="Enter password" />
                </div>
                <div>
                    <span id="msg"></span>
                </div>
                <button type="button" id="loginBtn" class="btn btn-primary btn-lg btn-block">LOGIN</button>
            </div>

        </form>
    </div>

    <div class="line">
        <a href="settings/qx/user/toForget.do">Forgot password?</a>
        <span id="dot">.</span>
        <a href="settings/qx/user/toRegister.do">Sign Up for System</a>
    </div>
</div>
<!--
<div class="container">
    <div class="form-box">

        <div class="register-box hidden">
            <h1>register</h1>
            <input type="text" placeholder="工号">
            <input type="password" placeholder="密码">
            <input type="password" placeholder="确认密码">
            <button>注册</button>
        </div>

        <div class="login-box">
            <h1>login</h1>
            <input type="text" placeholder="工号">
            <input type="password" placeholder="密码">
            <button>登录</button>
        </div>
    </div>
    <div class="con-box left">
        <h2>欢迎使用</h2>
        <span>心电数据管理系统</span>
        <img src="image/logo.png" alt="">
        <p>已有账号</p>
        <button id="login">去登录</button>
    </div>
    <div class="con-box right">
        <h2>欢迎使用</h2>
        <span>心电数据管理系统</span>
        <img src="image/logo.png" alt="">
        <p>没有账号？</p>
        <button id="register">去注册</button>
    </div>

</div>
-->
<!--
<script>
    // 要操作到的元素
    let login=document.getElementById('login');
    let register=document.getElementById('register');
    let form_box=document.getElementsByClassName('form-box')[0];
    let register_box=document.getElementsByClassName('register-box')[0];
    let login_box=document.getElementsByClassName('login-box')[0];
    // 去注册按钮点击事件
    register.addEventListener('click',()=>{
        form_box.style.transform='translateX(80%)';
        login_box.classList.add('hidden');
        register_box.classList.remove('hidden');
    })
    // 去登录按钮点击事件
    login.addEventListener('click',()=>{
        form_box.style.transform='translateX(0%)';
        register_box.classList.add('hidden');
        login_box.classList.remove('hidden');
    })
</script>
-->
</body>

</html>