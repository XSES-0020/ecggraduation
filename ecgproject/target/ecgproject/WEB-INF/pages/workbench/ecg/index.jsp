<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2022/4/29
  Time: 22:15
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
        $(function(){
            //下拉框属性
            $(".selectpicker").selectpicker({
                language:'zh-CN',
                width:'100%',
                size:5,
                style:'',
                styleBase:'form-control'
            });

            //给保存按钮加
            $("#importEcgBtn").click(function () {
               //收集参数
               var ecgFileName = $("#ecgFile").val();
               var suffix = ecgFileName.substr(ecgFileName.lastIndexOf(".")+1).toLocaleUpperCase();
               if(suffix!="XML"){
                   alert("只支持XML格式文件");
                   return;
               }
               var ecgFile = $("#ecgFile")[0].files[0];
               if(ecgFile.size>5*1024*1024){
                   alert("文件大小不能超过5MB");
                   return;
               }
               var patientId = $("#import-patientId").val();

               var formData = new FormData();
               formData.append("ecgFile",ecgFile);
               formData.append("patientId",patientId);
               //发请求
               $.ajax({
                   url:'workbench/ecg/importEcg.do',
                   data:formData,
                   processData:false,
                   contentType:false,
                   type:'post',
                   dataType:'json',
                   success:function (data) {
                       if(data.code=="1"){
                           alert("已成功导入");
                           $("#importEcgModal").modal("hide");
                           //刷新
                           queryEcgByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                       }else{
                           //提示信息
                           alert(data.message);
                           //模态窗口不关
                           $("#importEcgModal").modal("show");
                       }
                   }
               });
            });

            queryEcgByConditionForPage(1,10);

            //查询按钮
            $("#queryEcgBtn").click(function () {
                queryEcgByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
            });

            //查看按钮
            $("#tBody").on("click","button[class='btn btn-primary btn-sm']",function () {
                var id = this.value;
                $("#showEcgModal").modal("show");
                $("#Image").attr("src",'workbench/ecg/showEcgById.do?ecgId='+id);
            });

            //删除按钮
            $("#tBody").on("click","button[class='btn btn-danger btn-sm']",function () {
                var id = this.value;
                if(window.confirm("是否确认删除？")){
                    $.ajax({
                        url:'workbench/ecg/deleteEcgById.do',
                        data:{
                            ecgId:id
                        },
                        type:'post',
                        dataType:'json',
                        success:function (data){
                            if(data.code=="1"){
                                //刷新
                                queryEcgByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
                            }else{
                                //提示
                                alert(data.message);
                            }
                        }
                    });
                }
            });

            //测试 关闭模态窗口清空数据
            $("#importEcgModal").on("hidden.bs.modal",function () {
                $("#ecgFile").val(null);
                document.getElementById("import-patientId").options.selectedIndex=0;
                $("#import-patientId").selectpicker('refresh');
            });
        });

        function queryEcgByConditionForPage(pageNo,pageSize){
            var patientId = $("#patientId").val();

            //发请求
            $.ajax({
                url: 'workbench/ecg/queryEcgByConditionForPage.do',
                data: {
                    patientId: patientId,
                    pageNo: pageNo,
                    pageSize: pageSize
                },
                type: 'post',
                dataType: 'json',
                success: function (data) {
                    var htmlStr = "";
                    $.each(data.ecgList, function (index, obj) {
                        htmlStr += "<tr class=\"active\">";
                        htmlStr += "<td>" + obj.ecgId + "</td>";
                        htmlStr += "<td>" + obj.ecgUploadtime + "</td>";
                        htmlStr += "<td>" + obj.ecgUploader + "</td>";
                        htmlStr += "<td>" + obj.ecgPatient + "</td>";
                        htmlStr += "<td><button type=\"button\" class=\"btn btn-primary btn-sm\" value=\"" + obj.ecgId + "\">查看</button>";
                        htmlStr += "<button type=\"button\" class=\"btn btn-danger btn-sm\" value=\"" + obj.ecgId + "\" style=\"margin-left:4px\">删除</button></td>";
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
                            queryEcgByConditionForPage(pageObj.currentPage, pageObj.rowsPerPage);
                        }
                    });
                }
            });
        }

    </script>
</head>
<body>

<!--查看心电图的模态窗口-->
<div class="modal fade" id="showEcgModal" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content" style="width: 800px;height: 800px;">
            <img id="Image" alt="Base64 encoded image" height="100%" width="100%"/>
        </div>
    </div>
</div>


<!-- 导入心电文件的模态窗口 -->
<div class="modal fade" id="importEcgModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">上传ecg文件窗口</h4>
            </div>
            <div class="modal-body" style="height: 350px;">
                <%--<form id="importEcgForm" class="form-horizontal" role="form">--%>
                    <div style="position: relative;top: 20px; left: 50px;">
                        请选择要上传的文件：<small style="color: gray;">[仅支持.xml]</small>
                    </div>
                    <div style="position: relative;top: 40px; left: 50px;">
                        <input type="file" id="ecgFile">
                    </div>
                    <div style="position: relative;top: 100px; left: 50px; width:20%">
                        所属的患者就诊卡号：
                    </div>
                    <div style="position: relative;top:40px; left: 50px;width: 20%">
                        <select class="selectpicker" id="import-patientId" data-live-search="true">
                            <option value=''>请选择</option>
                            <c:forEach items="${patientList}" var="p">
                                <option value="${p.patientId}">${p.patientId}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                        <h3>重要提示</h3>
                        <ul>
                            <li>操作仅针对HL7-ACEG，仅支持后缀名为XML的文件。</li>
                            <li>请确认您的文件大小不超过5MB。</li>
                            <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                            <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                        </ul>
                    </div>
                <%--</form>--%>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="importEcgBtn" type="button" class="btn btn-primary">导入</button>
            </div>
        </div>
    </div>
</div>

<!--表头-->
<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>ECG文件列表</h3>
        </div>
    </div>


</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">
        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <!--查询表单-->
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">就诊卡号</div>
                        <input class="form-control" type="text" id="patientId">
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="queryEcgBtn">查询</button>

            </form>
        </div>

        <!--功能按钮组-->
        <div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importEcgModal" ><span class="glyphicon glyphicon-import"></span> 导入</button>
            </div>
        </div>

        <!--显示部分-->
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <%--<td><input type="checkbox" /></td>--%>
                    <td style="width:20%">文件编号</td>
                    <td style="width:20%">上传时间</td>
                    <td style="width:20%">上传人</td>
                    <td style="width:20%">所属患者</td>
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
