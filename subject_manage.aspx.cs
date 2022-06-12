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
    public partial class subject_manage : System.Web.UI.Page
    {

        private DatabaseConnect dbc = new DatabaseConnect();
        private void initDropList()
        {
        }
        private void log(string str)
        {
            System.Diagnostics.Debug.WriteLine(str);
        }

        private void reloadSubjectList()
        {
            DataTable res = dbc.excList("SELECT * FROM subject");
            reloadList(subjectList, res);
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

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                reloadSubjectList();
            }
        }

        protected void refreshBT_Click(object sender, EventArgs e)
        {
            reloadSubjectList();
        }

        protected void subjectList_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            string subId = subjectList.Rows[e.RowIndex].Cells[0].Text;
            log(subId);
            int res = dbc.exc($"DELETE FROM subject WHERE subid='{subId}'");
            if (res == 1)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "deleteSuccess",
                    "Toast.fire({icon: 'success', title: '删除成功'})", true);
                reloadSubjectList();
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "deleteFail", "Toast.fire({icon: 'error', title: '删除失败'})", true);
            }
        }

        protected void addBt_Click(object sender, EventArgs e)
        {
            string subId = subIdInput.Text;
            string subName = subNameInput.Text;
            string total = totalInput.Text;
            int res = dbc.exc($"INSERT INTO subject (subid,name,total,createTime) VALUES ('{subId}','{subName}',{total},Getdate())");
            if (res == 1)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "addSuccess",
                    "Toast.fire({icon: 'success', title: '添加成功'})", true);
                reloadSubjectList();
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "addFail", "Toast.fire({icon: 'error', title: '添加失败'})", true);
            }
        }
    }
}