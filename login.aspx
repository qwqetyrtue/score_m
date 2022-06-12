<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="score_m.login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link rel="stylesheet" href="resource/css/base.css"/>
    <style>
           body {
                background: var(--half_background);
        }
        .cont {
            background-color: #FFF;
            width: 400px;
            height: 300px;
            margin: 200px auto;
            box-shadow: 0 2px 4px rgba(0, 0, 0, .12), 0 0 6px rgba(0, 0, 0, .04);
            border-radius: 10px;
            display: flex;
            flex-flow: column;
            justify-content: space-around;
            align-items: center;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="cont"">
            <div>
                <asp:Label ID="Label1" runat="server" Text="角色: "></asp:Label>
                <asp:DropDownList ID="roleInput" runat="server">
                    <asp:ListItem Value="student">学生</asp:ListItem>
                    <asp:ListItem Value="admin">管理员</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div>
                <asp:Label ID="Label2" runat="server" Text="账号: "></asp:Label>
                <asp:TextBox ID="idInput" runat="server"></asp:TextBox>
            </div>
            <div>
                <asp:Label ID="Label3" runat="server" Text="密码: "></asp:Label>
                <asp:TextBox ID="passwordInput" runat="server"></asp:TextBox>
            </div>
            <div>
                <asp:Button ID="Button1" runat="server" Text=" 登 录 " OnClick="Button1_Click" />
            </div>
        </div>
    </form>
</body>
</html>
