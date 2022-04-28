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
    <!--引入jquery-->
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <!--引入echarts插件-->
    <script type="text/javascript" src="jquery/echarts/echarts.min.js"></script>
    <title>演示echarts</title>
    <script type="text/javascript">
        $(function () {
            $.ajax({
                url:'workbench/chart/machine/queryCountOfMachineGroupByState.do',
                type:'post',
                dataType:'json',
                success:function (data) {
                    //调用工具函数，显示图
                    var myChart = echarts.init(document.getElementById('main'));

                    var option = {
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
                                name: 'Access From',
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

                    myChart.setOption(option);
                }
            });
        });
    </script>
</head>
<body>
    <!--容器-->
    <div id="main" style="width: 80%;height:50% "></div>
</body>
</html>
