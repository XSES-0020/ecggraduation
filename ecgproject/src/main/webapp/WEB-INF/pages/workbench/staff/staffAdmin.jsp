<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2022/5/2
  Time: 15:53
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
            $("#createStaffBtn").click(function () {
                //初始化工作 清空表单
                $("#createStaffForm").get(0).reset();

                //弹出添加患者的模态窗口
                $("#createStaffModal").modal("show");
            });

            //给保存按钮添加单击事件
            $("#saveCreateStaffBtn").click(function () {
                //收集参数
                var staffId = $.trim($("#create-staffId").val());
                var staffName = $.trim($("#create-staffName").val());
                var staffDescribe = $.trim($("#create-staffDescribe").val());
                var staffWork = $.trim($("#create-staffWork").val());

                //表单验证
                if (staffId == "") {
                    alert("工号不能为空");
                    return;
                }
                if (staffName == "") {
                    alert("姓名不能为空");
                    return;
                }

                //发送请求
                $.ajax({
                    url: 'workbench/patient/saveCreateStaff.do',
                    data: {
                        staffId:staffId,
                        staffWork:staffWork,
                        staffName:staffName,
                        staffDescribe:staffDescribe
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (data) {
                        if (data.code == "1") {
                            //关闭模态窗口
                            $("#createStaffModal").modal("hide");
                            //刷新市场活动列
                            var scan = $("input[name='options']:checked").val();
                            if(scan=="option1"){
                                queryStaffByConditionForPage(null,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                            }else if(scan=="option2"){
                                queryStaffByConditionForPage(1,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                            }else{
                                queryStaffByConditionForPage(0,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                            }
                        } else {
                            //提示信息
                            alert(data.message);
                            //模态窗口不关
                            $("#createStaffModal").modal("show");
                        }
                    }
                });
            });

            queryStaffByConditionForPage(null,1,10);

            //修改选项
            $("input[type='radio'][name='options']").change(function () {
                var scan = $("input[name='options']:checked").val();
                if(scan=="option1"){
                    queryStaffByConditionForPage(null,1,10);
                }else if(scan=="option2"){
                    queryStaffByConditionForPage(1,1,10);
                }else{
                    queryStaffByConditionForPage(0,1,10);
                }
            });

            //查询按钮
            $("#queryStaffBtn").click(function () {
                var scan = $("input[name='options']:checked").val();
                if(scan=="option1"){
                    queryStaffByConditionForPage(null,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                }else if(scan=="option2"){
                    queryStaffByConditionForPage(1,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                }else{
                    queryStaffByConditionForPage(0,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                }
            });

            //删除按钮
            $("#tBody").on("click","button[class='btn btn-danger btn-sm']",function () {
                var id = this.value;

                if(window.confirm("是否确认删除？")){
                    $.ajax({
                        url:'workbench/staff/deleteStaffById.do',
                        data:{
                            staffId:id
                        },
                        type:'post',
                        dataType:'json',
                        success:function (data){
                            if(data.code=="1"){
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
                    url:'workbench/staff/queryStaffById.do',
                    data:{
                        staffId:id
                    },
                    type:'post',
                    dataType:'json',
                    success:function (data) {
                        $("#edit-staffId").val(data.staffId);
                        $("#edit-staffName").val(data.staffName);
                        $("#edit-staffDescribe").val(data.staffDescribe);
                        $("#edit-staffStatus").val(data.staffStatus);
                        $("#edit-staffWork").val(data.staffWork);

                        $("#editStaffModal").modal("show");
                    }
                })
            });

            //保存更新
            $("#saveEditStaffBtn").click(function () {
                //收集参数
                var staffId = $("#edit-staffId").val();
                var staffName = $("#edit-staffName").val();
                var staffDescribe = $("#edit-staffDescribe").val();
                var staffStatus = $("#edit-staffStatus").val();
                var staffWork = $("#edit-staffWork").val();

                //表单验证
                if (staffName == "") {
                    alert("姓名不能为空");
                    return;
                }
                if (staffStatus == "") {
                    alert("注册状态不能为空");
                    return;
                }

                //发送请求
                $.ajax({
                    url:'workbench/staff/saveEditStaff.do',
                    data:{
                        staffId:staffId,
                        staffName:staffName,
                        staffDescribe:staffDescribe,
                        staffStatus:staffStatus,
                        staffWork:staffWork
                    },
                    type:'post',
                    dataType:'json',
                    success:function (data) {
                        if(data.code=="1"){
                            //关闭模态窗口
                            $("#editStaffModal").modal("hide");
                            //刷新市场活动列
                            //刷新市场活动列
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
                            //模态窗口不关
                            $("#editStaffModal").modal("show");
                        }
                    }
                });
            });
        });

        /**
         * 容器加载完了就执行
         */
        function queryStaffByConditionForPage(state,pageNo,pageSize){
            //当市场活动主页面加载完成，查询所有数据的第一页以及所有数据的总条数
            //收集参数
            var name = $.trim($("#queryName").val());
            var id = $.trim($("#queryId").val());
            var state = state;

            //发请求
            $.ajax({
                url: 'workbench/staff/queryStaffByConditionForPage.do',
                data: {
                    name: name,
                    id: id,
                    state: state,
                    pageNo: pageNo,
                    pageSize: pageSize
                },
                type: 'post',
                dataType: 'json',
                success: function (data) {
                    var htmlStr = "";
                    $.each(data.staffList, function (index, obj) {
                        htmlStr += "<tr class=\"staff\">";
                        htmlStr += "<td>" + obj.staffId + "</td>";
                        htmlStr += "<td>" + obj.staffName + "</td>";
                        if(obj.staffStatus=="1"){
                            htmlStr += "<td>已注册</td>";
                        }else{
                            htmlStr += "<td>未注册</td>";
                        }

                        if(obj.staffWork=="1"){
                            htmlStr += "<td>在职</td>";
                        }else if(obj.staffWork=="0"){
                            htmlStr += "<td>离职</td>";
                        }else{
                            htmlStr += "<td></td>";
                        }

                        if(obj.staffDescribe!=""&&obj.staffDescribe!=null){
                            htmlStr += "<td>" + obj.staffDescribe + "</td>";
                        }else{
                            htmlStr += "<td>暂无</td>";
                        }
                        htmlStr += "<td><button type=\"button\" class=\"btn btn-primary btn-sm\" value=\"" + obj.staffId + "\">修改</button>";
                        htmlStr += "<button type=\"button\" class=\"btn btn-danger btn-sm\" value=\"" + obj.staffId + "\" style=\"margin-left:4px\">删除</button></td>";
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
                                queryStaffByConditionForPage(null,pageObj.currentPage, pageObj.rowsPerPage);
                            }else if(scan=="option2"){
                                queryStaffByConditionForPage(1,pageObj.currentPage, pageObj.rowsPerPage);
                            }else{
                                queryStaffByConditionForPage(0,pageObj.currentPage, pageObj.rowsPerPage);
                            }
                        }
                    });
                }
            });
        }
    </script>
</head>

<body>

<!-- 添加员工的模态窗口 -->
<div class="modal fade" id="createStaffModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">添加员工窗口</h4>
            </div>
            <div class="modal-body">

                <form id="createStaffForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-staffId" class="col-sm-2 control-label">员工工号<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-staffId">
                        </div>

                        <label for="create-staffName" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-staffName">
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-staffWork" class="col-sm-2 control-label">在职状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <%--<input type="text" class="form-control" id="create-staffWork">--%>
                                <select class="form-control" id="create-staffWork">
                                    <option value="1">在职</option>
                                    <option value="0">离职</option>
                                </select>
                        </div>

                        <label for="create-staffDescribe" class="col-sm-2 control-label">备注</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-staffDescribe">
                            </div>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveCreateStaffBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!--修改员工信息状态-->
<div class="modal fade" id="editStaffModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改机器信息</h4>
            </div>
            <div class="modal-body">

                <form id="editStaffForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-staffId" class="col-sm-2 control-label">员工工号<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-staffId" readonly>
                        </div>

                        <label for="edit-staffName" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-staffName">
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-staffWork" class="col-sm-2 control-label">在职状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <%--<input type="text" class="form-control" id="create-staffWork">--%>
                            <select class="form-control" id="edit-staffWork">
                                <option value="1">在职</option>
                                <option value="0">离职</option>
                            </select>
                        </div>

                        <label for="edit-staffDescribe" class="col-sm-2 control-label">备注</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-staffDescribe">
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-staffStatus" class="col-sm-2 control-label">在职状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <%--<input type="text" class="form-control" id="create-staffWork">--%>
                            <select class="form-control" id="edit-staffStatus">
                                <option value="1">已注册</option>
                                <option value="0">未注册</option>
                            </select>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveEditStaffBtn">更新</button>
            </div>
        </div>
    </div>
</div>

<!--表头-->
<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>员工管理</h3>
        </div>
    </div>
</div>

<div>
    <div class="col-sm-1">
        <div style="position: relative; top: -10px;">
            <button type="button" class="btn btn-primary" id="createStaffBtn" style="position: relative; top: 18%;"><span class="glyphicon glyphicon-plus"></span> 添加</button>
        </div>
    </div>
    <div class="col-sm-3">
        <!--来个按钮组先-->
        <div id="btn-group" class="btn-group" data-toggle="buttons" style="position: relative; top: -10px;">
            <label class="btn btn-default active">
                <input type="radio" name="options" value="option1" checked="true">全部
            </label>
            <label class="btn btn-default">
                <input type="radio" name="options" value="option2">已注册
            </label>
            <label class="btn btn-default">
                <input type="radio" name="options" value="option3">未注册
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
                    <div class="input-group-addon">工号</div>
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
                    <td style="width:16%">工号</td>
                    <td style="width:16%">姓名</td>
                    <td style="width:16%">注册状态</td>
                    <td style="width:16%">在职状态</td>
                    <td style="width:16%">备注</td>
                    <td style="width:20%">操作</td>
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

