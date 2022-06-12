using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace score_m
{
    public partial class admin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if(Session["admin"] == null)
            {
                Response.Redirect("login.aspx");
            }
        }

        protected void navBT1_Click(object sender, EventArgs e)
        {
            cont.Attributes.Add("src", "score_manage.aspx");
        }

        protected void navBT2_Click(object sender, EventArgs e)
        {
            cont.Attributes.Add("src", "student_manage.aspx");
        }

        protected void navBT3_Click(object sender, EventArgs e)
        {
            cont.Attributes.Add("src", "class_manage.aspx");
        }

        protected void navBT4_Click(object sender, EventArgs e)
        {
            cont.Attributes.Add("src", "subject_manage.aspx");
        }

        protected void outLoginBT_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            Response.Redirect("login.aspx");
        }
    }
}