<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2022/4/26
  Time: 21:19
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
            $("#createMachineBtn").click(function () {
                //初始化工作 清空表单
                $("#createMachineForm").get(0).reset();

                //弹出添加患者的模态窗口
                $("#createMachineModal").modal("show");
            });

            //给保存按钮添加单击事件
            $("#saveCreateMachineBtn").click(function () {
                //收集参数
                var machineId = $.trim($("#create-machineId").val());
                var machineState = $.trim($("#create-machineState").val());

                //表单验证
                if (machineId == "") {
                    alert("机器编号不能为空");
                    return;
                }
                if (machineState == "") {
                    alert("机器状态不能为空");
                    return;
                }

                //发送请求
                $.ajax({
                    url: 'workbench/machine/saveCreateMachine.do',
                    data: {
                        machineId: machineId,
                        machineState: machineState
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (data) {
                        if (data.code == "1") {
                            //关闭模态窗口
                            $("#createMachineModal").modal("hide");
                            //刷新市场活动列
                            var scan = $("input[name='options']:checked").val();
                            if(scan=="option1"){
                                queryMachineByConditionForPage(null,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                            }else if(scan=="option2"){
                                queryMachineByConditionForPage(1,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                            }else if(scan=="option3"){
                                queryMachineByConditionForPage(0,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                            }else if(scan=="option4"){
                                queryMachineByConditionForPage(2,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                            }else{
                                queryMachineByConditionForPage(3,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                            }
                        } else {
                            //提示信息
                            alert(data.message);
                            //模态窗口不关
                            $("#createMachineModal").modal("show");
                        }
                    }
                });
            });

            queryMachineByConditionForPage(null,1,10);

            //修改选项
            $("input[type='radio'][name='options']").change(function () {
                var scan = $("input[name='options']:checked").val();
                if(scan=="option1"){
                    queryMachineByConditionForPage(null,1,10);
                }else if(scan=="option2"){
                    queryMachineByConditionForPage(1,1,10);
                }else if(scan=="option3"){
                    queryMachineByConditionForPage(0,1,10);
                }else if(scan=="option4"){
                    queryMachineByConditionForPage(2,1,10);
                }else{
                    queryMachineByConditionForPage(3,1,10);
                }
            });

            //查询按钮
            $("#queryMachineBtn").click(function () {
                queryMachineByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
            });

            //删除按钮
            $("#tBody").on("click","button[class='btn btn-danger btn-sm']",function () {
                var id = this.value;

                if(window.confirm("是否确认删除？")){
                    $.ajax({
                        url:'workbench/machine/deleteMachineById.do',
                        data:{
                            machineId:id
                        },
                        type:'post',
                        dataType:'json',
                        success:function (data){
                            if(data.code=="1"){
                                //刷新
                                var scan = $("input[name='options']:checked").val();
                                if(scan=="option1"){
                                    queryMachineByConditionForPage(null,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                                }else if(scan=="option2"){
                                    queryMachineByConditionForPage(1,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                                }else if(scan=="option3"){
                                    queryMachineByConditionForPage(0,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                                }else if(scan=="option4"){
                                    queryMachineByConditionForPage(2,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                                }else{
                                    queryMachineByConditionForPage(3,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                                }
                            }else{
                                //提示
                                alert(data.message);
                            }
                        }
                    });
                }
            });

            //更新按钮
            $("#tBody").on("click","button[class='btn btn-primary btn-sm']",function () {
                var id = this.value;

                $.ajax({
                    url:'workbench/machine/queryMachineById.do',
                    data:{
                        machineId:id
                    },
                    type:'post',
                    dataType:'json',
                    success:function (data) {
                        $("#edit-machineId").val(data.machineId);
                        $("#edit-machineState").val(data.machineState);

                        $("#editMachineModal").modal("show");
                    }
                })
            });

            //保存更新
            $("#saveEditMachineBtn").click(function () {
                //收集参数
                var machineId = $.trim($("#edit-machineId").val());
                var machineState = $.trim($("#edit-machineState").val());

                //表单验证
                if (machineId == "") {
                    alert("机器编号不能为空");
                    return;
                }
                if (machineState == "") {
                    alert("机器状态不能为空");
                    return;
                }

                //发送请求
                $.ajax({
                    url:'workbench/machine/saveEditMachine.do',
                    data:{
                        machineId:machineId,
                        machineState:machineState
                    },
                    type:'post',
                    dataType:'json',
                    success:function (data) {
                        if(data.code=="1"){
                            //关闭模态窗口
                            $("#editMachineModal").modal("hide");
                            //刷新市场活动列
                            //刷新市场活动列
                            var scan = $("input[name='options']:checked").val();
                            if(scan=="option1"){
                                queryMachineByConditionForPage(null,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                            }else if(scan=="option2"){
                                queryMachineByConditionForPage(1,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                            }else if(scan=="option3"){
                                queryMachineByConditionForPage(0,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                            }else if(scan=="option4"){
                                queryMachineByConditionForPage(2,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                            }else{
                                queryMachineByConditionForPage(3,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                            }
                        }else{
                            //提示信息
                            alert(data.message);
                            //模态窗口不关
                            $("#editMachineModal").modal("show");
                        }
                    }
                });
            });
        });

        /**
         * 容器加载完了就执行
         */
        function queryMachineByConditionForPage(state,pageNo,pageSize){
            //当市场活动主页面加载完成，查询所有数据的第一页以及所有数据的总条数
            //收集参数
            //var queryState = $("#queryState").val();

            //发请求
            $.ajax({
                url: 'workbench/machine/queryMachineByConditionForPage.do',
                data: {
                    state: state,
                    pageNo: pageNo,
                    pageSize: pageSize
                },
                type: 'post',
                dataType: 'json',
                success: function (data) {
                    var htmlStr = "";
                    $.each(data.machineList, function (index, obj) {
                        htmlStr += "<tr class=\"machine\">";
                        htmlStr += "<td>" + obj.machineId + "</td>";
                        htmlStr += "<td>" + obj.machineState + "</td>";
                        htmlStr += "<td><button type=\"button\" class=\"btn btn-primary btn-sm\" value=\"" + obj.machineId + "\">修改</button>";
                        htmlStr += "<button type=\"button\" class=\"btn btn-danger btn-sm\" value=\"" + obj.machineId + "\" style=\"margin-left:4px\">删除</button></td>";
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
                                queryMachineByConditionForPage(null,pageObj.currentPage, pageObj.rowsPerPage);
                            }else if(scan=="option2"){
                                queryMachineByConditionForPage(1,pageObj.currentPage, pageObj.rowsPerPage);
                            }else if(scan=="option3"){
                                queryMachineByConditionForPage(0,pageObj.currentPage, pageObj.rowsPerPage);
                            }else if(scan=="option4"){
                                queryMachineByConditionForPage(2,pageObj.currentPage, pageObj.rowsPerPage);
                            }else{
                                queryMachineByConditionForPage(3,pageObj.currentPage, pageObj.rowsPerPage);
                            }
                        }
                    });
                }
            });
        }
    </script>
</head>

<body>

<!-- 添加机器的模态窗口 -->
<div class="modal fade" id="createMachineModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">添加机器窗口</h4>
            </div>
            <div class="modal-body">

                <form id="createMachineForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-machineId" class="col-sm-2 control-label">机器编号<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-machineId">
                        </div>

                        <label for="create-machineState" class="col-sm-2 control-label">机器状态<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-machineState">
                                <c:forEach items="${machinestateList}" var="m">
                                    <option value="${m.machinestateId}">${m.machinestateDescribe}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveCreateMachineBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!--修改机器状态-->
<div class="modal fade" id="editMachineModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改机器信息</h4>
            </div>
            <div class="modal-body">

                <form id="editMachineForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-machineId" class="col-sm-2 control-label">机器编号<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-machineId" readonly>
                        </div>

                        <label for="edit-machineState" class="col-sm-2 control-label">机器状态<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-machineState">
                                <c:forEach items="${machinestateList}" var="m">
                                    <option value="${m.machinestateId}">${m.machinestateDescribe}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveEditMachineBtn">更新</button>
            </div>
        </div>
    </div>
</div>

<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>机器列表</h3>
        </div>
    </div>
</div>

<div>
    <div class="col-sm-1">
        <div style="position: relative; top: -10px;">
            <button type="button" class="btn btn-primary" id="createMachineBtn" style="position: relative; top: 18%;"><span class="glyphicon glyphicon-plus"></span> 添加</button>
        </div>
    </div>
    <div class="col-sm-3">
        <!--来个按钮组先-->
        <div id="btn-group" class="btn-group" data-toggle="buttons" style="position: relative; top: -10px;">
            <label class="btn btn-default active">
                <input type="radio" name="options" value="option1" checked="true">全部
            </label>
            <label class="btn btn-default">
                <input type="radio" name="options" value="option2">可用
            </label>
            <label class="btn btn-default">
                <input type="radio" name="options" value="option3">使用中
            </label>
            <label class="btn btn-default">
                <input type="radio" name="options" value="option4">停用
            </label>
            <label class="btn btn-default">
                <input type="radio" name="options" value="option5">故障
            </label>
        </div>
    </div>
</div>

<div style="position: relative; top: 20px; left: 0px; width: 100%; height: 100%;">
    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">
       <%-- <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">机器状态</div>
                        <input class="form-control" type="text" id="queryState">
                    </div>
                </div>


                <button type="button" class="btn btn-default" id="queryMachineBtn">查询</button>

            </form>
        </div>--%>



        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td style="width:33%">机器编号</td>
                    <td style="width:33%">机器状态</td>
                    <td style="width:34%">操作</td>
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
