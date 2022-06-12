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
    public partial class student1 : System.Web.UI.Page
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

        private void reloadScoreList(string sid)
        {
            DataTable res = dbc.excList($"SELECT subject,subid,grade,total FROM score_detail WHERE sid='{sid}'");
            reloadList(scoreList, res);
        }
        private void reloadBaseMsg(string sid)
        {
            log(sid);
            DataTable res = dbc.excList($"SELECT * FROM student WHERE sid='{sid}'");
            try
            {
                string name= res.Rows[0].Field<string>("name");
                string gender = res.Rows[0].Field<string>("gender");
                DateTime birth  = res.Rows[0].Field<DateTime>("birth");
                string className = res.Rows[0].Field<string>("classid");
                DateTime createTime = res.Rows[0].Field<DateTime>("createTime");
                log(name + gender);
                sidLable.Text = sid;
                nameLabel.Text = name;
                genderLabel.Text = gender;
                birthLabel.Text = birth.ToString("yyyy年MM月dd日");
                classLabel.Text = className;
                createTimeLable.Text = createTime.ToString("yyyy年MM月dd日 hh:mm:ss ");
            }
            catch(Exception e)
            {
                log(e.Message);
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["student"] == null)
                    Response.Redirect("login.aspx");
                string sid = Session["student"] as string;
                reloadScoreList(sid);
                reloadBaseMsg(sid);
            }
        }

        protected void outLoginBt_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            Response.Redirect("login.aspx");
        }
    }
}