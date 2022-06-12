using score_m.dbc;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace score_m
{
    public partial class student_manage : System.Web.UI.Page
    {
        private DatabaseConnect dbc = new DatabaseConnect();
        private void initDropList()
        {
            DataTable classs = dbc.excList("SELECT classid,name FROM class ORDER BY classid");
            classDropList.DataSource = classs;
            classDropList.DataBind();
            search_classDropList.DataSource = classs;
            search_classDropList.DataBind();
        }
        private void log(string str)
        {
            System.Diagnostics.Debug.WriteLine(str);
        }

        private void reloadStudentList()
        {
            string classId = search_classDropList.SelectedValue;
            DataTable res = dbc.excList($"SELECT name,sid,gender,birth FROM student WHERE classid='{classId}'");
            reloadList(studentList, res);
        }
        private void reloadSearchStudentList()
        {
            string searchConf = searchDropList.Text;
            string value = searchInput.Text;
            DataTable res;
            switch (searchConf)
            {
                case "name":
                    res = dbc.excList($"SELECT  student.name as name,sid,gender,birth,class.name as className FROM student,class WHERE student.classid=class.classid AND student.name LIKE '%{value}%'");
                    break;
                case "sid":
                    res = dbc.excList($"SELECT  student.name as name,sid,gender,birth,class.name as className FROM student,class WHERE student.classid=class.classid AND sid LIKE '%{value}%'");
                    break;
                default: return;
            }
            reloadList(search_studentList, res);
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
                initDropList();
                reloadStudentList();
            }
        }

        protected void search_classDropList_SelectedIndexChanged(object sender, EventArgs e)
        {
            reloadStudentList();
        }

        protected void searchBt_Click(object sender, EventArgs e)
        {
            reloadSearchStudentList();
        }

        protected void addBt_Click(object sender, EventArgs e)
        {
            string name = nameInput.Text;
            string sid = sidInput.Text;
            string gender = genderDropLis.SelectedValue;
            string classId = classDropList.SelectedValue;
            string birth = birthInput.Value;
            log(name + sid + gender + classId + birth);
            int res = dbc.exc($"INSERT INTO student (name,sid,gender,classid,birth,createTime) VALUES ('{name}','{sid}','{gender}','{classId}','{birth}',Getdate())");
            if (res == 1)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "addSuccess", "Toast.fire({icon: 'success', title: '添加成功'})", true);
                reloadSearchStudentList();
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "addFail", "Toast.fire({icon: 'error', title: '添加失败'})", true);
            }
        }
        
        protected void search_studentList_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            string sid = search_studentList.Rows[e.RowIndex].Cells[1].Text;
            int res = dbc.exc($"DELETE FROM student WHERE sid='{sid}'");
            if (res == 1)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "addSuccess", "Toast.fire({icon: 'success', title: '删除成功'})", true);
                reloadSearchStudentList();
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "addFail", "Toast.fire({icon: 'error', title: '删除失败'})", true);
            }
        }

        protected void search_studentList_RowEditing(object sender, GridViewEditEventArgs e)
        {
            search_studentList.EditIndex = e.NewEditIndex;
            string gender = ((search_studentList.Rows[e.NewEditIndex].Cells[2].Controls[0] as LiteralControl).FindControl("genderTm") as Label).Text.Trim();
            string class_ = ((search_studentList.Rows[e.NewEditIndex].Cells[3].Controls[0] as LiteralControl).FindControl("classTm") as Label).Text.Trim();
            string birth = ((search_studentList.Rows[e.NewEditIndex].Cells[4].Controls[0] as LiteralControl).FindControl("birthTm") as Label).Text.Trim();
            birth = birth.Replace("年", "-");
            birth = birth.Replace("月", "-");
            birth = birth.Replace("日", "");
            DataTable classs = dbc.excList("SELECT classid,name FROM class ORDER BY classid");
            reloadSearchStudentList();
            DropDownList classEdit = ((search_studentList.Rows[e.NewEditIndex].Cells[2].Controls[0] as LiteralControl).FindControl("classEditDropList") as DropDownList);
            ((search_studentList.Rows[e.NewEditIndex].Cells[2].Controls[0] as LiteralControl).FindControl("genderEditDropList") as DropDownList).SelectedValue = gender;
            classEdit.DataSource = classs;
            classEdit.DataBind();
            classEdit.Items.FindByText(class_).Selected = true;
            ((search_studentList.Rows[e.NewEditIndex].Cells[2].Controls[0] as LiteralControl).FindControl("editBirthInput") as HtmlInputGenericControl).Value = birth;
            System.Diagnostics.Debug.WriteLine(null);
            (search_studentList.Rows[e.NewEditIndex].Cells[1].Controls[0] as TextBox).ReadOnly = true;
        }

        protected void search_studentList_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            search_studentList.EditIndex = -1;
            reloadSearchStudentList();
        }

        protected void search_studentList_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            string name = (search_studentList.Rows[e.RowIndex].Cells[0].Controls[0] as TextBox).Text;
            string sid = (search_studentList.Rows[e.RowIndex].Cells[1].Controls[0] as TextBox).Text;
            string classId = ((search_studentList.Rows[e.RowIndex].Cells[2].Controls[0] as LiteralControl).FindControl("classEditDropList") as DropDownList).SelectedValue;
            string gender = ((search_studentList.Rows[e.RowIndex].Cells[2].Controls[0] as LiteralControl).FindControl("genderEditDropList") as DropDownList).SelectedValue;
            string birth = ((search_studentList.Rows[e.RowIndex].Cells[2].Controls[0] as LiteralControl).FindControl("editBirthInput") as HtmlInputGenericControl).Value;

            int res = dbc.exc($"UPDATE student SET name='{name}',classid='{classId}',gender='{gender}',birth='{birth}' WHERE sid='{sid}'");
            if (res == 1)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "addSuccess","Toast.fire({icon: 'success', title: '更新成功'})", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "addFail", "Toast.fire({icon: 'error', title: '更新失败'})", true);
            }
        }
    }
}