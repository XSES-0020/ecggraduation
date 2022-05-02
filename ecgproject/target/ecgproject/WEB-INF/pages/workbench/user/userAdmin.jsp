<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2022/5/2
  Time: 19:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
    <base href = "<%=basePath%>">
    <meta charset="UTF-8">
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <%--引入pagination插件--%>
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

    <script type="text/javascript">
        $(function () {

            queryUserByConditionForPage(null,1,10);

            //修改选项
            $("input[type='radio'][name='options']").change(function () {
                var scan = $("input[name='options']:checked").val();
                if(scan=="option1"){
                    queryUserByConditionForPage(null,1,10);
                }else if(scan=="option2"){
                    queryUserByConditionForPage(1,1,10);
                }else{
                    queryUserByConditionForPage(0,1,10);
                }
            });

            //查询按钮
            $("#queryStaffBtn").click(function () {
                var scan = $("input[name='options']:checked").val();
                if(scan=="option1"){
                    queryUserByConditionForPage(null,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                }else if(scan=="option2"){
                    queryUserByConditionForPage(1,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                }else{
                    queryUserByConditionForPage(0,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                }
            });

            //删除按钮
            $("#tBody").on("click","button[class='btn btn-danger btn-sm']",function () {
                var id = this.value;

                if(window.confirm("是否确认删除？")){
                    $.ajax({
                        url:'workbench/user/deleteUserById.do',
                        data:{
                            userId:id
                        },
                        type:'post',
                        dataType:'json',
                        success:function (data){
                            if(data.code=="1"){
                                //刷新
                                var scan = $("input[name='options']:checked").val();
                                if(scan=="option1"){
                                    queryUserByConditionForPage(null,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                                }else if(scan=="option2"){
                                    queryUserByConditionForPage(1,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                                }else{
                                    queryUserByConditionForPage(0,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                                }
                            }else{
                                //提示
                                alert(data.message);
                            }
                        }
                    });
                }
            });

            //重置密码按钮
            $("#tBody").on("click","button[class='btn btn-primary btn-sm']",function () {
                var id = this.value;

                $.ajax({
                    url:'settings/qx/user/updatePwd.do',
                    data:{
                        userId:id,
                        userPassword:"123456"
                    },
                    type:'post',
                    dataType:'json',
                    success:function (data) {
                        if(data.code=="1"){
                            alert("密码已重置为123456");
                            //刷新
                            var scan = $("input[name='options']:checked").val();
                            if(scan=="option1"){
                                queryStaffByConditionForPage(null,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                            }else if(scan=="option2"){
                                queryStaffByConditionForPage(1,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                            }else{
                                queryStaffByConditionForPage(0,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                            }
                        }else{
                            //提示信息
                            alert(data.message);
                        }
                    }
                })
            });


        });

        /**
         * 容器加载完了就执行
         */
        function queryUserByConditionForPage(state,pageNo,pageSize){
            //当市场活动主页面加载完成，查询所有数据的第一页以及所有数据的总条数
            //收集参数
            var name = $.trim($("#queryName").val());
            var id = $.trim($("#queryId").val());
            var state = state;

            //发请求
            $.ajax({
                url: 'workbench/user/queryUserByConditionForPage.do',
                data: {
                    name: name,
                    id: id,
                    type: state,
                    pageNo: pageNo,
                    pageSize: pageSize
                },
                type: 'post',
                dataType: 'json',
                success: function (data) {
                    var htmlStr = "";
                    $.each(data.userList, function (index, obj) {
                        htmlStr += "<tr class=\"user\">";
                        htmlStr += "<td>" + obj.userId + "</td>";
                        htmlStr += "<td>" + obj.userName + "</td>";
                        if(obj.userType=="1"){
                            htmlStr += "<td>管理员</td>";
                        }else{
                            htmlStr += "<td>普通用户</td>";
                        }

                        if(obj.userCreatetime!=null&&obj.userCreatetime!=""){
                            htmlStr += "<td>" + obj.userCreatetime + "</td>";
                        }else{
                            htmlStr += "<td></td>";
                        }

                        if(obj.userPhone!=null&&obj.userPhone!=""){
                            htmlStr += "<td>" + obj.userPhone + "</td>";
                        }else{
                            htmlStr += "<td></td>";
                        }

                        if(obj.userDescribe!=null&&obj.userDescribe!=""){
                            htmlStr += "<td>" + obj.userDescribe + "</td>";
                        }else{
                            htmlStr += "<td>暂无</td>";
                        }

                        htmlStr += "<td><button type=\"button\" class=\"btn btn-primary btn-sm\" value=\"" + obj.userId + "\">重置密码</button>";
                        htmlStr += "<button type=\"button\" class=\"btn btn-danger btn-sm\" value=\"" + obj.userId + "\" style=\"margin-left:4px\">删除</button></td>";
                        htmlStr += "</tr>";
                    });
                    $("#tBody").html(htmlStr);

                    //计算总页数
                    var totalPages = 1;
                    if (data.totalRows % pageSize == 0) {
                        totalPages = data.totalRows / pageSize;
                    } else {
                        totalPages = parseInt(data.totalRows / pageSize) + 1;
                    }

                    /**
                     * 翻页的
                     */
                    //调bs_pagination工具函数显示翻页信息
                    $("#demo_pag1").bs_pagination({
                        currentPage: pageNo,//当前页号,相当于pageNo

                        rowsPerPage: pageSize,//每页显示条数,相当于pageSize
                        totalRows: data.totalRows,//总条数
                        totalPages: totalPages,  //总页数,必填参数.

                        visiblePageLinks: 5,//最多可以显示的卡片数

                        showGoToPage: true,//是否显示"跳转到"部分,默认true--显示
                        showRowsPerPage: true,//是否显示"每页显示条数"部分。默认true--显示
                        showRowsInfo: true,//是否显示记录的信息，默认true--显示

                        //用户每次切换页号，都自动触发本函数;
                        //每次返回切换页号之后的pageNo和pageSize
                        onChangePage: function (event, pageObj) { // returns page_num and rows_per_page after a link has clicked
                            var scan = $("input[name='options']:checked").val();
                            if(scan=="option1"){
                                queryUserByConditionForPage(null,pageObj.currentPage, pageObj.rowsPerPage);
                            }else if(scan=="option2"){
                                queryUserByConditionForPage(1,pageObj.currentPage, pageObj.rowsPerPage);
                            }else{
                                queryUserByConditionForPage(0,pageObj.currentPage, pageObj.rowsPerPage);
                            }
                        }
                    });
                }
            });
        }
    </script>
</head>
<body>


<!--表头-->
<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>用户管理</h3>
        </div>
    </div>
</div>

<div>
    <div class="col-sm-3">
        <!--来个按钮组先-->
        <div id="btn-group" class="btn-group" data-toggle="buttons" style="position: relative; top: -10px;">
            <label class="btn btn-default active">
                <input type="radio" name="options" value="option1" checked="true">全部
            </label>
            <label class="btn btn-default">
                <input type="radio" name="options" value="option2">管理员
            </label>
            <label class="btn btn-default">
                <input type="radio" name="options" value="option3">普通用户
            </label>
        </div>
    </div>
    <div class="col-sm-8">
        <form class="form-inline" role="form" style="position: relative;top: -10px;">

            <div class="form-group">
                <div class="input-group">
                    <div class="input-group-addon">姓名</div>
                    <input class="form-control" type="text" id="queryName">
                </div>
            </div>

            <div class="form-group">
                <div class="input-group">
                    <div class="input-group-addon">账号</div>
                    <input class="form-control" type="text" id="queryId">
                </div>
            </div>

            <button type="button" class="btn btn-default" id="queryStaffBtn">查询</button>

        </form>
    </div>
</div>

<div style="position: relative; top: 20px; left: 0px; width: 100%; height: 100%;">
    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td style="width:14%">账号</td>
                    <td style="width:10%">姓名</td>
                    <td style="width:10%">角色</td>
                    <td style="width:18%">注册时间</td>
                    <td style="width:14%">电话</td>
                    <td style="width:14%">备注</td>
                    <td style="width:18%">操作</td>
                </tr>
                </thead>
                <tbody id="tBody">

                </tbody>
            </table>
            <div id="demo_pag1"></div>
        </div>
    </div>
</div>
</body>
</html>



