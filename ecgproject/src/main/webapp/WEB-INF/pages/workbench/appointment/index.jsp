<%@ page import="java.util.Date" %><%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2022/4/23
  Time: 22:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
            $("#createAppointmentBtn").click(function () {
                //初始化工作 清空表单
                $("#createAppointmentForm").get(0).reset();

                //弹出添加患者的模态窗口
                $("#createAppointmentModal").modal("show");

            });

            //给处理按钮添加单击事件
            $("#saveDealAppointmentBtn").click(function () {
                //收集参数
                var appointmentId = $.trim($("#deal-appointmentId").val());
                var appointmentMachine = $.trim($("#deal-appointmentMachine").val());

                //表单验证
                if(appointmentMachine==""){
                    alert("请选择分配机器");
                    return;
                }

                //发送请求
                $.ajax({
                    url:'workbench/appointment/dealAppointmentById.do',
                    data:{
                        appointmentId:appointmentId,
                        appointmentMachine:appointmentMachine,
                        machineState:"0",
                        appointmentStatus:"2"
                    },
                    type:'post',
                    dataType:'json',
                    success:function (data) {
                        if(data.code=="1"){
                            //关闭模态窗口
                            $("#dealAppointmentModal").modal("hide");
                            //刷新市场活动列
                            var scan = $("input[name='options']:checked").val();
                            if(scan=="option1"){
                                queryAppointmentByConditionForPage(null,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                            }else if(scan=="option2"){
                                queryAppointmentByConditionForPage(1,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                            }else if(scan=="option3"){
                                queryAppointmentByConditionForPage(0,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                            }else{
                                queryAppointmentByConditionForPage(2,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                            }
                        }else{
                            //提示信息
                            alert(data.message);
                            //模态窗口不关
                            $("#dealAppointmentModal").modal("show");
                        }
                    }
                });
            });

            //给保存按钮添加单击事件
            $("#saveCreateAppointmentBtn").click(function () {
                //收集参数
                var appointmentPatient = $.trim($("#create-appointmentPatient").val());
                var appointmentDepartment = $.trim($("#create-appointmentDepartment").val());
                var appointmentDoctor = $.trim($("#create-appointmentDoctor").val());

                //表单验证
                if(appointmentPatient==""){
                    alert("患者就诊卡号不能为空");
                    return;
                }

                //发送请求
                $.ajax({
                    url:'workbench/appointment/saveCreateAppointment.do',
                    data:{
                        appointmentPatient:appointmentPatient,
                        appointmentDepartment:appointmentDepartment,
                        appointmentDoctor:appointmentDoctor
                    },
                    type:'post',
                    dataType:'json',
                    success:function (data) {
                        if(data.code=="1"){
                            //关闭模态窗口
                            $("#createAppointmentModal").modal("hide");
                            //刷新市场活动列
                            var scan = $("input[name='options']:checked").val();
                            if(scan=="option1"){
                                queryAppointmentByConditionForPage(null,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                            }else if(scan=="option2"){
                                queryAppointmentByConditionForPage(1,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                            }else if(scan=="option3"){
                                queryAppointmentByConditionForPage(0,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                            }else{
                                queryAppointmentByConditionForPage(2,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                            }
                        }else{
                            //提示信息
                            alert(data.message);
                            //模态窗口不关
                            $("#createAppointmentModal").modal("show");
                        }
                    }
                });
            });

            //上来先刷新，默认是全部列表的界面
            queryAppointmentByConditionForPage(null,1,10);

            //修改选项
            $("input[type='radio'][name='options']").change(function () {
                var scan = $("input[name='options']:checked").val();
                if(scan=="option1"){
                    queryAppointmentByConditionForPage(null,1,10);
                }else if(scan=="option2"){
                    queryAppointmentByConditionForPage(1,1,10);
                }else if(scan=="option3"){
                    queryAppointmentByConditionForPage(0,1,10);
                }else{
                    queryAppointmentByConditionForPage(2,1,10);
                }
            });

            //删除按钮
            $("#tBody").on("click","button[class='btn btn-danger btn-sm']",function () {
                var appointmentId = this.value;

                if(window.confirm("是否确认删除？")){
                    $.ajax({
                        url:'workbench/appointment/deleteAppointmentById.do',
                        data:{
                            appointmentId:appointmentId
                        },
                        type:'post',
                        dataType:'json',
                        success:function (data){
                            if(data.code=="1"){
                                //刷新市场活动列
                                var scan = $("input[name='options']:checked").val();
                                if(scan=="option1"){
                                    queryAppointmentByConditionForPage(null,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                                }else if(scan=="option2"){
                                    queryAppointmentByConditionForPage(1,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                                }else if(scan=="option3"){
                                    queryAppointmentByConditionForPage(0,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                                }else{
                                    queryAppointmentByConditionForPage(2,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                                }
                            }else{
                                //提示
                                alert(data.message);
                            }
                        }
                    });
                }
            });

            //处理按钮
            $("#tBody").on("click","button[class='btn btn-primary btn-sm']",function () {
                var id = this.value;
                $("#deal-appointmentId").val(id);
                $.ajax({
                    url:"workbench/appointment/queryUsableMachines.do",
                    type:'post',
                    dataType:'json',
                    success:function (data) {
                        /*$("#deal-appointmentMachine").empty();*/

                        var htmlStr1 = "";
                        $.each(data.machineList, function (index,obj) {
                            htmlStr1 += "<option value=\"" + obj.machineId + "\">" + obj.machineId + "</option>";
                        });

                        //显示
                        $("#deal-appointmentMachine").html(htmlStr1);

                        /*$('.selectpicker').selectpicker('render');
                        $('.selectpicker').selectpicker('refresh');*/
                        //弹出处理预约的模态窗口
                        $("#dealAppointmentModal").modal("show");
                    }
                });


            });

            //结束按钮
            $("#tBody").on("click","button[class='btn btn-success btn-sm']",function () {
                var id = this.value;

                if(window.confirm("是否确认结束？")){
                    $.ajax({
                        url:'workbench/appointment/queryAppointmentById.do',
                        data:{
                            appointmentId:id
                        },
                        type:'post',
                        dataType:'json',
                        success:function (data) {
                            var appointmentMachine = data.appointmentMachine;
                            //发送请求
                            $.ajax({
                                url:'workbench/appointment/dealAppointmentById.do',
                                data:{
                                    appointmentId:id,
                                    appointmentMachine:appointmentMachine,
                                    machineState:"1",
                                    appointmentStatus:"1"
                                },
                                type:'post',
                                dataType:'json',
                                success:function (data) {
                                    if(data.code=="1"){
                                        //刷新市场活动列
                                        var scan = $("input[name='options']:checked").val();
                                        if(scan=="option1"){
                                            queryAppointmentByConditionForPage(null,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                                        }else if(scan=="option2"){
                                            queryAppointmentByConditionForPage(1,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                                        }else if(scan=="option3"){
                                            queryAppointmentByConditionForPage(0,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                                        }else{
                                            queryAppointmentByConditionForPage(2,1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                                        }
                                    }else{
                                        //提示信息
                                        alert(data.message);
                                    }
                                }
                            });
                        }
                    })
                }
            });


        });

        /**
         * 容器加载完了就执行
         * @param pageNo
         * @param pageSize
         */
        function queryAppointmentByConditionForPage(take,pageNo,pageSize){
            //发请求
            $.ajax({
                url:"workbench/appointment/queryAppointmentByConditionForPage.do",
                data:{
                    take:take,
                    pageNo:pageNo,
                    pageSize:pageSize
                },
                type:'post',
                dataType:'json',
                success:function (data) {
                    var htmlStr = "";
                    $.each(data.appointmentList, function (index,obj) {

                        //浅拼一下字符串
                        htmlStr += "<tr class=\"appointment\">";
                        htmlStr += "<td>" + obj.appointmentCreatetime + "</td>";
                        if(obj.appointmentDepartment!=null&&obj.appointmentDepartment!=""){
                            htmlStr += "<td>" + obj.appointmentDepartment + "</td>";
                        }else{
                            htmlStr += "<td>/</td>";
                        }

                        if(obj.appointmentDoctor!=null&&obj.appointmentDoctor!=""){
                            htmlStr += "<td>" + obj.appointmentDoctor + "</td>";
                        }else{
                            htmlStr += "<td>/</td>";
                        }

                        htmlStr += "<td>" + obj.appointmentPatient + "</td>";
                        if(obj.appointmentStatus=="1"){
                            htmlStr += "<td>已完成</td>";
                            htmlStr += "<td>" + obj.appointmentTaketime + "</td>";
                            htmlStr += "<td>" + obj.appointmentMachine  + "</td>";
                            htmlStr += "<td><button type=\"button\" class=\"btn btn-primary btn-sm\" disabled=\"disabled\" value=\"" + obj.appointmentId + "\">处理</button>";
                            htmlStr += "<button type=\"button\" class=\"btn btn-success btn-sm\" disabled=\"disabled\" value=\"" + obj.appointmentId + "\" style=\"margin-left:4px\">结束</button>"
                            htmlStr += "<button type=\"button\" class=\"btn btn-danger btn-sm\" value=\"" + obj.appointmentId + "\" style=\"margin-left:4px\">删除</button></td>";
                        }else if(obj.appointmentStatus=="0"){
                            htmlStr += "<td>未处理</td>";
                            htmlStr += "<td>/</td>";
                            htmlStr += "<td>/</td>";
                            htmlStr += "<td><button type=\"button\" class=\"btn btn-primary btn-sm\" value=\"" + obj.appointmentId + "\">处理</button>";
                            htmlStr += "<button type=\"button\" class=\"btn btn-success btn-sm\" disabled=\"disabled\" value=\"" + obj.appointmentId + "\" style=\"margin-left:4px\">结束</button>"
                            htmlStr += "<button type=\"button\" class=\"btn btn-danger btn-sm\" value=\"" + obj.appointmentId + "\" style=\"margin-left:4px\">删除</button></td>";
                        }else{
                            htmlStr += "<td>处理中</td>";
                            htmlStr += "<td>" + obj.appointmentTaketime + "</td>";
                            htmlStr += "<td>" + obj.appointmentMachine  + "</td>";
                            htmlStr += "<td><button type=\"button\" class=\"btn btn-primary btn-sm\" disabled=\"disabled\" value=\"" + obj.appointmentId + "\">处理</button>";
                            htmlStr += "<button type=\"button\" class=\"btn btn-success btn-sm\" value=\"" + obj.appointmentId + "\" style=\"margin-left:4px\">结束</button>"
                            htmlStr += "<button type=\"button\" class=\"btn btn-danger btn-sm\" value=\"" + obj.appointmentId + "\" style=\"margin-left:4px\">删除</button></td>";
                        }
                        htmlStr += "</tr>";
                    });
                        //显示
                        $("#tBody").html(htmlStr);

                        //计算总页数
                        var totalPages = 1;
                        if (data.totalRows % pageSize == 0) {
                            totalPages = data.totalRows / pageSize;
                        }else{
                            totalPages = parseInt(data.totalRows / pageSize) + 1;
                        }

                        /**
                         * 翻页的
                         */
                        //调b工s_pagination具函数显示翻页信息
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
                                    queryAppointmentByConditionForPage(null,pageObj.currentPage, pageObj.rowsPerPage);
                                }else if(scan=="option2"){
                                    queryAppointmentByConditionForPage(1,pageObj.currentPage, pageObj.rowsPerPage);
                                }else if(scan=="option3"){
                                    queryAppointmentByConditionForPage(0,pageObj.currentPage, pageObj.rowsPerPage);
                                }else{
                                    queryAppointmentByConditionForPage(2,pageObj.currentPage, pageObj.rowsPerPage);
                                }
                            }
                        });

                }
            });
        }
    </script>

</head>
<body>

<!-- 处理预约的模态窗口 -->
<div class="modal fade" id="dealAppointmentModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">处理预约窗口</h4>
            </div>

            <div class="modal-body">
                <form id="dealAppointmentForm" class="form-horizontal" role="form">
                    <div class="form-group">

                        <input id="deal-appointmentId" readonly>

                        <label for="deal-appointmentMachine" class="col-sm-2 control-label">分配处理机器<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="deal-appointmentMachine" style="width: 150px">
                                <!--这里用ajax解析data的话就不能用selectpicker 它解析不了html函数我也不知道为啥……差点做死-->
                            </select>
                            <%--<select class="selectpicker" id="deal-appointmentMachine" style="width: 150px" data-live-search="true">
                                <option value="">请选择</option>
                                <c:forEach items="${machineList}" var="m">
                                    <option value="${m.machineId}">${m.machineId}</option>
                                </c:forEach>
                            </select>--%>
                        </div>

                    </div>

                </form>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveDealAppointmentBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 添加预约的模态窗口 -->
<div class="modal fade" id="createAppointmentModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">添加预约窗口</h4>
            </div>
            <div class="modal-body">

                <form id="createAppointmentForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-appointmentPatient" class="col-sm-2 control-label">患者就诊卡号<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="selectpicker" id="create-appointmentPatient" data-live-search="true">
                                <option value="">请选择</option>
                                <c:forEach items="${patientList}" var="p">
                                    <option value="${p.patientId}">${p.patientId}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-appointmentDepartment" class="col-sm-2 control-label">开具科室</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="selectpicker" id="create-appointmentDepartment">
                                <option value="">请选择</option>
                                <c:forEach items="${departmentList}" var="d">
                                    <option value="${d.departmentId}">${d.departmentName}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <lable for="create-appointmentDoctor" class="col-sm-2 control-label">开具医生</lable>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="selectpicker" id="create-appointmentDoctor">
                                <option value="">请选择</option>
                                <c:forEach items="${doctorList}" var="doc">
                                    <option value="${doc.doctorId}">${doc.doctorName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <!--<div class="col-sm-1" style="display:table-cell;vertical-align:middle">-->
                            <%--<span class="glyphicon glyphicon-remove"></span>--%>
                        <!--</div>-->
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveCreateAppointmentBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>预约列表</h3>
        </div>
    </div>
</div>

<!--来个按钮组先-->
<div id="btn-group" class="btn-group" data-toggle="buttons" style="position: relative; left: 10px; top: -10px;">
    <label class="btn btn-default active">
        <input type="radio" name="options" value="option1" checked="true">全部
    </label>
    <label class="btn btn-default">
        <input type="radio" name="options" value="option3">未处理
    </label>
    <label class="btn btn-default">
        <input type="radio" name="options" value="option4">处理中
    </label>
    <label class="btn btn-default">
        <input type="radio" name="options" value="option2">已完成
    </label>
</div>

<div style="position: relative; left: 10px; top: 2px;">
    <button type="button" class="btn btn-primary" id="createAppointmentBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
</div>

<div style="position: relative; top: 2px; left: 0px; width: 100%; height: 100%;">
    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <%--表头--%>
                    <td style="width:12.5%">创建时间</td>
                    <td style="width:12.5%">开具科室</td>
                    <td style="width:12.5%">开具医生</td>
                    <td style="width:12.5%">所属患者</td>
                    <td style="width:12.5%">是否处理</td>
                    <td style="width:12.5%">处理时间</td>
                    <td style="width:12.5%">分配机器</td>
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

