<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2022/3/29
  Time: 0:44
  To change this template use File | Settings | File Templates.
--%>
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>山羊の前端小窝</title>
    <style>
        * {
            list-style-type: none;
            padding: 0;
            margin: 0;
        }

        body {
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #d3dafa;
        }
        .shell{
            position:fixed;
            width: 280px;
            height: 650px;
            background-color: #8a98c9;
        }
        .buttons{
            margin: 60px 0;
            color: #fff;
        }
        .li{
            letter-spacing: 2px;
            font: 600 17px '';
            padding: 16px 52px;
            transition: .3s;
        }
        .li::after{
            content: '';
            position: absolute;
            left: 20px;
            margin-top: -22px;
            display: block;
            width: 20px;
            height: 20px;
            background-color: #fff;
            border-radius: 50%;
        }
        .buttons>li:hover{
            background-color: #beb5df;
        }

        .li ul{
            width: 0;
            height: 530px;
            padding: 60px 0;
            position: absolute;
            top: 0;
            right: 0;
            overflow: hidden;
            background-color: #59699b;
            transition: .3s;
        }

        .li ul li{
            padding: 16px 24px;
            transition: .3s;
        }

        .li:hover ul{
            width: 228px;
        }
        .li ul li:hover{
            background-color: #828eb9;
        }
    </style>
</head>
<body>
<nav class="shell">
    <ul class="buttons">
        <li class="li">
            management
            <ul>
                <li>Sold  baby</li>
                <li>Evaluation</li>
                <li>Shopkeeper</li>
                <li>Management</li>
            </ul>
        </li>

        <li class="li">
            logisitcs
            <ul>
                <li>Warehouse    </li>
                <li>deliver goods</li>
                <li>stock        </li>
                <li>mail         </li>
                <li>return goods </li>
            </ul>
        </li>

        <li class="li">
            treasure
            <ul>
                <li>Release baby   </li>
                <li>Posting Details</li>
                <li>Shop decoration</li>
            </ul>
        </li>

        <li class="li">
            financial service
            <ul>
                <li>payment              </li>
                <li>Loan goods           </li>
                <li>Collection in advance</li>
            </ul>
        </li>
    </ul>
</nav>
</body>
</html>
