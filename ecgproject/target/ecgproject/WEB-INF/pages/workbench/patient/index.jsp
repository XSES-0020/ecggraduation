<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2022/4/12
  Time: 17:37
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

        $(function(){
            //给创建按钮添加单击事件
            $("#createPatientBtn").click(function () {
                //初始化工作 清空表单
                $("#createPatientForm").get(0).reset();

                //弹出添加患者的模态窗口
                $("#createPatientModal").modal("show");
            });

            //给保存按钮添加单击事件
            $("#saveCreatePatientBtn").click(function () {
                //收集参数
                var patientId = $.trim($("#create-patientId").val());
                var patientName = $.trim($("#create-patientName").val());
                var patientGender = $("#create-patientGender").val();
                var patientAge = $.trim($("#create-patientAge").val());
                var patientBirthday = $("#create-patientBirthday").val();
                var patientIdCard = $.trim($("#create-patientIdCard").val());
                var patientPhone = $.trim($("#create-patientPhone").val());

                //表单验证
                if(patientId==""){
                    alert("就诊卡号不能为空");
                    return;
                }
                if(patientName==""){
                    alert("姓名不能为空");
                    return;
                }
                if(patientGender==""){
                    alert("性别不能为空");
                    return;
                }
                var regExp = /^(([1-9]\d*)|0)$/;
                if((!regExp.test(patientAge))&&(patientAge!="")){
                    alert("请输入正确年龄");
                    return;
                }

                /**
                var regExp2 = /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\\d{8}$/;
                if((!regExp2.test(patientPhone))&&(patientPhone!="")){
                    alert("请输入正确格式的手机号");
                    return;
                }

                var regExp3 = /\d{15}|\d{18}/;
                if((!regExp3.test(patientIdCard))&&(patientIdCard!="")){
                    alert("请输入正确格式的身份证号");
                    return;
                }
                 **/

                //发送请求
                $.ajax({
                    url:'workbench/patient/saveCreatePatient.do',
                    data:{
                        patientId:patientId,
                        patientName:patientName,
                        patientGender:patientGender,
                        patientAge:patientAge,
                        patientBirthday:patientBirthday,
                        patientIdcard:patientIdCard,
                        patientPhone:patientPhone
                    },
                    type:'post',
                    dataType:'json',
                    success:function (data) {
                        if(data.code=="1"){
                            //关闭模态窗口
                            $("#createPatientModal").modal("hide");
                            //刷新市场活动列
                            queryPatientByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                        }else{
                            //提示信息
                            alert(data.message);
                            //模态窗口不关
                            $("#createPatientModal").modal("show");
                        }
                    }
                });

                /**
                 * if(startDate!=""&&endDate!=""){
                 *     //用字符串大小代替日期大小
                 *     if(endDate<startDate){
                 *          alert("结束日期不能比开始日期早");
                 *          return;
                 *     }
                 * }
                 */


            });

            /**
             * 日历的
             */
            //容器加载晚之后，对容器调用工具函数
            $("#create-patientBirthday").datetimepicker({
                language:'zh-CN',
                format:'yyyy-mm-dd',
                minView:'month',
                initialDate:new Date(),
                autoclose:true,
                todayBtn:true,
                clearBtn:true
            });

            queryPatientByConditionForPage(1,10);

            $("#queryPatientBtn").click(function () {
                queryPatientByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
            });

            //不太确定 试一下吧
            $("#tBody").on("click","button[class='btn btn-danger btn-sm']",function () {
                var id = this.value;

                if(window.confirm("是否确认删除？")){
                    $.ajax({
                        url:'workbench/patient/deletePatientById.do',
                        data:{
                            id:id
                        },
                        type:'post',
                        dataType:'json',
                        success:function (data){
                            if(data.code=="1"){
                                //刷新
                                queryPatientByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                            }else{
                                //提示
                                alert(data.message);
                            }
                        }
                    });
                }
            });

            $("#tBody").on("click","button[class='btn btn-primary btn-sm']",function () {
                var id = this.value;

                $.ajax({
                    url:'workbench/patient/queryPatientById.do',
                    data:{
                        id:id
                    },
                    type:'post',
                    dataType:'json',
                    success:function (data) {
                        $("#edit-patientId").val(data.patientId);
                        $("#edit-patientName").val(data.patientName);
                        $("#edit-patientGender").val(data.patientGender);
                        if((data.patientAge!=null)&&(data.patientAge!="")){
                            $("#edit-patientAge").val(data.patientAge);
                        }
                        if((data.patientPhone!=null)&&(data.patientPhone!="")){
                            $("#edit-patientPhone").val(data.patientPhone);
                        }
                        if((data.patientIdcard!=null)&&(data.patientPhone!="")){
                            $("#edit-patientIdCard").val(data.patientIdcard);
                        }
                        if((data.patientBirthday!=null)&&(data.patientBirthday!="")){
                            $("#edit-patientBirthday").val(data.patientBirthday);
                        }

                        $("#editPatientModal").modal("show");
                    }
                })
            });

            //给更新按钮加单击事件
            $("#saveEditPatientBtn").click(function () {
                //收集参数
                var patientId = $.trim($("#edit-patientId").val());
                var patientName = $.trim($("#edit-patientName").val());
                var patientGender = $("#edit-patientGender").val();
                var patientAge = $.trim($("#edit-patientAge").val());
                var patientBirthday = $("#edit-patientBirthday").val();
                var patientIdCard = $.trim($("#edit-patientIdCard").val());
                var patientPhone = $.trim($("#edit-patientPhone").val());

                //表单验证
                if(patientName==""){
                    alert("姓名不能为空");
                    return;
                }
                if(patientGender==""){
                    alert("性别不能为空");
                    return;
                }
                var regExp = /^(([1-9]\d*)|0)$/;
                if((!regExp.test(patientAge))&&(patientAge!="")){
                    alert("请输入正确年龄");
                    return;
                }

                //发送请求
                $.ajax({
                    url:'workbench/patient/saveEditPatient.do',
                    data:{
                        patientId:patientId,
                        patientName:patientName,
                        patientGender:patientGender,
                        patientAge:patientAge,
                        patientBirthday:patientBirthday,
                        patientIdcard:patientIdCard,
                        patientPhone:patientPhone
                    },
                    type:'post',
                    dataType:'json',
                    success:function (data) {
                        if(data.code=="1"){
                            //关闭模态窗口
                            $("#editPatientModal").modal("hide");
                            //刷新市场活动列
                            queryPatientByConditionForPage($("#demo_pag1").bs_pagination('getOption','currentPage'),$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                        }else{
                            //提示信息
                            alert(data.message);
                            //模态窗口不关
                            $("#editPatientModal").modal("show");
                        }
                    }
                });
            });
        });

        /**
         * 容器加载完了就执行
         */
        function queryPatientByConditionForPage(pageNo,pageSize){
            //当市场活动主页面加载完成，查询所有数据的第一页以及所有数据的总条数
            //收集参数
            var queryName = $("#queryName").val();
            //var pageNo = 1;
            //var pageSize = 10;

            //发请求
            $.ajax({
                url: 'workbench/patient/queryPatientByConditionForPage.do',
                data: {
                    name: queryName,
                    pageNo: pageNo,
                    pageSize: pageSize
                },
                type: 'post',
                dataType: 'json',
                success: function (data) {
                    //总条数
                    //$("#totalRowsB").text(data.totalRows);
                    var htmlStr = "";
                    $.each(data.patientList, function (index, obj) {
                        htmlStr += "<tr class=\"active\">";
                        //htmlStr+=<td><input type="checkbox" /></td>;
                        htmlStr += "<td>" + obj.patientId + "</td>";
                        htmlStr += "<td>" + obj.patientName + "</td>";
                        htmlStr += "<td>" + obj.patientAge + "</td>";
                        if(obj.patientGender=="0"){
                            htmlStr += "<td>男</td>";
                        }else{
                            htmlStr += "<td>女</td>";
                        }

                        if((obj.patientBirthday!=null)&&(obj.patientBirthday!="")){
                            htmlStr += "<td>" + obj.patientBirthday + "</td>";
                        }else{
                            htmlStr += "<td></td>";
                        }

                        if((obj.patientIdcard!=null)&&(obj.patientIdcard!="")){
                            htmlStr += "<td>" + obj.patientIdcard + "</td>";
                        }else{
                            htmlStr += "<td></td>";
                        }

                        if((obj.patientPhone!=null)&&(obj.patientPhone!="")){
                            htmlStr += "<td>" + obj.patientPhone + "</td>";
                        }else{
                            htmlStr += "<td></td>";
                        }

                        /*htmlStr += "<td><button type=\"button\" class=\"btn btn-primary btn-sm\">详细</button>";*/
                        /*htmlStr += "<button type=\"button\" class=\"btn btn-success btn-sm\" style=\"margin-left:4px\">修改</button>";*/
                        htmlStr += "<td><button type=\"button\" class=\"btn btn-primary btn-sm\" value=\"" + obj.patientId + "\">修改</button>";
                        /*htmlStr += "<button type=\"button\" class=\"btn btn-danger btn-sm\" style=\"margin-left:4px\">删除</button></td>";*/
                        htmlStr += "<button type=\"button\" class=\"btn btn-danger btn-sm\" value=\"" + obj.patientId + "\" style=\"margin-left:4px\">删除</button></td>";
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
                            //js代码
                            //alert(pageObj.currentPage);
                            //alert(pageObj.rowsPerPage);
                            queryPatientByConditionForPage(pageObj.currentPage, pageObj.rowsPerPage);
                        }
                    });
                }
            });
        }

    </script>
</head>

<body>

<!-- 添加患者的模态窗口 -->
<div class="modal fade" id="createPatientModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">添加患者窗口</h4>
            </div>
            <div class="modal-body">

                <form id="createPatientForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-patientId" class="col-sm-2 control-label">就诊卡号<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-patientId">
                        </div>

                        <label for="create-patientName" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-patientName">
                        </div>
                    </div>

                    <!--
                    <div class="form-group">
                        <label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-startTime">
                        </div>
                        <label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-endTime">
                        </div>
                    </div>
                    -->

                    <div class="form-group">

                        <lable for="create-patientGender" class="col-sm-2 control-label">性别<span style="font-size: 15px; color: red;">*</span></lable>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-patientGender">
                                <option value="0">男</option>
                                <option value="1">女</option>
                            </select>
                        </div>

                        <lable for="create-patientAge" class="col-sm-2 control-label">年龄</lable>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-patientAge">
                        </div>
                    </div>

                    <div class="form-group">

                        <label for="create-patientPhone" class="col-sm-2 control-label">联系电话</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-patientPhone">
                        </div>

                        <label for="create-patientIdCard" class="col-sm-2 control-label">身份证号</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-patientIdCard">
                        </div>
                    </div>


                    <div class="form-group">
                        <label for="create-patientBirthday" class="col-sm-2 control-label">出生日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-patientBirthday" readonly>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveCreatePatientBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改患者信息的模态窗口 -->
<div class="modal fade" id="editPatientModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改患者信息</h4>
            </div>
            <div class="modal-body">

                <form id="editPatientForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-patientId" class="col-sm-2 control-label">就诊卡号<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-patientId" readonly>
                        </div>

                        <label for="create-patientName" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-patientName">
                        </div>
                    </div>

                    <!--
                    <div class="form-group">
                        <label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-startTime">
                        </div>
                        <label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-endTime">
                        </div>
                    </div>
                    -->

                    <div class="form-group">

                        <lable for="create-patientGender" class="col-sm-2 control-label">性别<span style="font-size: 15px; color: red;">*</span></lable>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-patientGender">
                                <option value="0">男</option>
                                <option value="1">女</option>
                            </select>
                        </div>

                        <lable for="create-patientAge" class="col-sm-2 control-label">年龄</lable>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-patientAge">
                        </div>
                    </div>

                    <div class="form-group">

                        <label for="create-patientPhone" class="col-sm-2 control-label">联系电话</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-patientPhone">
                        </div>

                        <label for="create-patientIdCard" class="col-sm-2 control-label">身份证号</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-patientIdCard">
                        </div>
                    </div>


                    <div class="form-group">
                        <label for="create-patientBirthday" class="col-sm-2 control-label">出生日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-patientBirthday" readonly>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveEditPatientBtn">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 导入市场活动的模态窗口 -->
<div class="modal fade" id="importActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
            </div>
            <div class="modal-body" style="height: 350px;">
                <div style="position: relative;top: 20px; left: 50px;">
                    请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
                </div>
                <div style="position: relative;top: 40px; left: 50px;">
                    <input type="file" id="activityFile">
                </div>
                <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                    <h3>重要提示</h3>
                    <ul>
                        <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                        <li>给定文件的第一行将视为字段名。</li>
                        <li>请确认您的文件大小不超过5MB。</li>
                        <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                        <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                        <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                        <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                    </ul>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>患者列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">
        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" id="queryName">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="query-owner">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">开始日期</div>
                        <input class="form-control" type="text" id="query-startDate" />
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">结束日期</div>
                        <input class="form-control" type="text" id="query-endDate">
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="queryPatientBtn">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="createPatientBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
                <button type="button" class="btn btn-default" data-toggle="modal" data-target="#editActivityModal"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
                <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal" ><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
                <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
            </div>
        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <%--<td><input type="checkbox" /></td>--%>
                    <td style="width:12.5%">就诊卡号</td>
                    <td style="width:12.5%">患者姓名</td>
                    <td style="width:12.5%">年龄</td>
                    <td style="width:12.5%">性别</td>
                    <td style="width:12.5%">出生日期</td>
                    <td style="width:12.5%">身份证号</td>
                    <td style="width:12.5%">联系电话</td>
                    <td style="width:12.5%">操作</td>
                </tr>
                </thead>
                <tbody id="tBody">

                <%--<tr class="active">
                    <td><input type="checkbox" /></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">发传单</a></td>
                    <td>zhangsan</td>
                    <td>2020-10-10</td>
                    <td>2020-10-20</td>
                </tr>
                <tr class="active">
                    <td><input type="checkbox" /></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">发传单</a></td>
                    <td>zhangsan</td>
                    <td>2020-10-10</td>
                    <td>2020-10-20</td>
                </tr>--%>
                </tbody>
            </table>

            <div id="demo_pag1"></div>
        </div>


<%--
        <div style="height: 50px; position: relative;top: 30px;">
            <div>
                <button type="button" class="btn btn-default" style="cursor: default;">共<b id="totalRowsB">50</b>条记录</button>
            </div>
            <div class="btn-group" style="position: relative;top: -34px; left: 110px;">
                <button type="button" class="btn btn-default" style="cursor: default;">显示</button>
                <div class="btn-group">
                    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                        10
                        <span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu" role="menu">
                        <li><a href="#">20</a></li>
                        <li><a href="#">30</a></li>
                    </ul>
                </div>
                <button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
            </div>
            <div style="position: relative;top: -88px; left: 285px;">
                <nav>
                    <ul class="pagination">
                        <li class="disabled"><a href="#">首页</a></li>
                        <li class="disabled"><a href="#">上一页</a></li>
                        <li class="active"><a href="#">1</a></li>
                        <li><a href="#">2</a></li>
                        <li><a href="#">3</a></li>
                        <li><a href="#">4</a></li>
                        <li><a href="#">5</a></li>
                        <li><a href="#">下一页</a></li>
                        <li class="disabled"><a href="#">末页</a></li>
                    </ul>
                </nav>
            </div>
        </div>--%>

    </div>

</div>
</body>
</html>
