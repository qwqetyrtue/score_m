<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="student.aspx.cs" Inherits="score_m.student1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>学生页</title>
    <link rel="stylesheet" href="resource/css/base.css" />
    <style>
        body {
            background: var(--half_background);
        }

        .cont {
            width: 90vw;
            height: 95vh;
            box-shadow: var(--base_shadow);
            margin: 2vh auto;
            border-radius: var(--base_radius);
            padding: 10px;
            display: flex;
            flex-flow: column;
            justify-content: flex-start;
            align-items: flex-start;
            background-color: #FFFFFF;
            position: relative;
        }

        .score-cont {
            width: 100%;
        }


        .out-login-button {
            position: absolute;
            right: 0;
            top: 50%;
            transform: translate(0%,-50%);
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="cont">
            <div class="msg">
                <div class="msg-title">
                    个人信息
                    <asp:Button ID="outLoginBt" runat="server" Text="退出登录" CssClass="out-login-button primary-button" OnClick="outLoginBt_Click" />
                </div>
                <div class="msg-cont">
                    <table class="descriptions">
                        <tbody>
                            <tr class="descriptions-item">
                                <th class="descriptions-item-title">学号</th>
                                <td class="descriptions-item-cont">
                                    <asp:Label ID="sidLable" runat="server" Text=""></asp:Label>
                                </td>
                                <th class="descriptions-item-title">姓名</th>
                                <td class="descriptions-item-cont">
                                    <asp:Label ID="nameLabel" runat="server" Text=""></asp:Label>
                                </td>
                                <th class="descriptions-item-title">性别</th>
                                <td class="descriptions-item-cont">
                                    <asp:Label ID="genderLabel" runat="server" Text=""></asp:Label>
                                </td>
                            </tr>
                        </tbody>
                        <tbody>
                            <tr class="descriptions-item">
                                <th class="descriptions-item-title">出生</th>
                                <td class="descriptions-item-cont">
                                    <asp:Label ID="birthLabel" runat="server" Text=""></asp:Label>
                                </td>
                                <th class="descriptions-item-title">班级</th>
                                <td class="descriptions-item-cont">
                                    <asp:Label ID="classLabel" runat="server" Text=""></asp:Label>
                                </td>
                                <th class="descriptions-item-title">创建时间</th>
                                <td class="descriptions-item-cont">
                                    <asp:Label ID="createTimeLable" runat="server" Text=""></asp:Label>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="score-cont">
                <div class="msg">
                    <div class="msg-title">
                        我的成绩
                    </div>
                    <div class="msg-cont">
                        <div class="list-cont">
                            <div class="list-item">
                                <asp:GridView ID="scoreList" runat="server"
                                    AutoGenerateColumns="false">
                                    <Columns>
                                        <asp:BoundField DataField="subject" HeaderText="学科" HtmlEncode="false" ItemStyle-Width="200" />
                                        <asp:BoundField DataField="subid" HeaderText="学科号" HtmlEncode="false" ItemStyle-Width="200" />
                                        <asp:BoundField DataField="grade" HeaderText="得分" HtmlEncode="false" ItemStyle-Width="200" />
                                        <asp:BoundField DataField="total" HeaderText="总分" HtmlEncode="false" ItemStyle-Width="200" />
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
