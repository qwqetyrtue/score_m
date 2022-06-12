using score_m.dbc;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace score_m
{
    public partial class class_manage : System.Web.UI.Page
    {
        private DatabaseConnect dbc = new DatabaseConnect();
        private void log(string str)
        {
            System.Diagnostics.Debug.WriteLine(str);
        }
        private string getTimeName()
        {
            TimeSpan ts = DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0, 0);
            return Convert.ToInt64(ts.TotalSeconds).ToString();
        }
        private void reloadList(GridView list, DataTable ds)
        {
            if (ds.Rows.Count == 0)
            {
                ds.Rows.Add(ds.NewRow());
                list.DataSource = ds;
                list.DataBind();
                int columnCount = list.Rows[0].Cells.Count;
                list.Rows[0].Cells.Clear();
                list.Rows[0].Cells.Add(new TableCell());
                list.Rows[0].Cells[0].ColumnSpan = columnCount;
                list.Rows[0].Cells[0].Text = "暂无数据.";
            }
            else
            {
                list.DataSource = ds;
                list.DataBind();
            }
        }

        private void reloadClassList()
        {
            string name = classNameInput.Text;
            DataTable res = dbc.excList($"SELECT * FROM class WHERE name LIKE '%{name}%'");
            reloadList(classList, res);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                reloadClassList();
            }
        }

        protected void selectBt_Click(object sender, EventArgs e)
        {
            string name = classNameInput.Text;
            DataTable res = dbc.excList($"SELECT * FROM class WHERE name LIKE '%{name}%'");
            reloadList(classList, res);
        }

        protected void classList_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            classList.EditIndex = -1;
            reloadClassList();
        }

        protected void classList_RowEditing(object sender, GridViewEditEventArgs e)
        {
            classList.EditIndex = e.NewEditIndex;
            reloadClassList();
            (classList.Rows[e.NewEditIndex].Cells[0].Controls[0] as TextBox).ReadOnly = true;
            (classList.Rows[e.NewEditIndex].Cells[2].Controls[0] as TextBox).ReadOnly = true;
        }

        protected void classList_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            string classId = (classList.Rows[e.RowIndex].Cells[0].Controls[0] as TextBox).Text;
            string className = (classList.Rows[e.RowIndex].Cells[1].Controls[0] as TextBox).Text;
            int res = dbc.exc($"UPDATE class SET name='{className}' WHERE classid='{classId}'");
            if (res == 1)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "updateSuccess",
                    "Toast.fire({icon: 'success', title: '更新成功'})", true);
                reloadClassList();
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "updateFail", "Toast.fire({icon: 'error', title: '更新失败'})", true);
            }
        }

        protected void classList_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            string classId = classList.Rows[e.RowIndex].Cells[0].Text;
            log(classId);
            int res = dbc.exc($"DELETE FROM class WHERE classid='{classId}'");
            if (res == 1)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "deleteSuccess",
                    "Toast.fire({icon: 'success', title: '删除成功'})", true);
                reloadClassList();
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "deleteFail", "Toast.fire({icon: 'error', title: '删除失败'})", true);
            }
        }

        protected void addBt_Click(object sender, EventArgs e)
        {
            string classId = add_classIdInput.Text;
            string className = add_classNameInput.Text;
            log(classId);
            int res = dbc.exc($"INSERT INTO class (classid,name,createTime) VALUES ('{classId}','{className}',Getdate())");
            if (res == 1)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "addSuccess",
                    "Toast.fire({icon: 'success', title: '添加成功'})", true);
                reloadClassList();
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "addFail", "Toast.fire({icon: 'error', title: '添加失败'})", true);
            }
        }
    }
}