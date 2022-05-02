<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2022/4/4
  Time: 22:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>

<head>
    <base href = "<%=basePath%>">
    <meta http-equiv="content-type" content="text/html; charset=utf-8">

    <link rel="stylesheet" href="static/register.css">
    <script type="text/javascript" src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <script type="text/javascript">
        $(function () {
            //按回车
            $(window).keydown(function (event) {
               if(event.keyCode==13){
                   //收集参数
                   var registerAct = $.trim($("#registerAct").val());
                   var registerPwd = $.trim($("#registerPwd").val());
                   var confirmPwd = $.trim($("#confirmPwd").val());

                   //表单验证
                   if(registerAct==""){
                       alert("用户名不能为空");
                       return;
                   }
                   if(registerPwd==""){
                       alert("密码不能为空");
                       return;
                   }
                   if(confirmPwd==""){
                       alert("确认密码不能为空");
                       return;
                   }
                   if(registerPwd!=confirmPwd){
                       alert("两次密码输入不一致");
                       return;
                   }

                   $.ajax({
                       url:"settings/qx/user/register.do",
                       data:{
                           userId:registerAct,
                           userPassword:registerPwd
                       },
                       type:'post',
                       dataType:'json',
                       success:function (data) {
                           if(data.code=="1"){
                               $("#msg").hide();
                               //登陆成功，跳转到业务主页面
                               if(window.confirm("创建成功，是否跳转至登录界面？")){
                                   window.location.href="settings/qx/user/logout.do";
                               }else{
                                   $("#registerForm").get(0).reset();
                               }
                           }else{
                               //提示信息
                               $("#msg").text(data.message);
                           }
                       },
                       beforeSend:function () {
                           //true执行ajax，false不执行
                           //显示正在验证
                           $("#msg").text("正在注册中……");
                           return true;
                       }
                   });
               }
            });

            //注册按钮
            $("#registerBtn").click(function () {
                //收集参数
                var registerAct = $.trim($("#registerAct").val());
                var registerPwd = $.trim($("#registerPwd").val());
                var confirmPwd = $.trim($("#confirmPwd").val());

                //表单验证
                if(registerAct==""){
                    alert("用户名不能为空");
                    return;
                }
                if(registerPwd==""){
                    alert("密码不能为空");
                    return;
                }
                if(confirmPwd==""){
                    alert("确认密码不能为空");
                    return;
                }
                if(registerPwd!=confirmPwd){
                    alert("两次密码输入不一致");
                    return;
                }

                $.ajax({
                    url:"settings/qx/user/register.do",
                    data:{
                        userId:registerAct,
                        userPassword:registerPwd
                    },
                    type:'post',
                    dataType:'json',
                    success:function (data) {
                        if(data.code=="1"){
                            $.ajax({
                                url:'settings/qx/user/login.do',
                                data:{
                                    loginAct:registerAct,
                                    loginPwd:registerPwd
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
                                            window.location.href="workbench/indexAdmin.do";
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
                        }else{
                            //提示信息
                            $("#msg").text(data.message);
                        }
                    },
                    beforeSend:function () {
                        //true执行ajax，false不执行
                        //显示正在验证
                        $("#msg").text("正在注册中……");
                        return true;
                    }
                });
            });
        });
    </script>
</head>

<body>
<div class="container">
    <div class="logo">
        <img class="icon" src="image/logo.png" />
    </div>

    <div class="title">心电综合系统|注册</div>

    <div class="inputs">
        <form action="action=workbench/index.jsp" class="form-horizontal" role="form" id="registerForm">
            <div class="form-group form-group-lg">
                <div>
                    <label>USERNAME</label>
                    <input class="form-control" type="text" id="registerAct" placeholder="201826010527" />
                </div>
                <div>
                    <label>PASSWORD</label>
                    <input class="form-control" type="password" id="registerPwd" placeholder="Enter password" />
                </div>
                <div>
                    <label>确认密码</label>
                    <input class="form-control" type="password" id="confirmPwd" placeholder="Enter password" />
                </div>
                <div>
                    <span id="msg"></span>
                </div>
                <button type="button" id="registerBtn" class="btn btn-primary btn-lg btn-block">REGISTER</button>
            </div>

        </form>
    </div>

    <div class="line">
        <a href="#">Forgot password?</a>
        <span id="dot">.</span>
        <a href="settings/qx/user/toLogin.do">Sign in for System</a>
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
