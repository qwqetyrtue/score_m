<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="admin.aspx.cs" Inherits="score_m.admin" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>管理页</title>
    <link rel="stylesheet" href="resource/css/base.css" />
    <style>
        body {
            background: var(--half_background);
        }

        .navBT {
            display: none;
        }

        .cont {
            width: 90vw;
            height: 95vh;
            box-shadow: var(--base_shadow);
            margin: 2vh auto;
            border-radius: var(--base_radius);
            padding: 10px;
            display: flex;
            flex-flow: row;
            justify-content: space-between;
            align-items: center;
            background-color: #FFFFFF;
            position: relative;
        }

        .nav {
            height: 100%;
            width: 100px;
            border-right: 1px solid var(--base_border_color);
            display: flex;
            flex-flow: column;
            justify-content: start;
            align-items: center;
            position: relative;
        }

            .nav > div {
                width: 100%;
                height: 50px;
                line-height: 50px;
                border-bottom: 1px solid var(--base_border_color);
                text-align: center;
                cursor: pointer;
            }

                .nav > div:hover {
                    text-decoration: underline 1px solid var(--base_active_color);
                }

            .nav > .outLoginBT {
                position: absolute;
                bottom: 0px;
                left: 0px;
            }

        .main {
            height: 100%;
            width: calc(100% - 100px - 10px);
        }

            .main > iframe {
                width: 100%;
                height: calc(100% - 50px);
            }

        .nav-active {
            color: var(--base_active_color);
            border-right: 1px solid #FFFFFF;
        }

        .main-title {
            display: flex;
            flex-flow: row;
            justify-content: start;
            align-items: center;
            text-align: center;
            height: 50px;
            width: 100%;
            border-bottom: 1px solid var(--base_border_color);
        }

            .main-title span {
                margin: 0 3px;
            }

                .main-title span:first-child {
                    color: #000;
                }

                .main-title span:last-child {
                    color: var(--base_active_color);
                    cursor: pointer;
                }

                    .main-title span:last-child:hover {
                        text-decoration: underline 1px solid var(--base_active_color);
                    }

    </style>
    <script>
        window.onload = function () {
            console.log(new Date())
            let main = document.querySelector('.main>iframe');
            let now_title = document.querySelector('.now-title');
            if (main.src.endsWith("score_manage.aspx")) {
                document.querySelector('.nav>div:nth-child(1)').classList.add('nav-active');
                now_title.textContent = "成绩管理"
            } else if (main.src.endsWith("student_manage.aspx")) {
                document.querySelector('.nav>div:nth-child(2)').classList.add('nav-active');
                now_title.textContent = "学生管理"
            } else if (main.src.endsWith("class_manage.aspx")) {
                document.querySelector('.nav>div:nth-child(3)').classList.add('nav-active');
                now_title.textContent = "班级管理"
            } else {
                document.querySelector('.nav>div:nth-child(4)').classList.add('nav-active');
                now_title.textContent = "学科管理"
            }
        }
        function navChangeHandle(navBT) {
            document.querySelector(navBT).click();
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="cont">
            <div class="nav">
                <div onclick="navChangeHandle('.navBT1')">成绩管理<asp:Button ID="navBT1" runat="server" Text="" class="navBT navBT1" OnClick="navBT1_Click" /></div>
                <div onclick="navChangeHandle('.navBT2')">学生管理<asp:Button ID="navBT2" runat="server" Text="" class="navBT navBT2" OnClick="navBT2_Click" /></div>
                <div onclick="navChangeHandle('.navBT3')">班级管理<asp:Button ID="navBT3" runat="server" Text="" class="navBT navBT3" OnClick="navBT3_Click" /></div>
                <div onclick="navChangeHandle('.navBT4')">学科管理<asp:Button ID="navBT4" runat="server" Text="" class="navBT navBT4" OnClick="navBT4_Click" /></div>
                <asp:Button ID="outLoginBT" runat="server" Text="退出登录" class="outLoginBT primary-button" OnClick="outLoginBT_Click"/>
            </div>
            <div class="main">
                <div class="main-title">
                    <span>首页</span>
                    <span>></span>
                    <span class="now-title"></span>
                </div>
                <iframe src="score_manage.aspx" id="cont" runat="server" style="border: none;" />
            </div>
        </div>
    </form>
</body>
</html>
