<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2022/4/26
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
    <!--引入echarts插件-->
    <script type="text/javascript" src="jquery/echarts/echarts.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $.ajax({
                url:'workbench/chart/machine/queryCountOfMachineGroupByState.do',
                type:'post',
                dataType:'json',
                success:function (data) {
                    //调用工具函数，显示图
                    var myChart1 = echarts.init(document.getElementById('chart1'));

                    var option1 = {
                        title:{
                          text:'机器状态分布图',
                          subtext: '各个状态机器数的占比'
                        },
                        tooltip: {
                            trigger: 'item'
                        },
                        legend: {
                            top: '5%',
                            left: 'center'
                        },
                        series: [
                            {
                                name: '机器状态分布图',
                                type: 'pie',
                                radius: ['40%', '70%'],
                                avoidLabelOverlap: false,
                                itemStyle: {
                                    borderRadius: 10,
                                    borderColor: '#fff',
                                    borderWidth: 2
                                },
                                label: {
                                    show: false,
                                    position: 'center'
                                },
                                emphasis: {
                                    label: {
                                        show: true,
                                        fontSize: '40',
                                        fontWeight: 'bold'
                                    }
                                },
                                labelLine: {
                                    show: false
                                },
                                data:data
                            }
                        ]
                    };

                    myChart1.setOption(option1);
                }
            });

            $.ajax({
                url:'workbench/chart/machine/queryCountOfMachineGroupByTime.do',
                type:'post',
                dataType:'json',
                success:function (data) {
                    //调用工具函数，显示图
                    var myChart2 = echarts.init(document.getElementById('chart2'));

                    var option2 = {
                        title:{
                            text:'机器使用次数图',
                            subtext: '使用次数前五的机器'
                        },
                        xAxis: {
                            type: 'category',
                            data: data.xAxis
                        },
                        yAxis: {
                            type: 'value'
                        },
                        series: [
                            {
                                data: data.series,
                                type: 'bar'
                            }
                        ]
                    };

                    myChart2.setOption(option2);
                }
            });


        });
    </script>
</head>
<body>

    <div>
        <div class="col-sm-6" id="chart1" style="top: 5%;width: 50%;height:50% "></div>
        <div class="col-sm-6" id="chart2" style="top: 5%;width: 50%;height:50% "></div>
    </div>

</body>
</html>
