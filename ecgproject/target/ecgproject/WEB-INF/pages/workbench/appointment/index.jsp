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

    <script type="text/javascript">
        $(function () {
            //上来先刷新，默认是全部列表的界面
            queryAppointmentByConditionForPage(null,1,10);

            //修改选项
            $("input[type='radio'][name='options']").change(function () {
                var scan = $("input[name='options']:checked").val();
                if(scan=="option1"){
                    queryAppointmentByConditionForPage(null,1,10);
                }else if(scan=="option2"){
                    queryAppointmentByConditionForPage(1,1,10);
                }else{
                    queryAppointmentByConditionForPage(0,1,10);
                }
            });
        })

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
                        htmlStr += "<td>" + obj.appointmentId + "</td>";
                        htmlStr += "<td>" + obj.appointmentCreatetime + "</td>";
                        htmlStr += "<td>" + obj.appointmentPatient + "</td>";
                        if(obj.appointmentStatus=="1"){
                            htmlStr += "<td>已处理</td>";
                        }else{
                            htmlStr += "<td>未处理</td>";
                        }
                        htmlStr += "<td>" + obj.appointmentDepartment + "</td>";
                        htmlStr += "<td>" + obj.appointmentDoctor + "</td>";
                        htmlStr += "</tr>";

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
                                queryAppointmentByConditionForPage(3,pageObj.currentPage, pageObj.rowsPerPage);
                            }
                        });
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
            <h3>预约列表</h3>
        </div>
    </div>
</div>


<!--来个按钮组先-->
<div id="btn-group" class="btn-group" data-toggle="buttons" style="position: relative; left: 10px; top: -10px;">
    <label class="btn btn-default active">
        <input type="radio" name="options" value="option1" checked="true"> 全部
    </label>
    <label class="btn btn-default">
        <input type="radio" name="options" value="option2"> 已处理
    </label>
    <label class="btn btn-default">
        <input type="radio" name="options" value="option3"> 未处理
    </label>
</div>

<div style="position: relative; top: 2px; left: 0px; width: 100%; height: 100%;">
    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <%--<td><input type="checkbox" /></td>--%>
                    <td style="width:12.5%">预约编号</td>
                    <td style="width:12.5%">创建时间</td>
                    <td style="width:12.5%">所属患者</td>
                    <td style="width:12.5%">是否处理</td>
                    <td style="width:12.5%">开具科室</td>
                    <td style="width:12.5%">负责医生</td>
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

