<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="student_manage.aspx.cs" Inherits="score_m.student_manage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>学生管理</title>
    <link rel="stylesheet" href="resource/sweetalert-11.4.14/sweetalert2.css" />
    <script src="resource/sweetalert-11.4.14/sweetalert2.js"></script>
    <link rel="stylesheet" href="resource/css/base.css" />
    <style>
        .cont {
            width: 100%;
            height: 100%;
            padding: 10px;
        }

            .cont > div {
                width: 100%;
            }

        cont > div:nth-child(n+1) {
            height: calc(100% - 30px);
        }

        .nav {
            height: 30px;
            display: flex;
            flex-flow: row;
            justify-content: flex-start;
            align-items: center;
            text-align: center;
            border-bottom: 1px solid var(--base_border_color);
            margin-bottom: 10px;
        }

            .nav > div {
                height: 100%;
                width: 90px;
                margin-right: 5px;
                cursor: pointer;
            }

            .nav > .active {
                border-bottom: 2px solid var(--base_active_color);
                color: var(--base_active_color);
            }
    </style>
    <script>
        const Toast = Swal.mixin({
            toast: true,
            position: 'top-end',
            showConfirmButton: false,
            timer: 2000,
            timerProgressBar: true,
            didOpen: (toast) => {
                toast.addEventListener('mouseenter', Swal.stopTimer)
                toast.addEventListener('mouseleave', Swal.resumeTimer)
            }
        })
        window.onload = function () {
            hideAll();
            changeFunc("show");
        }
        function hideAll() {
            document.querySelector('.show-cont').style.display = "none"
            document.querySelector('.add-cont').style.display = "none"
            document.querySelector('.nav > div:nth-child(1)').classList.remove('active');
            document.querySelector('.nav > div:nth-child(2)').classList.remove('active');
        }
        function changeFunc(func) {
            hideAll();
            switch (func) {
                case "show":
                    document.querySelector('.nav > div:nth-child(1)').classList.add('active');
                    document.querySelector('.show-cont').style.removeProperty("display")
                    break
                case "add":
                    document.querySelector('.nav > div:nth-child(2)').classList.add('active');
                    document.querySelector('.add-cont').style.removeProperty("display")
                    break;
                default: break;
            }
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div class="cont">
            <div class="nav">
                <div onclick="changeFunc('show')">查询</div>
                <div onclick="changeFunc('add')">添加</div>
            </div>
            <div class="show-cont">
                <asp:UpdatePanel runat="server" ID="UpdatePanel1">
                    <ContentTemplate>
                        <div class="select-cont">
                            <div class="select-item">
                                <span>班级:</span>
                                <div>
                                    <asp:DropDownList ID="search_classDropList"
                                        DataTextField="name"
                                        DataValueField="classid"
                                        runat="server" AutoPostBack="true"
                                        OnSelectedIndexChanged="search_classDropList_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </div>
                        <div class="list-cont">
                            <div class="list-item">
                                <asp:GridView ID="studentList" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None">
                                    <AlternatingRowStyle BackColor="White" />
                                    <Columns>
                                        <asp:BoundField DataField="name" HeaderText="姓名" HtmlEncode="false" />
                                        <asp:BoundField DataField="sid" HeaderText="学号" HtmlEncode="false" />
                                        <asp:BoundField DataField="gender" HeaderText="性别" HtmlEncode="false" />
                                        <asp:BoundField DataField="birth" DataFormatString="{0:yyyy年MM月dd日}" HeaderText="出生年月日" />
                                    </Columns>
                                    <EditRowStyle BackColor="#F5F7FA" />
                                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                    <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                                    <RowStyle BackColor="#EFF3FB" />
                                    <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                    <SortedAscendingCellStyle BackColor="#F5F7FB" />
                                    <SortedAscendingHeaderStyle BackColor="#6D95E1" />
                                    <SortedDescendingCellStyle BackColor="#E9EBEF" />
                                    <SortedDescendingHeaderStyle BackColor="#4870BE" />
                                </asp:GridView>
                            </div>
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="classDropList" EventName="SelectedIndexChanged" />
                    </Triggers>
                </asp:UpdatePanel>
                <asp:UpdatePanel runat="server" ID="UpdatePanel2">
                    <ContentTemplate>
                        <div class="select-cont">
                            <div class="select-item">
                                <span>查询条件:</span>
                                <div>
                                    <asp:DropDownList ID="searchDropList" runat="server">
                                        <asp:ListItem Value="name">姓名</asp:ListItem>
                                        <asp:ListItem Value="sid">学号</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="select-item">
                                <div>
                                    <asp:TextBox ID="searchInput" runat="server"></asp:TextBox>
                                </div>
                            </div>
                            <div class="select-item">
                                <div>
                                    <asp:Button ID="searchBt" runat="server" Text="查询" OnClick="searchBt_Click" CssClass="primary-button" />
                                </div>
                            </div>
                        </div>
                        <div class="list-cont">
                            <div class="list-item">
                                <asp:GridView ID="search_studentList"
                                    runat="server"
                                    OnRowCancelingEdit="search_studentList_RowCancelingEdit"
                                    OnRowEditing="search_studentList_RowEditing"
                                    OnRowDeleting="search_studentList_RowDeleting"
                                    OnRowUpdating="search_studentList_RowUpdating"
                                    AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None">
                                    <AlternatingRowStyle BackColor="White" />
                                    <Columns>
                                        <asp:BoundField DataField="name" HeaderText="姓名" HtmlEncode="false" />
                                        <asp:BoundField DataField="sid" HeaderText="学号" HtmlEncode="false" />
                                        <asp:TemplateField HeaderText="性别">
                                            <EditItemTemplate>
                                                <asp:DropDownList ID="genderEditDropList" runat="server">
                                                    <asp:ListItem Value="男">男</asp:ListItem>
                                                    <asp:ListItem Value="女">女</asp:ListItem>
                                                </asp:DropDownList>
                                            </EditItemTemplate>
                                            <ItemTemplate>
                                                <asp:Label ID="genderTm" runat="server" Text='<%# Bind("gender") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="班级">
                                            <EditItemTemplate>
                                                <asp:DropDownList ID="classEditDropList" runat="server" DataTextField="name" DataValueField="classid">
                                                </asp:DropDownList>
                                            </EditItemTemplate>
                                            <ItemTemplate>
                                                <asp:Label ID="classTm" runat="server" Text='<%# Bind("className") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="出生年月日">
                                            <EditItemTemplate>
                                                <input runat="server" id="editBirthInput" type="date" max="2010-01-01" />
                                            </EditItemTemplate>
                                            <ItemTemplate>
                                                <asp:Label ID="birthTm" runat="server" Text='<%# Bind("birth", "{0:yyyy年MM月dd日}") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:CommandField ShowDeleteButton="true" ButtonType="Button">
                                            <ControlStyle CssClass="danger-button" />
                                        </asp:CommandField>
                                        <asp:CommandField ShowEditButton="true" ButtonType="Button" CancelText="返回">
                                            <ControlStyle CssClass="primary-button" />
                                        </asp:CommandField>
                                    </Columns>
                                    <EditRowStyle BackColor="#F5F7FA" />
                                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                    <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                                    <RowStyle BackColor="#EFF3FB" />
                                    <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                    <SortedAscendingCellStyle BackColor="#F5F7FB" />
                                    <SortedAscendingHeaderStyle BackColor="#6D95E1" />
                                    <SortedDescendingCellStyle BackColor="#E9EBEF" />
                                    <SortedDescendingHeaderStyle BackColor="#4870BE" />
                                </asp:GridView>
                            </div>
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="searchBt" EventName="Click" />
                        <asp:AsyncPostBackTrigger ControlID="search_studentList" EventName="RowEditing" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
            <div class="add-cont">
                <asp:UpdatePanel ID="UpdatePanel3" runat="server" class="insert-cont">
                    <ContentTemplate>
                        <div class="insert-form">
                            <div class="insert-form-item">
                                <span>姓名:</span>
                                <asp:TextBox ID="nameInput" runat="server"></asp:TextBox>
                            </div>
                            <div class="insert-form-item">
                                <span>学号:</span>
                                <asp:TextBox ID="sidInput" runat="server"></asp:TextBox>
                            </div>
                            <div class="insert-form-item">
                                <span>性别:</span>
                                <asp:DropDownList ID="genderDropLis" runat="server">
                                    <asp:ListItem Value="男">男性</asp:ListItem>
                                    <asp:ListItem Value="女">女性</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="insert-form-item">
                                <span>出生:</span>
                                <input name="birthInput" id="birthInput" type="date" max="2010-01-01" runat="server" />
                            </div>
                            <div class="insert-form-item">
                                <span>班级:</span>
                                <asp:DropDownList ID="classDropList"
                                    DataTextField="name"
                                    DataValueField="classid"
                                    runat="server">
                                </asp:DropDownList>
                            </div>
                            <div class="insert-form-item submit-item">
                                <asp:Button ID="addBt" runat="server" Text="添加" OnClick="addBt_Click" class="primary-button" />
                            </div>
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="addBt" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </form>
</body>
</html>
