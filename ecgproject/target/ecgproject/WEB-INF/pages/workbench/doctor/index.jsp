<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2022/4/22
  Time: 23:39
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
                        htmlStr += "<td>" + obj.doctorAge + "</td>";
                        htmlStr += "<td>" + obj.doctorGender + "</td>";
                        htmlStr += "<td>" + obj.doctorDepartment + "</td>";
                        htmlStr += "<td>" + obj.doctorTitle + "</td>";
                        htmlStr += "<td>" + obj.doctorPhone + "</td>";
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
                                queryDoctorByConditionForPage(pageObj.currentPage, pageObj.rowsPerPage);
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
            <h3>医生列表</h3>
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

                <button type="button" class="btn btn-default" id="queryDoctorBtn">查询</button>

            </form>
        </div>

        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <%--<td><input type="checkbox" /></td>--%>
                    <td style="width:12.5%">医生工号</td>
                    <td style="width:12.5%">医生姓名</td>
                    <td style="width:12.5%">年龄</td>
                    <td style="width:12.5%">性别</td>
                    <td style="width:12.5%">科室</td>
                    <td style="width:12.5%">职称</td>
                    <td style="width:12.5%">联系电话</td>
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
