using score_m.dbc;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace score_m
{
    public partial class score_manage : System.Web.UI.Page
    {
        private DatabaseConnect dbc = new DatabaseConnect();

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
        private string getTimeName()
        {
            TimeSpan ts = DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0, 0);
            return Convert.ToInt64(ts.TotalSeconds).ToString();
        }

        private void reloadScore()
        {
            string classId = classDropList.Text;
            string subid = subjectDropList.Text;
            DataTable ds = dbc.excList($"SELECT * FROM score_detail WHERE classid='{classId}' AND subid='{subid}'");
            reloadList(scoreList, ds);
        }

        private void reloadOverview()
        {
            string classId = classDropList.Text;
            string subid = subjectDropList.Text;
            DataTable ds = dbc.excList($"SELECT * FROM class_and_subject_statistics WHERE classid='{classId}' AND subid='{subid}'");
            reloadList(overView, ds);
        }

        private void reloadStudentScore()
        {
            DataTable ds = null;
            string i = searchInput.Text;
            if (searchDropList.Text.Equals("name"))
            {
                ds = dbc.excList($"SELECT grade,total,subject,subid,scoreid FROM score_detail WHERE name='{i}'");
            }
            else if (searchDropList.Text.Equals("sid"))
            {
                ds = dbc.excList($"SELECT grade,total,subject,subid,scoreid FROM score_detail WHERE sid='{i}'");
            }
            reloadList(studentScore, ds);
        }

        private void initDropList()
        {
            classDropList.DataSource = dbc.excList("SELECT classid,name FROM class ORDER BY classid");
            classDropList.DataBind();

            subjectDropList.DataSource = dbc.excList("SELECT subid,name FROM subject ORDER BY subid");
            subjectDropList.DataBind();

            add_nameDropList.DataSource = dbc.excList("SELECT name,sid FROM student ORDER BY sid");
            add_nameDropList.DataBind();

            add_subjectDropList.DataSource = dbc.excList("SELECT name,subid FROM subject ORDER BY subid");
            add_subjectDropList.DataBind();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                initDropList();
                reloadScore();
                reloadOverview();
            }
        }

        protected void classDropList_SelectedIndexChanged(object sender, EventArgs e)
        {
            reloadScore();
            reloadOverview();
        }



        protected void subjectDropList_SelectedIndexChanged(object sender, EventArgs e)
        {
            reloadScore();
            reloadOverview();
        }

        protected void searchBt_Click(object sender, EventArgs e)
        {
            reloadStudentScore();
        }

        protected void addBt_Click(object sender, EventArgs e)
        {
            string sid = add_nameDropList.Text;
            string subid = add_subjectDropList.Text;
            string grade = add_gradeInput.Text;
            try
            {
                grade = Convert.ToDouble(grade).ToString("0.0");
            }
            catch (Exception)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "tip", "Toast.fire({icon: 'info', title: '请输入数字'})", true);
                return;
            }
            string scoreid = "g" + getTimeName();
            int res = dbc.exc($"INSERT INTO score (scoreid,sid,subid,grade,createTime) VALUES('{scoreid}','{sid}','{subid}',{grade},Getdate())");
            if (res == 1)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "addSuccess",
                    "Toast.fire({icon: 'success', title: '添加成功'})", true);
                reloadStudentScore();
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "addFail", "Toast.fire({icon: 'error', title: '添加失败'})", true);
            }
        }

        protected void studentScore_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            string scoreId = studentScore.Rows[e.RowIndex].Cells[0].Text;
            int res = dbc.exc($"DELETE FROM score WHERE scoreid='{scoreId}'");
            if (res == 1)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "addSuccess", "Toast.fire({icon: 'success', title: '删除成功'})", true);
                reloadStudentScore();
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "addFail", "Toast.fire({icon: 'error', title: '删除失败'})", true);
            }
        }

        protected void studentScore_RowEditing(object sender, GridViewEditEventArgs e)
        {
            studentScore.EditIndex = e.NewEditIndex;
            reloadStudentScore();
            int[] arr = { 0, 1, 2, 4 };
            foreach(var i in arr)
                (studentScore.Rows[e.NewEditIndex].Cells[i].Controls[0] as TextBox).ReadOnly = true;
        }

        protected void studentScore_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            studentScore.EditIndex = -1;
            reloadStudentScore();
        }

        protected void studentScore_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            string scoreId = (studentScore.Rows[e.RowIndex].Cells[0].Controls[0] as TextBox).Text;
            string grade = (studentScore.Rows[e.RowIndex].Cells[3].Controls[0] as TextBox).Text;
            try
            {
                grade = Convert.ToDouble(grade).ToString("0.0");
            }
            catch (Exception)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "tip", "Toast.fire({icon: 'info', title: '请输入数字'})", true);
                return;
            }
            int res = dbc.exc($"UPDATE score SET grade={grade} WHERE scoreid='{scoreId}'");
            if (res == 1)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "addSuccess", "Toast.fire({icon: 'success', title: '更新成功'})", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "addFail", "Toast.fire({icon: 'error', title: '更新失败'})", true);
            }
        }
    }
}