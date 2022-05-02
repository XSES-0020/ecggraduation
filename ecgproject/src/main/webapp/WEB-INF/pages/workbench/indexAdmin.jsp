<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2022/5/2
  Time: 10:52
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>

<head>
    <base href = "<%=basePath%>">
    <meta charset="UTF-8">
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript">

        //页面加载完毕
        $(function(){

            //导航中所有文本颜色为黑色
            $(".liClass > a").css("color" , "black");

            //默认选中导航菜单中的第一个菜单项
            $(".liClass:first").addClass("active");

            //第一个菜单项的文字变成白色
            $(".liClass:first > a").css("color" , "white");

            //给所有的菜单项注册鼠标单击事件
            $(".liClass").click(function(){
                //移除所有菜单项的激活状态
                $(".liClass").removeClass("active");
                //导航中所有文本颜色为黑色
                $(".liClass > a").css("color" , "black");
                //当前项目被选中
                $(this).addClass("active");
                //当前项目颜色变成白色
                $(this).children("a").css("color","white");
            });


            window.open("workbench/main/index.do","workareaFrame");

            //给确定退出系统按钮添加单击事件
            $("#logoutBtn").click(function () {
                //发送同步请求
                window.location.href="settings/qx/user/logout.do";
            });

            //给确定更改密码按钮添加单击事件
            $("#saveEditPwdBtn").click(function () {
                var oldPwd = $.trim($("#oldPwd").val());
                var newPwd = $.trim($("#newPwd").val());
                var confirmPwd = $.trim($("#confirmPwd").val());
                var userId = ${sessionScope.sessionUser.userId};

                if(oldPwd!=${sessionScope.sessionUser.userPassword}){
                    alert("原密码错误");
                    return;
                }
                if(newPwd!=confirmPwd){
                    alert("两次输入密码不一致");
                    return;
                }

                $.ajax({
                    url:'settings/qx/user/updatePwd.do',
                    data:{
                        userId:userId,
                        userPassword:newPwd
                    },
                    type:'post',
                    dataType:'json',
                    success:function (data) {
                        if(data.code=="1"){
                            //关闭模态窗口
                            $("#editPwdModal").modal("hide");
                            //跳回登录页面
                            window.location.href="settings/qx/user/logout.do";
                        }else{
                            //提示信息
                            alert(data.message);
                            //模态窗口不关
                            $("#editPwdModal").modal("show");
                        }
                    }
                });
            });


            $("#editUserBtn").click(function () {
                //收集参数
                var userId = $.trim($("#edit-userId").val());
                var userPhone = $.trim($("#edit-userPhone").val());
                var userDescribe = $.trim($("#edit-userDescribe").val());

                //发送请求
                $.ajax({
                    url:'settings/qx/user/editUser.do',
                    data:{
                        userId:userId,
                        userPhone:userPhone,
                        userDescribe:userDescribe
                    },
                    type:'post',
                    dataType:'json',
                    success:function (data) {
                        if(data.code=="1"){
                            //关闭模态窗口
                            $("#myInformationModal").modal("hide");
                        }else{
                            //提示信息
                            alert(data.message);
                            //模态窗口不关
                            $("#myInformationModal").modal("show");
                        }
                    }
                });
            });

            //修改资料
            $("#editUser").click(function () {
                var userId = ${sessionScope.sessionUser.userId};
                $.ajax({
                    url:'workbench/user/queryUserById.do',
                    data:{
                        userId:userId
                    },
                    type:'post',
                    dataType:'json',
                    success:function (data) {
                        $("#edit-userId").val(data.userId);
                        $("#edit-userName").val(data.userName);
                        $("#edit-userCreatetime").val(data.userCreatetime);
                        if(data.userType=="0"){
                            $("#edit-userType").val("普通用户");
                        }else{
                            $("#edit-userType").val("管理员");
                        }
                        $("#edit-userPhone").val(data.userPhone);
                        $("#edit-userDescribe").val(data.userDescribe);

                        $("#myInformationModal").modal("show");
                    }
                });
            });
        });

    </script>

</head>
<body>

<!-- 我的资料 -->
<div class="modal fade" id="myInformationModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">我的资料</h4>
            </div>
            <div class="modal-body">

                <form id="editUserForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-userId" class="col-sm-2 control-label">账号<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-userId" readonly>
                        </div>

                        <label for="edit-userType" class="col-sm-2 control-label">角色<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-userType" readonly>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-userName" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-userName" readonly>
                        </div>

                        <label for="edit-userCreatetime" class="col-sm-2 control-label">创建时间<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-userCreatetime" readonly>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-userPhone" class="col-sm-2 control-label">电话</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-userPhone">
                        </div>

                        <label for="edit-userDescribe" class="col-sm-2 control-label">备注</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-userDescribe">
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="editUserBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改密码的模态窗口 -->
<div class="modal fade" id="editPwdModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 70%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">修改密码</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <div class="form-group">
                        <label for="oldPwd" class="col-sm-2 control-label">原密码</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="oldPwd" style="width: 200%;">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="newPwd" class="col-sm-2 control-label">新密码</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="newPwd" style="width: 200%;">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="confirmPwd" class="col-sm-2 control-label">确认密码</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="confirmPwd" style="width: 200%;">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" id="saveEditPwdBtn">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 退出系统的模态窗口 -->
<div class="modal fade" id="exitModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">离开</h4>
            </div>
            <div class="modal-body">
                <p>您确定要退出系统吗？</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" id="logoutBtn" class="btn btn-primary" data-dismiss="modal" onclick="window.location.href='login.html';">确定</button>
            </div>
        </div>
    </div>
</div>

<!-- 顶部 -->
<div id="top" style="height: 50px; background-color: #015684; width: 100%;">
    <div style="position: absolute; top: 5px; left: 20px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">心电综合系统（管理员端） &nbsp;<span style="font-size: 12px;">2022&nbsp;QIYIN</span></div>
    <div style="position: absolute; top: 15px; right: 40px;">
        <ul>
            <li class="dropdown user-dropdown">
                <a href="javascript:void(0)" style="text-decoration: none; color: white;" class="dropdown-toggle" data-toggle="dropdown">
                    <span class="glyphicon glyphicon-user"></span> ${sessionScope.sessionUser.userName} <span class="caret"></span>
                </a>
                <ul class="dropdown-menu" style="left: -60px;width: 100px;">
                    <li><a href="javascript:void(0)" data-toggle="modal" data-target="#editPwdModal"><span class="glyphicon glyphicon-edit"></span> 修改密码</a></li>
                    <li><a href="javascript:void(0)"><p id="editUser" style="height: 8px"><span class="glyphicon glyphicon-refresh"></span> 编辑资料</p></a></li>
                    <li><a href="javascript:void(0);" data-toggle="modal" data-target="#exitModal"><span class="glyphicon glyphicon-off"></span> 退出</a></li>
                </ul>
            </li>
        </ul>
    </div>
</div>

<!-- 中间 -->
<div id="center" style="position: absolute;top: 50px; bottom: 30px; left: 0px; right: 0px;">

    <!-- 导航 -->
    <div id="navigation" style="left: 0px; width: 13%; position: relative; height: 100%; overflow:auto;">

        <ul id="no1" class="nav nav-pills nav-stacked">

            <li class="liClass"><a href="workbench/main/index.do" target="workareaFrame"><span class="glyphicon glyphicon-home"></span> 使用手册</a></li>
            <li class="liClass"><a href="workbench/staff/staffAdmin.do" target="workareaFrame"><span class="glyphicon glyphicon-play-circle"></span> 员工管理</a></li>
            <li class="liClass"><a href="workbench/user/userAdmin.do" target="workareaFrame"><span class="glyphicon glyphicon-play-circle"></span> 用户管理</a></li>
            <li class="liClass"><a href="workbench/doctor/doctorAdmin.do" target="workareaFrame"><span class="glyphicon glyphicon-play-circle"></span> 医生管理</a></li>
            <li class="liClass"><a href="workbench/department/departmentAdmin.do" target="workareaFrame"><span class="glyphicon glyphicon-play-circle"></span> 科室管理</a></li>
            <li class="liClass"><a href="workbench/patient/index.do" target="workareaFrame"><span class="glyphicon glyphicon-play-circle"></span> 患者管理</a></li>
            <li class="liClass"><a href="workbench/ecg/index.do" target="workareaFrame"><span class="glyphicon glyphicon-play-circle"></span> ecg文件管理</a></li>
            <li class="liClass"><a href="workbench/appointment/index.do" target="workareaFrame"><span class="glyphicon glyphicon-play-circle"></span> 预约管理</a></li>
            <li class="liClass"><a href="workbench/chart/machine/index.do" target="workareaFrame"><span class="glyphicon glyphicon-indent-left"></span> 可视化统计</a></li>

        <%--<li class="liClass">
                <a href="#no2" class="collapsed" data-toggle="collapse"><span class="glyphicon glyphicon-stats"></span> 统计图表</a>
                <ul id="no2" class="nav nav-pills nav-stacked collapse">
                    <li class="liClass"><a href="workbench/chart/machine/index.do" target="workareaFrame">&nbsp;&nbsp;&nbsp;<span class="glyphicon glyphicon-chevron-right"></span> 机器图表</a></li>
                    <li class="liClass"><a href="workbench/chart/appointment/index.do" target="workareaFrame">&nbsp;&nbsp;&nbsp;<span class="glyphicon glyphicon-chevron-right"></span> 预约图表</a></li>
                    <li class="liClass"><a href="chart/customerAndContacts/index.html" target="workareaFrame">&nbsp;&nbsp;&nbsp;<span class="glyphicon glyphicon-chevron-right"></span> 客户和联系人统计图表</a></li>
                    <li class="liClass"><a href="chart/transaction/index.html" target="workareaFrame">&nbsp;&nbsp;&nbsp;<span class="glyphicon glyphicon-chevron-right"></span> 交易统计图表</a></li>
                </ul>
            </li>--%>

        </ul>

        <!-- 分割线 -->
        <div id="divider1" style="position: absolute; top : 0px; right: 0px; width: 1px; height: 100% ; background-color: #B3B3B3;"></div>
    </div>

    <!-- 工作区 -->
    <div id="workarea" style="position: absolute; top : 0px; left: 13%; width: 87%; height: 100%;">
        <iframe style="border-width: 0px; width: 100%; height: 100%;" name="workareaFrame"></iframe>
    </div>

</div>

<div id="divider2" style="height: 1px; width: 100%; position: absolute;bottom: 30px; background-color: #B3B3B3;"></div>

<!-- 底部 -->
<div id="down" style="height: 30px; width: 100%; position: absolute;bottom: 0px;"></div>

</body>
</html>
