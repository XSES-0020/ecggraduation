<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2022/5/2
  Time: 22:16
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
            //给创建按钮添加单击事件
            $("#createDepartmentBtn").click(function () {
                //初始化工作 清空表单
                $("#createDepartmentForm").get(0).reset();

                //弹出添加患者的模态窗口
                $("#createDepartmentModal").modal("show");

            });

            //给保存按钮添加单击事件
            $("#saveCreateDepartmentBtn").click(function () {
                //收集参数
                var departmentId = $.trim($("#create-departmentId").val());
                var departmentName = $.trim($("#create-departmentName").val());
                var departmentAddress = $.trim($("#create-departmentAddress").val());

                if(departmentId==""){
                    alert("科室编号不能为空");
                    return;
                }
                if(departmentName==""){
                    alert("科室名称不能为空");
                    return;
                }
                //发送请求
                $.ajax({
                    url:'workbench/department/saveCreateDepartment.do',
                    data:{
                        departmentId:departmentId,
                        departmentName:departmentName,
                        departmentAddress:departmentAddress
                    },
                    type:'post',
                    dataType:'json',
                    success:function (data) {
                        if(data.code=="1"){
                            //关闭模态窗口
                            $("#createDepartmentModal").modal("hide");
                            //刷新
                            queryDepartmentByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));

                        }else{
                            //提示信息
                            alert(data.message);
                            //模态窗口不关
                            $("#createDepartmentModal").modal("show");
                        }
                    }
                });
            });

            //给修改按钮添加单击事件
            $("#saveEditDepartmentBtn").click(function () {
                //收集参数
                var departmentId = $.trim($("#edit-departmentId").val());
                var departmentName = $.trim($("#edit-departmentName").val());
                var departmentAddress = $.trim($("#edit-departmentAddress").val());

                if(departmentId==""){
                    alert("科室编号不能为空");
                    return;
                }
                if(departmentName==""){
                    alert("科室名称不能为空");
                    return;
                }
                //发送请求
                $.ajax({
                    url:'workbench/department/saveEditDepartment.do',
                    data:{
                        departmentId:departmentId,
                        departmentName:departmentName,
                        departmentAddress:departmentAddress
                    },
                    type:'post',
                    dataType:'json',
                    success:function (data) {
                        if(data.code=="1"){
                            //关闭模态窗口
                            $("#editDepartmentModal").modal("hide");
                            //刷新
                            queryDepartmentByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));

                        }else{
                            //提示信息
                            alert(data.message);
                            //模态窗口不关
                            $("#editDepartmentModal").modal("show");
                        }
                    }
                });
            });

            queryDepartmentByConditionForPage(1,10);

            //查询按钮
            $("#queryDepartmentBtn").click(function () {
                queryDepartmentByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
            });

            //修改按钮
            $("#tBody").on("click","button[class='btn btn-primary btn-sm']",function () {
                var id = this.value;

                $.ajax({
                    url:'workbench/department/queryDepartmentById.do',
                    data:{
                        id:id
                    },
                    type:'post',
                    dataType:'json',
                    success:function (data) {
                        $("#edit-departmentId").val(data.departmentId);
                        $("#edit-departmentName").val(data.departmentName);
                        $("#edit-departmentAddress").val(data.departmentAddress);

                        $("#editDepartmentModal").modal("show");
                    }
                })
            });

            //删除
            $("#tBody").on("click","button[class='btn btn-danger btn-sm']",function () {
                var id = this.value;

                if(window.confirm("是否确认删除？")){
                    $.ajax({
                        url:'workbench/department/deleteDepartmentById.do',
                        data:{
                            id:id
                        },
                        type:'post',
                        dataType:'json',
                        success:function (data){
                            if(data.code=="1"){
                                //刷新
                                queryDepartmentByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                            }else{
                                //提示
                                alert(data.message);
                            }
                        }
                    });
                }
            });

        })

        /**
         * 容器加载完了就执行
         * @param pageNo
         * @param pageSize
         */
        function queryDepartmentByConditionForPage(pageNo,pageSize) {
            //收集参数
            var queryName = $("#queryName").val();

            //发请求
            $.ajax({
                url:"workbench/department/queryDepartmentByConditionForPage.do",
                data: {
                    name: queryName,
                    pageNo: pageNo,
                    pageSize: pageSize
                },
                type: 'post',
                dataType: 'json',
                success: function (data) {
                    var htmlStr = "";
                    $.each(data.departmentList, function (index,obj) {

                        //浅拼一下字符串
                        htmlStr += "<tr class=\"department\">";
                        htmlStr += "<td>" + obj.departmentId + "</td>";
                        htmlStr += "<td>" + obj.departmentName + "</td>";
                        htmlStr += "<td>" + obj.departmentAddress + "</td>";
                        htmlStr += "<td><button type=\"button\" class=\"btn btn-primary btn-sm\" value=\"" + obj.departmentId + "\">修改</button>";
                        htmlStr += "<button type=\"button\" class=\"btn btn-danger btn-sm\" value=\"" + obj.departmentId + "\" style=\"margin-left:4px\">删除</button></td>";

                        htmlStr += "</tr>";

                    });

                    //显示
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
                            //js代码
                            //alert(pageObj.currentPage);
                            //alert(pageObj.rowsPerPage);
                            queryDepartmentByConditionForPage(pageObj.currentPage, pageObj.rowsPerPage);
                        }
                    });

                }
            });
        }
    </script>
</head>
<body>
<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>科室列表</h3>
        </div>
    </div>
</div>

<!--添加科室的模态窗口-->
<div class="modal fade" id="createDepartmentModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">添加科室窗口</h4>
            </div>
            <div class="modal-body">

                <form id="createDepartmentForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-departmentId" class="col-sm-2 control-label">科室编号<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-departmentId">
                        </div>
                        <label for="create-departmentName" class="col-sm-2 control-label">科室名称<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-departmentName">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-departmentAddress" class="col-sm-2 control-label">科室地点</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-departmentAddress">
                        </div>
                    </div>


                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveCreateDepartmentBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!--修改科室的模态窗口-->
<div class="modal fade" id="editDepartmentModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改科室窗口</h4>
            </div>
            <div class="modal-body">

                <form id="editDepartmentForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-departmentId" class="col-sm-2 control-label">科室编号<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-departmentId" readonly>
                        </div>
                        <label for="edit-departmentName" class="col-sm-2 control-label">科室名称<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-departmentName">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-departmentAddress" class="col-sm-2 control-label">科室地点</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-departmentAddress">
                        </div>
                    </div>


                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveEditDepartmentBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<div class="btn-toolbar" role="toolbar">
    <div class="col-sm-3">
        <form class="form-inline" role="form" style="position: relative;top: -10px; left: 5px;">

            <div class="form-group">
                <div class="input-group">
                    <div class="input-group-addon">名称</div>
                    <input class="form-control" type="text" id="queryName">
                </div>
            </div>

            <button type="button" class="btn btn-default" id="queryDepartmentBtn">查询</button>

        </form>
    </div>

    <div class="col-sm-1">
        <div class="btn-toolbar" role="toolbar" style="height: 50px; position: relative;top: -10px;">
            <div class="btn-group" style="position: relative;">
                <button type="button" class="btn btn-primary" id="createDepartmentBtn"><span class="glyphicon glyphicon-plus"></span> 添加</button>
            </div>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
    <div style="width: 100%; position: absolute; left: 10px;">

        <div style="position: relative;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <%--<td><input type="checkbox" /></td>--%>
                    <td style="width:12.5%">科室编号</td>
                    <td style="width:12.5%">科室</td>
                    <td style="width:12.5%">位置</td>
                    <td style="width:12.5%">操作</td>
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


