<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2022/5/2
  Time: 20:33
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

    <!--引入select插件-->
    <link href="jquery/bootstrap-select-1.13.14/dist/css/bootstrap-select.min.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="jquery/bootstrap-select-1.13.14/dist/js/bootstrap-select.js"></script>



    <script type="text/javascript">

        $(function () {
            //下拉框属性
            $(".selectpicker").selectpicker({
                language:'zh-CN',
                width:'100%',
                size:5,
                style:'',
                styleBase:'form-control'
            });

            //给创建按钮添加单击事件
            $("#createDoctorBtn").click(function () {
                //初始化工作 清空表单
                $("#createDoctorForm").get(0).reset();

                //弹出添加患者的模态窗口
                $("#createDoctorModal").modal("show");

            });

            //修改按钮
            $("#tBody").on("click","button[class='btn btn-primary btn-sm']",function () {
                var id = this.value;

                $.ajax({
                    url:'workbench/doctor/queryDoctorById.do',
                    data:{
                        id:id
                    },
                    type:'post',
                    dataType:'json',
                    success:function (data) {
                        $("#edit-doctorId").val(data.doctorId);
                        $("#edit-doctorDepartment").val(data.doctorDepartment);
                        $("#edit-doctorGender").val(data.doctorGender);
                        $("#edit-doctorPhone").val(data.doctorPhone);
                        $("#edit-doctorTitle").val(data.doctorTitle);

                        $("#editDoctorModal").modal("show");
                    }
                })
            });

            //保存修改
            $("#saveEditDoctorBtn").click(function () {
                //收集参数
                var doctorId = $.trim($("#edit-doctorId").val());
                var doctorDepartment = $.trim($("#edit-doctorDepartment").val());
                var doctorPhone = $.trim($("#edit-doctorPhone").val());
                var doctorGender = $.trim($("#edit-doctorGender").val());
                var doctorTitle = $.trim($("#edit-doctorTitle").val());
                var doctorAge = $.trim($("#edit-doctorAge").val());


                //发送请求
                $.ajax({
                    url:'workbench/doctor/saveEditDoctor.do',
                    data:{
                        doctorId:doctorId,
                        doctorDepartment:doctorDepartment,
                        doctorPhone:doctorPhone,
                        doctorGender:doctorGender,
                        doctorTitle:doctorTitle,
                        doctorAge:doctorAge
                    },
                    type:'post',
                    dataType:'json',
                    success:function (data) {
                        if(data.code=="1"){
                            //关闭模态窗口
                            $("#editDoctorModal").modal("hide");
                            //刷新
                            queryDoctorByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));

                        }else{
                            //提示信息
                            alert(data.message);
                            //模态窗口不关
                            $("#editDoctorModal").modal("show");
                        }
                    }
                });
            });

            //给保存按钮添加单击事件
            $("#saveCreateDoctorBtn").click(function () {
                //收集参数
                var doctorId = $.trim($("#create-doctorId").val());
                var doctorDepartment = $.trim($("#create-doctorDepartment").val());
                var doctorPhone = $.trim($("#create-doctorPhone").val());
                var doctorGender = $.trim($("#create-doctorGender").val());
                var doctorTitle = $.trim($("#create-doctorTitle").val());
                var doctorAge = $.trim($("#create-doctorAge").val());


                //发送请求
                $.ajax({
                    url:'workbench/doctor/saveCreateDoctor.do',
                    data:{
                        doctorId:doctorId,
                        doctorDepartment:doctorDepartment,
                        doctorPhone:doctorPhone,
                        doctorGender:doctorGender,
                        doctorTitle:doctorTitle,
                        doctorAge:doctorAge
                    },
                    type:'post',
                    dataType:'json',
                    success:function (data) {
                        if(data.code=="1"){
                            //关闭模态窗口
                            $("#createDoctorModal").modal("hide");
                            //刷新
                            queryDoctorByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));

                        }else{
                            //提示信息
                            alert(data.message);
                            //模态窗口不关
                            $("#createDoctorModal").modal("show");
                        }
                    }
                });
            });

            //给查询按钮加
            queryDoctorByConditionForPage(1,10);

            //查询按钮
            $("#queryDoctorBtn").click(function () {
                queryDoctorByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
            });
        })

        /**
         * 容器加载完了就执行
         * @param pageNo
         * @param pageSize
         */
        function queryDoctorByConditionForPage(pageNo,pageSize) {
            //收集参数
            var queryName = $("#queryName").val();

            //发请求
            $.ajax({
                url:"workbench/doctor/queryDoctorByConditionForPage.do",
                data: {
                    name: queryName,
                    pageNo: pageNo,
                    pageSize: pageSize
                },
                type: 'post',
                dataType: 'json',
                success: function (data) {
                    var htmlStr = "";
                    $.each(data.doctorList, function (index,obj) {

                        //浅拼一下字符串
                        htmlStr += "<tr class=\"doctor\">";
                        htmlStr += "<td>" + obj.doctorId + "</td>";
                        htmlStr += "<td>" + obj.doctorName + "</td>";
                        if(obj.doctorGender==1){
                            htmlStr += "<td>女</td>";
                        }else if(obj.doctorGender==0){
                            htmlStr += "<td>男</td>";
                        }else{
                            htmlStr += "<td></td>";
                        }
                        if((obj.doctorDepartment!=null)&&(obj.doctorDepartment!="")){
                            htmlStr += "<td>" + obj.doctorDepartment + "</td>";
                        }else{
                            htmlStr += "<td></td>";
                        }
                        if((obj.doctorTitle!=null)&&(obj.doctorTitle!="")){
                            htmlStr += "<td>" + obj.doctorTitle + "</td>";
                        }else{
                            htmlStr += "<td></td>";
                        }
                        if((obj.doctorPhone!=null)&&(obj.doctorPhone!="")){
                            htmlStr += "<td>" + obj.doctorPhone + "</td>";
                        }else{
                            htmlStr += "<td></td>";
                        }
                        htmlStr += "<td><button type=\"button\" class=\"btn btn-primary btn-sm\" value=\"" + obj.doctorId + "\">修改</button>";
                        htmlStr += "<button type=\"button\" class=\"btn btn-danger btn-sm\" value=\"" + obj.doctorId + "\" style=\"margin-left:4px\">删除</button></td>";

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
                            queryDoctorByConditionForPage(pageObj.currentPage, pageObj.rowsPerPage);
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
            <h3>医生列表</h3>
        </div>
    </div>
</div>

<!--查询和添加-->
<div class="btn-toolbar" role="toolbar">
    <div class="col-sm-3">
        <form class="form-inline" role="form" style="position: relative;top: -10px; left: 5px;">

            <div class="form-group">
                <div class="input-group">
                    <div class="input-group-addon">姓名</div>
                    <input class="form-control" type="text" id="queryName">
                </div>
            </div>

            <button type="button" class="btn btn-default" id="queryDoctorBtn">查询</button>

        </form>
    </div>

    <div class="col-sm-1">
        <div class="btn-toolbar" role="toolbar" style="height: 50px; position: relative;top: -10px;">
            <div class="btn-group" style="position: relative;">
                <button type="button" class="btn btn-primary" id="createDoctorBtn"><span class="glyphicon glyphicon-plus"></span> 添加</button>
            </div>
        </div>
    </div>

</div>

<!-- 添加医生的模态窗口 -->
<div class="modal fade" id="createDoctorModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">添加医生窗口</h4>
            </div>
            <div class="modal-body">

                <form id="createDoctorForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-doctorId" class="col-sm-2 control-label">医生工号<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="selectpicker" id="create-doctorId" data-live-search="true">
                                <c:forEach items="${staffList}" var="s">
                                    <option value="${s.staffId}">${s.staffId}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <label for="create-doctorDepartment" class="col-sm-2 control-label">所属科室</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="selectpicker" id="create-doctorDepartment">
                                <option value="">请选择</option>
                                <c:forEach items="${departmentList}" var="d">
                                    <option value="${d.departmentId}">${d.departmentName}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <lable for="create-doctorGender" class="col-sm-2 control-label">性别</lable>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-doctorGender">
                                <option value="0">男</option>
                                <option value="1">女</option>
                            </select>
                        </div>

                        <lable for="create-doctorTitle" class="col-sm-2 control-label">职称</lable>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-doctorTitle">
                        </div>

                    </div>

                    <div class="form-group">
                        <lable for="create-doctorPhone" class="col-sm-2 control-label">电话</lable>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-doctorPhone">
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveCreateDoctorBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改医生的模态窗口 -->
<div class="modal fade" id="editDoctorModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改医生窗口</h4>
            </div>
            <div class="modal-body">

                <form id="editDoctorForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-doctorId" class="col-sm-2 control-label">医生工号<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-doctorId" readonly>
                        </div>

                        <label for="edit-doctorDepartment" class="col-sm-2 control-label">所属科室</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="selectpicker" id="edit-doctorDepartment">
                                <option value="">请选择</option>
                                <c:forEach items="${departmentList}" var="d">
                                    <option value="${d.departmentId}">${d.departmentName}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <lable for="edit-doctorGender" class="col-sm-2 control-label">性别</lable>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-doctorGender">
                                <option value="0">男</option>
                                <option value="1">女</option>
                            </select>
                        </div>

                        <lable for="edit-doctorTitle" class="col-sm-2 control-label">职称</lable>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-doctorTitle">
                        </div>

                    </div>

                    <div class="form-group">
                        <lable for="edit-doctorPhone" class="col-sm-2 control-label">电话</lable>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-doctorPhone">
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveEditDoctorBtn">保存</button>
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
                    <td style="width:12.5%">医生工号</td>
                    <td style="width:12.5%">医生姓名</td>
                    <td style="width:12.5%">性别</td>
                    <td style="width:12.5%">科室</td>
                    <td style="width:12.5%">职称</td>
                    <td style="width:12.5%">联系电话</td>
                    <td style="width:12.5%">操作</td>
                    <%--<td style="width:12.5%">操作</td>--%>
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

