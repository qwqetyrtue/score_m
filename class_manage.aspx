<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="class_manage.aspx.cs" Inherits="score_m.class_manage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>班级管理</title>
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
        <asp:ScriptManager runat="server" ID="ScriptManager1"></asp:ScriptManager>
        <div class="cont">
            <div class="nav">
                <div onclick="changeFunc('show')">查询</div>
                <div onclick="changeFunc('add')">添加</div>
            </div>
            <div class="show-cont">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <div class="select-cont">
                            <div class="select-item">
                                <span>班级名:</span>
                                <div>
                                    <asp:TextBox ID="classNameInput" runat="server"></asp:TextBox>
                                </div>
                            </div>
                            <div class="select-item">
                                <div>
                                    <asp:Button ID="selectBt" runat="server" Text="查询" class="primary-button" OnClick="selectBt_Click"/>
                                </div>
                            </div>
                        </div>
                        <div class="list-cont">
                            <div class="list-item">
                                <asp:GridView ID="classList" runat="server"
                                    CellPadding="4"
                                    ForeColor="#333333"
                                    OnRowUpdating="classList_RowUpdating"
                                    OnRowEditing="classList_RowEditing"
                                    OnRowCancelingEdit="classList_RowCancelingEdit"
                                    OnRowDeleting="classList_RowDeleting"
                                    AutoGenerateColumns="False">
                                    <AlternatingRowStyle BackColor="White" />
                                    <Columns>
                                        <asp:BoundField DataField="classid" HeaderText="班级号" HtmlEncode="false" />
                                        <asp:BoundField DataField="name" HeaderText="班级名" HtmlEncode="false" />
                                        <asp:BoundField DataField="createTime" HeaderText="创建时间" HtmlEncode="false" DataFormatString="{0:yyyy年MM月dd日 HH:mm:ss}" />
                                        <asp:TemplateField ShowHeader="False">
                                            <ItemTemplate>
                                                <asp:Button ID="Button3" runat="server" CausesValidation="False" CommandName="Delete" Text="删除" />
                                            </ItemTemplate>
                                            <ControlStyle CssClass="danger-button" />
                                        </asp:TemplateField>
                                        <asp:TemplateField ShowHeader="False">
                                            <EditItemTemplate>
                                                <asp:Button ID="Button1" runat="server" CausesValidation="True" CommandName="Update" Text="更新" />
                                                &nbsp;<asp:Button ID="Button2" runat="server" CausesValidation="False" CommandName="Cancel" Text="返回" />
                                            </EditItemTemplate>
                                            <ItemTemplate>
                                                <asp:Button ID="Button2" runat="server" CausesValidation="False" CommandName="Edit" Text="编辑" />
                                            </ItemTemplate>
                                            <ControlStyle CssClass="primary-button" />
                                        </asp:TemplateField>
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
                    </Triggers>
                </asp:UpdatePanel>
            </div>
            <div class="add-cont">
                <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                    <ContentTemplate>
                        <div class="insert-cont">
                            <div class="insert-form">
                                <div class="insert-form-item">
                                    <span>班级号:
                                    </span>
                                    <div>
                                        <asp:TextBox ID="add_classIdInput" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="insert-form-item">
                                    <span>班级名称:
                                    </span>
                                    <div>
                                        <asp:TextBox ID="add_classNameInput" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="insert-form-item submit-item">
                                    <asp:Button ID="addBt" runat="server" Text="添加班级" CssClass="primary-button" OnClick="addBt_Click" />
                                </div>
                            </div>
                        </div>
                    </ContentTemplate>
                    <Triggers>
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </form>
</body>
</html>
